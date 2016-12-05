# 1 "yakc.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "yakc.c"
# 1 "yakk.h" 1


# 1 "yaku.h" 1
# 4 "yakk.h" 2







typedef int YKSEM;


typedef struct {
  void **queueAddress;
  unsigned length;
  void **nextEmpty;
  void **nextRemove;
  unsigned state;

} YKQ;

typedef struct {
  unsigned value;
} YKEVENT;

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

extern int YKTickNum;

extern YKSEM *NSemPtr;

void YKDelayTask(unsigned count);

void YKEnterISR(void);

void YKExitISR(void);

void YKTickHandler(void);



YKSEM* YKSemCreate(int initialValue);

void YKSemPend(YKSEM *semaphore);

void YKSemPost(YKSEM *semaphore);



YKQ *YKQCreate(void **start, unsigned size);

void *YKQPend(YKQ *queue);

int YKQPost(YKQ *queue, void *msg);



YKEVENT *YKEventCreate(unsigned initialValue);

unsigned YKEventPend(YKEVENT *event, unsigned eventMask, int waitMode);

void YKEventSet(YKEVENT *event, unsigned eventMask);

void YKEventReset(YKEVENT *event, unsigned eventMask);
# 2 "yakc.c" 2
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
# 3 "yakc.c" 2
# 1 "yaku.h" 1
# 4 "yakc.c" 2
# 21 "yakc.c"
struct TCB {
    unsigned *sp;
    unsigned char state;
    unsigned char priority;
    struct TCB *nextTask;
   YKSEM *blocker;
    YKQ *qblocker;
    YKEVENT *eblocker;
    unsigned eventMask;
    int waitMode;
    int delayCount;
};

struct TCB *taskhead;
struct TCB *currentTask = 0;
struct TCB *taskSaveCTX = 0;
struct TCB *nextTask;

int TCBIdx = 0;
int SEMIdx = 0;
int YKQIdx = 0;
int YKEIdx = 0;


struct TCB TCBArray[10];

YKSEM SEMArray[64];

YKQ YKQArray[8];

YKEVENT YKEArray[8];



int YKISRDepth = 0;
int YKCtxSwCount = 0;
int YKIdleCount = 0;
int YKTickNum = 0;


char YKKernalStarted = 0;

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
 YKEnterMutex();
 TCBArray[TCBIdx].state = 1;
 TCBArray[TCBIdx].priority = priority;

 TCBArray[TCBIdx].delayCount = 0;

 newSP = (unsigned *) taskStack - 11;
# 122 "yakc.c"
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
 if(0){
  dumpLists();
 }

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

 YKKernalStarted = 1;

 YKScheduler(0);
}

void YKScheduler(char saveCTX){

 struct TCB *traveser;
 traveser = taskhead;
 YKEnterMutex();
 printDebug("IN YKScheduler");
 if(0){
  printString("SaveContext: ");
  printInt(saveCTX);
  printNewLine();
 }
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
      dumpLists();
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



YKSEM* YKSemCreate(int initialValue){

 YKSEM *temp;
 if(initialValue < 0){

  if(0 == 1){
   printString("PROBLEM: Semaphore initialized with negative value!");
   printNewLine();
  }
  return 0;
 }

 temp = &SEMArray[SEMIdx];
 *temp = initialValue;
 SEMIdx++;
 return temp;

}

void YKSemPend(YKSEM *semaphore){
 YKEnterMutex();
 if(*semaphore == 0){
  currentTask->state = 3;
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
  if(traveser->state == 3){


   if(traveser->blocker == semaphore){
    traveser->state = 1;
    traveser->blocker = 0;
    break;
   }
  }
  traveser = traveser->nextTask;
 }

 if (YKISRDepth == 0) {
  YKScheduler(1);
 }
 YKExitMutex();

}



YKQ *YKQCreate(void **start, unsigned size) {
  YKQArray[YKQIdx].length = size;
 YKQArray[YKQIdx].queueAddress = start;
 YKQArray[YKQIdx].nextEmpty = start;
  YKQArray[YKQIdx].nextRemove = start;
  YKQArray[YKQIdx].state = 0;

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
 if(queue->state == 0){
  currentTask->state = 4;
  currentTask->qblocker = queue;
  YKScheduler(1);
 }
  tempmsg = (void *) *queue->nextRemove;

  queue->nextRemove++;
  if(queue->nextRemove == queue->queueAddress + queue->length){
    queue->nextRemove = queue->queueAddress;

  }

  if(queue->state == 1){
    queue->state = 2;
  }else if(queue->nextRemove == queue->nextEmpty){
    queue->state = 0;
  }
  if(0) debugQueue(queue);
 YKExitMutex();
  return tempmsg;
}

int YKQPost(YKQ *queue, void *msg) {
  struct TCB *traveser;
  YKEnterMutex();

 if(queue->state == 1){
    return 0;
 }
  *queue->nextEmpty = msg;
  queue->nextEmpty++;
  if(queue->nextEmpty == queue->queueAddress + queue->length){
    queue->nextEmpty = queue->queueAddress;
  }

  if(queue->state == 0){
    queue->state = 2;
  }else if(queue->nextRemove == queue->nextEmpty){
    queue->state = 1;
  }
  if(0) debugQueue(queue);

  traveser = taskhead;

 while(traveser){
  if(traveser->state == 4){


   if(traveser->qblocker == queue){
    traveser->state = 1;
    traveser->qblocker = 0;
    break;
   }
  }
  traveser = traveser->nextTask;
 }

 if (YKISRDepth == 0) {
  YKScheduler(1);
 }

 YKExitMutex();

  return 1;
}



YKEVENT *YKEventCreate(unsigned initialValue) {
  YKEArray[YKEIdx].value = initialValue;

  YKEIdx++;

  return &YKEArray[YKEIdx-1];
}

unsigned YKEventPend(YKEVENT *event, unsigned eventMask, int waitMode) {

  YKEnterMutex();
  if(waitMode == 1){
      if(eventMask == event->value){
          return event->value;
      }else{
        currentTask->state = 5;
        currentTask->eblocker = event;
        currentTask->eventMask = eventMask;
        currentTask->waitMode = waitMode;
        YKScheduler(1);
      }
  }else{


      if(eventMask & event->value){
          return event->value;
      }else{
        currentTask->state = 5;
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
  event->value = event->value | eventMask;

  YKEnterMutex();

  traveser = taskhead;

 while(traveser){
  if(traveser->state == 5){


   if(traveser->eblocker == event){
        if(traveser->waitMode == 1){
            if(traveser->eventMask == event->value){
              traveser->state = 1;
              traveser->eblocker = 0;
              traveser->eventMask = 0;
              traveser->waitMode = 0;
            }
          }else{


            if(traveser->eventMask & event->value){
              traveser->state = 1;
              traveser->eblocker = 0;
              traveser->eventMask = 0;
              traveser->waitMode = 0;
            }
          }
        }
   }
  traveser = traveser->nextTask;
 }

 if (YKISRDepth == 0) {
  YKScheduler(1);
 }
  YKExitMutex();
}

void YKEventReset(YKEVENT *event, unsigned eventMask) {
  event->value = event->value & (~eventMask);
}
