/*STATE OF THE PROGRAM

CRASHES During YKDISPATCH -
Problems: 	currentTask and nextTask are not being accessed correctly. Data members not correct.
			Can't push ip onto the stack
			(Know how to fix, need to do) -- YKNewTask doesn't actually insert into correct spot

*/

#include "yakk.h"
#include "clib.h"

#define DELAYED 0
#define READY 1


// Task-Control-Block that holds the information for each running task
struct TCB {
    int *sp;        // stack pointer
    int programCounter;
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
struct TCB *nextTask;
char YKKernalStarted = 0;

int TCBIdx = 0; // variable used to indicate the next ready TCB object in array

void YKIdleTask(void);               /* Function prototypes for task code */
void dumpLists(void);

int YKIdleStk[IDLESTACKSIZE];           /* Space for each task's stack */

void YKInitialize(void){


	printString("IN YKINITIALIZE");
	YKNewTask(YKIdleTask, (void *)&YKIdleStk[IDLESTACKSIZE], 100);
	
}


void YKIdleTask(void){
	printString("IN YKIdleTask");
}

void YKNewTask(void (* task)(void), void *taskStack, unsigned char priority){

	TCBArray[TCBIdx].state = READY;
	TCBArray[TCBIdx].priority = priority;
	TCBArray[TCBIdx].sp = taskStack;
	TCBArray[TCBIdx].delayCount = 0;

	if(TCBIdx == 0){
		taskhead = &TCBArray[TCBIdx];
		TCBArray[TCBIdx].nextTask = NULL;

	}else{
		struct TCB *traveser;
		traveser = taskhead;
		if(priority < taskhead->priority){
		
			TCBArray[TCBIdx].nextTask = taskhead;
			taskhead = &TCBArray[TCBIdx];
		}
	}
	TCBIdx++;
	dumpLists();
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
	}

	if(nextTask != currentTask){
		currentTask = nextTask;
		// call the dispatcher
		YKDispatcher();
		
	}
	
}






