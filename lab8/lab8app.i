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




struct msg MsgArray[20];

int SimpCommTaskStk[512];
int NewPieceTaskStk[512];
int StatsTaskStk[512];


void *MsgQ[10];
YKQ *MsgQPtr;

void SimpCommTask(void)
{
    struct msg *tmp;

    while (1)
    {
        tmp = (struct msg *) YKQPend(MsgQPtr);


        if (tmp->tick != count+1)
        {
            print("! Dropped msgs: tick ", 21);
            if (tmp->tick - (count+1) > 1) {
                printInt(count+1);
                printChar('-');
                printInt(tmp->tick-1);
                printNewLine();
            }
            else {
                printInt(tmp->tick-1);
                printNewLine();
            }
        }


        count = tmp->tick;


        if (tmp->data < min)
            min = tmp->data;
        if (tmp->data > max)
            max = tmp->data;


        print("Ticks: ", 7);
        printInt(count);
        print("\t", 1);
        print("Min: ", 5);
        printInt(min);
        print("\t", 1);
        print("Max: ", 5);
        printInt(max);
        printNewLine();
    }
}

void NewPieceTask(void)
{

}

void StatsTask(void)
{

}

void main(void)
{
    YKInitialize();

    MsgQPtr = YKQCreate(MsgQ, 10);
    YKNewTask(StatsTask, (void *) &StatsTaskStk[512], 50);
    YKNewTask(SimpCommTask, (void *) &SimpCommTaskStk[512], 30);
    YKNewTask(NewPieceTask, (void *) &NewPieceTaskStk[512], 10);


    YKRun();
}
