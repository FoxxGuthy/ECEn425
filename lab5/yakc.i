# 1 "yakc.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "yakc.c"







# 1 "yakk.h" 1


# 1 "yaku.h" 1
# 4 "yakk.h" 2

void YKInitialize(void);

void YKEnterMutex(void);

void YKExitMutex(void);

void YKIdleTask(void);

void YKNewTask(void (* task)(void), void *taskStack, unsigned char priority);

void YKRun(void);

void YKScheduler(char saveCTX);

void YKDispatcher(char saveCTX);

extern int YKCtxSwCount;

extern int YKIdleCount;



void YKDelayTask(unsigned count);

void YKEnterISR(void);

void YKExitISR(void);

void YKTickHandler(void);
# 9 "yakc.c" 2
# 1 "clib.h" 1



void print(char *string, int length);
void printNewLine(void);
void printChar(char c);
void printString(char *string);


void printInt(int val);
void printLong(long val);
void printUInt(unsigned val);
void printULong(unsigned long val);


void printByte(char val);
void printWord(int val);
void printDWord(long val);


void exit(unsigned char code);


void signalEOI(void);
# 10 "yakc.c" 2
# 19 "yakc.c"
struct TCB {
    unsigned *sp;
    unsigned char state;
    unsigned char priority;
    struct TCB *nextTask;
    int delayCount;
};


struct TCB TCBArray[6];

int YKISRDepth = 0;

int YKCtxSwCount = 0;
int YKIdleCount = 0;
int YKTickNum = 0;
struct TCB *taskhead;
struct TCB *currentTask = 0;
struct TCB *taskSaveCTX = 0;
struct TCB *nextTask;
char YKKernalStarted = 0;

int TCBIdx = 0;

void YKIdleTask(void);
void dumpLists(void);

int YKIdleStk[256];

void printDebug(char *string) {
 if(0 == 1){
  printString(string);
  printNewLine();
 }
}

void YKInitialize(void){

 YKEnterMutex();
 printDebug("IN YKINITIALIZE - CHECK");
 YKNewTask(YKIdleTask, (void *)&YKIdleStk[256], 100);



}


void YKIdleTask(void){
 while(1){

  YKEnterMutex();
  YKIdleCount++;
  YKExitMutex();
 }
}

void YKNewTask(void (* task)(void), void *taskStack, unsigned char priority){

 unsigned *newSP;
 TCBArray[TCBIdx].state = 1;
 TCBArray[TCBIdx].priority = priority;

 TCBArray[TCBIdx].delayCount = 0;

 newSP = (unsigned *) taskStack - 11;
# 98 "yakc.c"
 newSP[0] = 0;
 newSP[1] = 0;
 newSP[2] = 0;
 newSP[3] = 0;
 newSP[4] = 0;
 newSP[5] = 0;
 newSP[6] = 0;
 newSP[7] = 0;
 newSP[7] = 0;
 newSP[8] = (unsigned) task;
 newSP[9] = 0;
 newSP[10] = 0x0200;

 TCBArray[TCBIdx].sp = newSP-1;


 if(TCBIdx == 0){
  taskhead = &TCBArray[TCBIdx];
  TCBArray[TCBIdx].nextTask = 0;

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
  YKScheduler(1);

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
 printDebug("IN YKRun");

 YKKernalStarted = 1;

 YKScheduler(0);
}

void YKScheduler(char saveCTX){

 struct TCB *traveser;
 traveser = taskhead;
 YKEnterMutex();
 printDebug("IN YKScheduler");
 while(traveser){
  if(traveser->state == 1){
   nextTask = traveser;
   break;
  }
  traveser = traveser->nextTask;
 }

 if(nextTask != currentTask){
  YKCtxSwCount++;
  taskSaveCTX = currentTask;
  currentTask = nextTask;
  if(0){
   printString("Calling Dispatcher to dispatch task with priority ");
   printInt(nextTask->priority);
   printNewLine();
  }
  YKDispatcher(saveCTX);

 }

}

void YKDelayTask(unsigned newDelayCount) {


 YKEnterMutex();
 if(newDelayCount == 0){
  return ;
 }
 currentTask->delayCount = newDelayCount;
 currentTask->state = 0;

 YKScheduler(1);
 YKExitMutex();

}

void YKEnterISR(void) {

 YKISRDepth++;
}

void YKExitISR(void) {


 YKISRDepth--;
 if (YKISRDepth == 0) {
  YKScheduler(1);
  YKExitMutex();
 }
}

void YKTickHandler(void) {




 struct TCB *traveser;
 traveser = taskhead;

 YKTickNum++;
 printDebug("IN YKTickHandler");
 while(traveser){
  if(traveser->state == 0){
   traveser->delayCount--;

   if(traveser->delayCount == 0){

    if(0 == 1){
     printString("task now READY with priority ");
     printInt(traveser->priority);
     printNewLine();
    }

    traveser->state = 1;
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
