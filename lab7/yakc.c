#include "yakk.h"
#include "clib.h"
#include "yaku.h"

// THE "STATES" OF TASKS
#define DELAYED 0
#define READY 1
#define RUNNING 2
#define BLOCKED 3
#define QBLOCKED 4
#define EBLOCKED 5

#define QEMPTY 0
#define QFULL 1
#define QNEITHER 2


#define DEBUG_MODE 0

// Task-Control-Block that holds the information for each running task
struct TCB {
    unsigned *sp;        // stack pointer
    unsigned char state; // 0 = ready, 1 = DELAYED, 2 = ??, 3 = ??
    unsigned char priority;// = 0;
    struct TCB *nextTask;
	  YKSEM *blocker;		// semaphore that is blocking this task. NULL if no sem is blocking.
    YKQ   *qblocker;  // queue that is blocking this task. NULL if no queue is blocking
    YKEVENT   *eblocker;  // event that is blocking this task. NULL if no queue is blocking
    unsigned eventMask;   // mask that this task is waiting for to become unblocked
    int waitMode;         // mode of the task that it is waiting for
    int delayCount;// = 0;
};

struct TCB *taskhead;           //POINTER TO THE HEAD of TASK LIST
struct TCB *currentTask = NULL;
struct TCB *taskSaveCTX = NULL;
struct TCB *nextTask;

int TCBIdx = 0; // variable used to indicate the next ready TCB object in array
int SEMIdx = 0; // variable used to indicate the next ready SEM object in array
int YKQIdx = 0; // variable used to indicate the next ready YKQ object in array
int YKEIdx = 0; // variable used to indicate the next ready YKE object in array

// Allocation of memory for the tasks
struct TCB TCBArray[MAXTASKS];
// Allocation of memory for the semaphores
YKSEM SEMArray[MAXSEMS];
//Allocation of memory for the queues
YKQ YKQArray[MAXQ];
//Allocation of memory for the queues
YKEVENT YKEArray[MAXE];

// MISC. GLOBAL VARIABLES ------------------------------------------------------------

int YKISRDepth = 0; // variable changed by EnterISR & ExitISR. represents ISR call depth
int YKCtxSwCount = 0; // global variable used to track number of context switches
int YKIdleCount = 0;
int YKTickNum = 0; // this global is used in myinth.c as well.


char YKKernalStarted = 0;

void YKIdleTask(void);               /* Function prototypes for task code */
void dumpLists(void);

int YKIdleStk[IDLESTACKSIZE];           /* Space for each task's stack */



// RTOS FUNCTIONS --------------------------------------------------------------

void printDebug(char *string) {
	if(DEBUG_MODE == 1){
		printString(string);
		printNewLine();
	}
}

void YKInitialize(void){

	YKEnterMutex();
	printDebug("IN YKINITIALIZE - CHECK");
	YKNewTask(YKIdleTask, (void *)&YKIdleStk[IDLESTACKSIZE], 100);
	// the idle task will always be initialized to memory index of 0
	// since the operating system needs a current task to start with, will say the current task is the IDLE task
	//taskSaveCTX = &TCBArray[0];
}

void YKIdleTask(void){
	while(1){
		//printDebug("IN YKIdleTask");
		YKEnterMutex();
		YKIdleCount++;
		YKExitMutex();
	}
}

void YKNewTask(void (* task)(void), void *taskStack, unsigned char priority){
	//int i = 3;
	unsigned *newSP;
	YKEnterMutex();
	TCBArray[TCBIdx].state = READY;
	TCBArray[TCBIdx].priority = priority;
	//TCBArray[TCBIdx].sp = taskStack;
	TCBArray[TCBIdx].delayCount = 0;

	newSP = (unsigned *) taskStack - 11;

	/*
	pop		ds		; pop everything but ip, cs, and flags (reverse order of course)
	pop		es
	pop		bp
	pop		di
	pop		si
	pop		dx
	pop		cx
	pop		bx
	pop		ax
	iret			; start next task. iret takes care of ip, cs, and flags
	*/

	newSP[0] = 0;					// initialize the ds register
	newSP[1] = 0;					// initialize the es register
	newSP[2] = 0;					// initialize the bp register
	newSP[3] = 0;					// initialize the di register
	newSP[4] = 0;					// initialize the si register
	newSP[5] = 0;					// initialize the dx register
	newSP[6] = 0;					// initialize the cx register
	newSP[7] = 0;					// initialize the bx register
	newSP[7] = 0;					// initialize the ax register
	newSP[8] = (unsigned) task;				// initialize the ip "register" on the stack
	newSP[9] = 0;					// initialize the cs "register" on the stack
	newSP[10] = 0x0200;		// initialize the flags "register" on the stack

	TCBArray[TCBIdx].sp = newSP-1;


	if(TCBIdx == 0){
		taskhead = &TCBArray[TCBIdx];
		TCBArray[TCBIdx].nextTask = NULL;

	}else{

		if(priority < taskhead->priority){

			TCBArray[TCBIdx].nextTask = taskhead;
			taskhead = &TCBArray[TCBIdx];
		}
    else{
			struct TCB *traveser;
			traveser = taskhead;

			while(traveser){
				if(priority < traveser->nextTask->priority){
					TCBArray[TCBIdx].nextTask = traveser->nextTask;
					traveser->nextTask = &TCBArray[TCBIdx];
					break;
				}
				traveser = traveser->nextTask;
			}
		}

	}
	TCBIdx++;
	if(DEBUG_MODE){
		dumpLists();
	}

	if(YKKernalStarted == 1){
		YKScheduler(1);
		// TODO: Look into possibility of adding a YKExitMutex() here
	}
}

