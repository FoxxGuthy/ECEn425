# 1 "simptris_inth.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "simptris_inth.c"



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
# 5 "simptris_inth.c" 2
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
# 6 "simptris_inth.c" 2



extern YKSEM *NPSemPtr;
extern YKSEM *RCSemPtr;
extern YKSEM *TDSemPtr;
 void gameOverISRC(void) {
    exit(0);
 }

 void newPieceISRC(void) {

    YKSemPost(NPSemPtr);
 }

 void receivedCommandISRC(void) {
    YKSemPost(RCSemPtr);
 }

 void touchdownISRC(void) {
   YKSemPost(TDSemPtr);

 }

 void lineclearISRC(void) {

 }
