/*STATE OF THE PROGRAM



*/

#include "yakk.h"
#include "clib.h"

#define DELAYED 0
#define READY 1


// Task-Control-Block that holds the information for each running task
struct TCB {
    unsigned *sp;        // stack pointer
    unsigned char state;// = 0; // running = 1, delayed, suspended
    unsigned char priority;// = 0;
    struct TCB *nextTask;
    int delayCount;// = 0;
};

// Allocation of memory for the tasks
struct TCB TCBArray[MAXTASKS];



int YKCtxSwCount = 0; // global variable used to track number of context switches
int YKIdleCount = 0;
int YKTickNum = 0;
struct TCB *taskhead;
struct TCB *currentTask = NULL;
struct TCB *taskSaveCTX = NULL;
struct TCB *nextTask;
char YKKernalStarted = 0;

int TCBIdx = 0; // variable used to indicate the next ready TCB object in array

void YKIdleTask(void);               /* Function prototypes for task code */
void dumpLists(void);

int YKIdleStk[IDLESTACKSIZE];           /* Space for each task's stack */

void YKInitialize(void){


	printString("IN YKINITIALIZE");
	YKNewTask(YKIdleTask, (void *)&YKIdleStk[IDLESTACKSIZE], 100);
	// the idle task will always be initialized to memory index of 0
	// since the operating system needs a current task to start with, will say the current task is the IDLE task
	taskSaveCTX = &TCBArray[0];
}


void YKIdleTask(void){
	printString("IN YKIdleTask");
}

void YKNewTask(void (* task)(void), void *taskStack, unsigned char priority){
	//int i = 3;
	unsigned *newSP;
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
		}else{
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
	dumpLists();
	if(YKKernalStarted == 1){
		YKScheduler();
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

void YKRun(void){
	printString("IN YKRun");
	printNewLine();
    /* Set global flag to indicate kernel started */
	YKKernalStarted = 1;
    /* Call scheduler */
	YKScheduler();
}

void YKScheduler(void){
	struct TCB *traveser;
	traveser = taskhead;
	printString("IN YKScheduler");
	printNewLine();
	while(traveser){
		if(traveser->state == READY){
			nextTask = traveser;
			break;
		}
		traveser = traveser->nextTask;
	}

	if(nextTask != currentTask){

		currentTask = nextTask;
		printString("Calling Dispatcher to dispatch task with priority ");
		printInt(nextTask->priority);
		printNewLine();
		YKDispatcher();

		
	}
	
}






