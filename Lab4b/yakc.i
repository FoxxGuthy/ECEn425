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

void YKScheduler(void);

void YKDispatcher();

extern int YKCtxSwCount;

extern int YKIdleCount;
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






struct TCB {
    unsigned *sp;
    unsigned char state;
    unsigned char priority;
    struct TCB *nextTask;
    int delayCount;
};


struct TCB TCBArray[6];



int YKCtxSwCount = 0;
int YKIdleCount = 0;
int YKTickNum = 0;
struct TCB *taskhead;
struct TCB *currentTask = 0;
struct TCB *nextTask;
char YKKernalStarted = 0;

int TCBIdx = 0;

void YKIdleTask(void);
void dumpLists(void);

int YKIdleStk[256];

void YKInitialize(void){


 printString("IN YKINITIALIZE");
 YKNewTask(YKIdleTask, (void *)&YKIdleStk[256], 100);


 currentTask = &TCBArray[0];
}


void YKIdleTask(void){
 printString("IN YKIdleTask");
}

void YKNewTask(void (* task)(void), void *taskStack, unsigned char priority){

 unsigned *newSP;
 TCBArray[TCBIdx].state = 1;
 TCBArray[TCBIdx].priority = priority;

 TCBArray[TCBIdx].delayCount = 0;

 newSP = (unsigned *) taskStack - 11;
# 82 "yakc.c"
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

 YKKernalStarted = 1;

 YKScheduler();
}

void YKScheduler(void){
 struct TCB *traveser;
 traveser = taskhead;
 printString("IN YKScheduler");
 printNewLine();
 while(traveser){
  if(traveser->state == 1){
   nextTask = traveser;
   break;
  }
  traveser = traveser->nextTask;
 }

 if(nextTask != currentTask){




  YKDispatcher();
  currentTask = nextTask;

 }

}