void dumpLists(){
	struct TCB *traveser;
	traveser = taskhead;
	printNewLine();
	printString("TCBList: ");
	while(traveser){
		printString("[");
		printInt(traveser->priority);
		printString(",");
		printInt(traveser->state);
		printString(",");
		printInt(traveser->delayCount);
		printString("] ");

		traveser = traveser->nextTask;

	}
	printNewLine();
}

void dumpSems(){
	int i = 0;
	printString("Sem Values: ");
	for(i=0; i<SEMIdx; i++){
		printInt(SEMArray[i]);
		printString(" | ");

	}
	printNewLine();
}

void YKRun(void){
	printDebug("IN YKRun");
    /* Set global flag to indicate kernel started */
	YKKernalStarted = 1;
    /* Call scheduler */
	YKScheduler(0);
}

void YKScheduler(char saveCTX){

	struct TCB *traveser;
	traveser = taskhead;
	YKEnterMutex();
	printDebug("IN YKScheduler");
	if(DEBUG_MODE){
		printString("SaveContext: ");
		printInt(saveCTX);
		printNewLine();
	}
	while(traveser){
		if(traveser->state == READY){
			nextTask = traveser;
			break;
		}
		traveser = traveser->nextTask;
	}

	if(nextTask != currentTask){
		YKCtxSwCount++;
		taskSaveCTX = currentTask;
		currentTask = nextTask;
		if(DEBUG_MODE){
			printString("Calling Dispatcher to dispatch task with priority ");
			printInt(nextTask->priority);
			printNewLine();
		}
		YKDispatcher(saveCTX);
		//YKExitMutex(); // Causes fatal crash on lab4d --> Need to look into
	}

}

void YKDelayTask(unsigned newDelayCount) {
	// set task datamember to delayCount
	// set ready = 0; // blocked
	YKEnterMutex();
	if(newDelayCount == 0){
		return ;
	}
	currentTask->delayCount = newDelayCount;
	currentTask->state = DELAYED;

	YKScheduler(1);
	YKExitMutex();

}

void YKEnterISR(void) {
	/* Increment interrupt nesting level global variable */
	YKISRDepth++;
}

void YKExitISR(void) {
    /* Decrement interrupt nest level global variable */
    /* If nesting level is 0, call scheduler */
	YKISRDepth--;
	if (YKISRDepth == 0) {
		YKScheduler(1);
		YKExitMutex();
	}
}

void YKTickHandler(void) {
	// traverse the list of tasks (recall that we are only doing 1 list of tasks)
	// If the task is blocked, decrement the delay count
	// if the delay count is now 0, change the task status to ready

	struct TCB *traveser;
	traveser = taskhead;

	YKTickNum++;
	printDebug("IN YKTickHandler");
	while(traveser){
		if(traveser->state == DELAYED){
			traveser->delayCount--;

			if(traveser->delayCount == 0){

				if(DEBUG_MODE == 1){
					printString("task now READY with priority ");
					printInt(traveser->priority);
					printNewLine();
				}

				traveser->state = READY;
			}

			if(traveser->delayCount < 0){
				printString("SOMETHING HAS GONE HORRIBLY WRONG -- TASK HAS DELAY COUNT < 0. Priority: ");
				printInt(traveser->priority);
				printNewLine();
			}

		}
		traveser = traveser->nextTask;
	}
}

// --- SEMAPHORES ---

YKSEM* YKSemCreate(int initialValue){

	YKSEM *temp;
	if(initialValue < 0){

		if(DEBUG_MODE == 1){
			printString("PROBLEM: Semaphore initialized with negative value!");
			printNewLine();
		}
		return NULL;
	}

	temp = &SEMArray[SEMIdx];
	*temp = initialValue;
	SEMIdx++;
	return temp;

}

void YKSemPend(YKSEM *semaphore){
	YKEnterMutex();
	if(*semaphore == 0){
		currentTask->state = BLOCKED;
		currentTask->blocker = semaphore;
		YKScheduler(1);
	}
	(*semaphore)--;
	YKExitMutex();

}

void YKSemPost(YKSEM *semaphore){


	struct TCB *traveser;

	YKEnterMutex();
	(*semaphore)++;
	traveser = taskhead;

	while(traveser){
		if(traveser->state == BLOCKED){

			// if the task is blocked because of the semaphore we just posted
			if(traveser->blocker == semaphore){
				traveser->state = READY;
				traveser->blocker = NULL;
				break;
			}
		}
		traveser = traveser->nextTask;
	}

	if (YKISRDepth == 0) { // we are not in an isr
		YKScheduler(1);
	}
	YKExitMutex();

}

