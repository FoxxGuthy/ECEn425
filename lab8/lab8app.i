# 1 "lab8app.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "lab8app.c"






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
# 8 "lab8app.c" 2
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
# 9 "lab8app.c" 2
# 1 "lab6defs.h" 1
# 9 "lab6defs.h"
struct msg
{
    int pieceID;
    int cmd;
    int direction;

};
# 10 "lab8app.c" 2
# 1 "simptris.h" 1


void SlidePiece(int ID, int direction);
void RotatePiece(int ID, int direction);
void SeedSimptris(long seed);
void StartSimptris(void);
# 11 "lab8app.c" 2
# 21 "lab8app.c"
struct msg MsgArray[20];

int SimpCommTaskStk[512];
int NewPieceTaskStk[512];
int StatsTaskStk[512];


void *MsgQ[10];
YKQ *MsgQPtr;

YKSEM *RCSemPtr;
YKSEM *NPSemPtr;

extern unsigned NewPieceType;
extern unsigned NewPieceOrientation;

void SimpCommTask(void)
{
struct msg *tmp;

while (1)
  {
  YKSemPend(RCSemPtr);
  tmp = (struct msg *) YKQPend(MsgQPtr);
    if(tmp->cmd == 0){
      SlidePiece(tmp->pieceID, tmp->direction);
    }else{
      RotatePiece(tmp->pieceID, tmp->direction);
    }
  }
}

void NewPieceTask(void)
{
  while(1){
  YKSemPend(NPSemPtr);

  }
}

void StatsTask(void)
{
    unsigned max, switchCount, idleCount;
    int tmp;

    YKIdleCount = 0;
    YKDelayTask(5);
    max = YKIdleCount / 25;
    YKIdleCount = 0;

    YKNewTask(SimpCommTask, (void *) &SimpCommTaskStk[512], 30);
    YKNewTask(NewPieceTask, (void *) &NewPieceTaskStk[512], 10);

    while (1)
    {
        YKDelayTask(20);

        YKEnterMutex();
        switchCount = YKCtxSwCount;
        idleCount = YKIdleCount;
        YKExitMutex();

        printString("<CS: ");
        printInt((int)switchCount);
        printString(", CPU: ");
        tmp = (int) (idleCount/max);
        printInt(100-tmp);
        printString("% >\r\n");

        YKEnterMutex();
        YKCtxSwCount = 0;
        YKIdleCount = 0;
        YKExitMutex();
    }

}

int main(void)
{
  YKInitialize();

  MsgQPtr = YKQCreate(MsgQ, 10);

  YKNewTask(StatsTask, (void *) &StatsTaskStk[512], 50);

  SeedSimptris(10947);

  NPSemPtr = YKSemCreate(0);
  RCSemPtr = YKSemCreate(1);

  StartSimptris();
  YKRun();

}