// --- MESSAGE QUEUES

YKQ *YKQCreate(void **start, unsigned size) {
  YKQArray[YKQIdx].length = size;
	YKQArray[YKQIdx].queueAddress = start;
	YKQArray[YKQIdx].nextEmpty = start;
  YKQArray[YKQIdx].nextRemove = start;
  YKQArray[YKQIdx].state = QEMPTY;

  YKQIdx++;

  return &YKQArray[YKQIdx-1];

}

void debugQueue(YKQ *queue){
  printString("YKQ STRUCT: ");
  printWord((int) queue->nextEmpty);
  printString(", ");
  printWord((int) queue->nextRemove);
  printNewLine();
}

void *YKQPend(YKQ *queue) {
  void *tempmsg;

  YKEnterMutex();
	if(queue->state == QEMPTY){
		currentTask->state = QBLOCKED;
		currentTask->qblocker = queue;
		YKScheduler(1);
	}
  tempmsg = (void *) *queue->nextRemove;

  queue->nextRemove++;
  if(queue->nextRemove == queue->queueAddress + queue->length){
    queue->nextRemove = queue->queueAddress;

  }

  if(queue->state == QFULL){
    queue->state = QNEITHER;
  }else if(queue->nextRemove == queue->nextEmpty){
    queue->state = QEMPTY;
  }
  if(DEBUG_MODE)  debugQueue(queue);
	YKExitMutex();
  return tempmsg;
}

int YKQPost(YKQ *queue, void *msg) {
  struct TCB *traveser;
  YKEnterMutex();

	if(queue->state == QFULL){
    return 0;
	}
  *queue->nextEmpty = msg;
  queue->nextEmpty++;
  if(queue->nextEmpty == queue->queueAddress + queue->length){
    queue->nextEmpty = queue->queueAddress;
  }

  if(queue->state == QEMPTY){
    queue->state = QNEITHER;
  }else if(queue->nextRemove == queue->nextEmpty){
    queue->state = QFULL;
  }
  if(DEBUG_MODE)  debugQueue(queue);

  traveser = taskhead;

	while(traveser){
		if(traveser->state == QBLOCKED){

			// if the task is blocked because of the semaphore we just posted
			if(traveser->qblocker == queue){
				traveser->state = READY;
				traveser->qblocker = NULL;
				break;
			}
		}
		traveser = traveser->nextTask;
	}

	if (YKISRDepth == 0) { // we are not in an isr
		YKScheduler(1);
	}

	YKExitMutex();

  return 1;
}

// --- EVENTS --

YKEVENT *YKEventCreate(unsigned initialValue) {
  YKEArray[YKEIdx].value = initialValue;

  YKEIdx++;

  return &YKEArray[YKEIdx-1];
}

unsigned YKEventPend(YKEVENT *event, unsigned eventMask, int waitMode) {

  YKEnterMutex();
  if(waitMode == EVENT_WAIT_ALL){
      if(eventMask == event->value){
          return event->value;
      }else{
        currentTask->state = EBLOCKED;
        currentTask->eblocker = event;
        currentTask->eventMask = eventMask;
        currentTask->waitMode = waitMode;
        YKScheduler(1);
      }
  }else{
      //bitwise and the mask and the value. If any of the bits match, the result
      //will be non zero and the if statement true.
      if(eventMask & event->value){
          return event->value;
      }else{
        currentTask->state = EBLOCKED;
        currentTask->eblocker = event;
        currentTask->eventMask = eventMask;
        currentTask->waitMode = waitMode;
        YKScheduler(1);
      }
  }

	YKExitMutex();
  return event->value;
}

void YKEventSet(YKEVENT *event, unsigned eventMask) {

  struct TCB *traveser;
  event->value = eventMask;

  YKEnterMutex();

  traveser = taskhead;

	while(traveser){
		if(traveser->state == EBLOCKED){

			// if the task is blocked because of the event we just set
			if(traveser->eblocker == event){
        if(traveser->waitMode == EVENT_WAIT_ALL){
            if(traveser->eventMask == event->value){
              traveser->state = READY;
              traveser->eblocker = NULL;
              traveser->eventMask = NULL;
              traveser->waitMode = NULL;
            }
          }else{
            //bitwise and the mask and the value. If any of the bits match, the result
            //will be non zero and the if statement true.
            if(traveser->eventMask & event->value){
              traveser->state = READY;
              traveser->eblocker = NULL;
              traveser->eventMask = NULL;
              traveser->waitMode = NULL;
            }
          }
        }
			}
		traveser = traveser->nextTask;
	}

	if (YKISRDepth == 0) { // we are not in an isr
		YKScheduler(1);
	}
  YKExitMutex();
}

void YKEventReset(YKEVENT *event, unsigned eventMask) {
  event->value = eventMask;
}
