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
# 27 "lab8app.c"
struct msg MsgArray[80];
int nextMsg = 0;


int SimpCommTaskStk[512];
int NewPieceTaskStk[512];
int StatsTaskStk[512];


void *MsgQ[40];
YKQ *MsgQPtr;

YKSEM *RCSemPtr;
YKSEM *NPSemPtr;
YKSEM *TDSemPtr;

extern unsigned NewPieceType;
extern unsigned NewPieceOrientation;
extern unsigned NewPieceColumn;
extern unsigned NewPieceID;
extern unsigned ScreenBitMap0;
extern unsigned ScreenBitMap1;
extern unsigned ScreenBitMap2;
extern unsigned ScreenBitMap3;
extern unsigned ScreenBitMap4;
extern unsigned ScreenBitMap5;




char bin0B = 0;
char bin1B = 0;
char bin0BL = 0;
char bin1BL = 0;


char bin0A = 0;
char bin1A = 0;
char bin0AL = 0;
char bin1AL = 0;

void addToQueue(int pieceID, int cmd, int direction){

  MsgArray[nextMsg].pieceID = pieceID;
  MsgArray[nextMsg].cmd = cmd;
  MsgArray[nextMsg].direction = direction;
  if(0==1){
    printString("ATQ: CMD:");
    printInt(cmd);
    printString(" DIR:");
    printInt(direction);
    printNewLine();
  }

  if (YKQPost(MsgQPtr, (void *) &(MsgArray[nextMsg])) == 0)
   printString("  addToQ: queue overflow! \n");
 else if (++nextMsg >= 80)
   nextMsg = 0;

}

void setOrientation(int Orientation){
  int dif = NewPieceOrientation - Orientation;

  switch(dif) {
    case -3:
      addToQueue(NewPieceID, 1, 1);
      break;
    case -2:
      addToQueue(NewPieceID, 1, 0);
      addToQueue(NewPieceID, 1, 0);
      break;
    case -1:
      addToQueue(NewPieceID, 1, 0);
      break;
    case 0:
      break;
    case 1:
      addToQueue(NewPieceID, 1, 1);
      break;
    case 2:
      addToQueue(NewPieceID, 1, 1);
      addToQueue(NewPieceID, 1, 1);
      break;
    case 3:
      addToQueue(NewPieceID, 1, 0);
      break;
    default:
      break;

  }
  return ;
}

void setColumn(int Column){
  int i = 0;
  int dif;
  if(NewPieceColumn > Column){
    dif = NewPieceColumn - Column;
    for(i=0;i<dif;i++){
      addToQueue(NewPieceID, 0, 0);
    }
  }else if(NewPieceColumn < Column){
      dif = Column - NewPieceColumn;
      for(i=0;i<dif;i++){
        addToQueue(NewPieceID, 0, 1);
      }
  }


  return ;
}

void SimpCommTask(void)
{
struct msg *tmp;
while (1)
  {
  YKSemPend(RCSemPtr);
  tmp = (struct msg *) YKQPend(MsgQPtr);
  if(0==1){
    printString("C: ");
    printInt(tmp->cmd);
    printString(" D: ");
    printInt(tmp->direction);
    printNewLine();
  }
    if(tmp->cmd == 0){
      SlidePiece(tmp->pieceID, tmp->direction);
    }else{
      RotatePiece(tmp->pieceID, tmp->direction);
    }
  }
}


void NewPieceTask(void)
{
  int col0Level;
  int col1Level;
  int col2Level;
  int col3Level;
  int col4Level;
  int col5Level;

  while(1){
    bin0B = bin0A;
    bin1B = bin1A;
    bin0BL = bin0AL;
    bin1BL = bin1AL;
    if(0==1){
      printInt(bin0B);
      printInt(bin1B);
      printInt(bin0BL);
      printInt(bin1BL);
      printNewLine();
    }

    YKSemPend(NPSemPtr);
    if(0==1){
      printString("NP NPTSK \r\n");
    }



    if(NewPieceColumn==0){
      setColumn(1);
      NewPieceColumn = 1;
    }else if(NewPieceColumn==5){
      setColumn(4);
      NewPieceColumn = 4;
    }

    if(NewPieceType==1){

      if(NewPieceOrientation==1){
        addToQueue(NewPieceID, 1, 1);
      }
      if(bin0B==0 && bin1B==0){
        if(bin0BL < bin1BL){
          setColumn(1);
          bin0AL++;
          bin0A = 0;
        }else{
          setColumn(4);
          bin1AL++;
          bin1A = 0;

        }
      }else{
        if(bin0B==0){
          setColumn(1);
          bin0AL++;
          bin0A = 0;
        }else{
          setColumn(4);
          bin1AL++;
          bin1A = 0;
        }
      }


    }else{
      if((bin0B==0) && (bin1B==0)){
        if(bin0BL < bin1BL){
          setOrientation(0);
          setColumn(0);
          bin0AL++;
          bin0A = 1;
        }else{
          setOrientation(1);
          setColumn(5);
          bin1AL++;
          bin1A = 1;
        }
      }else if(bin0B != 0){
        setOrientation(2);
        setColumn(2);
        bin0AL++;
        bin0A = 0;
      }else{
        setOrientation(3);
        setColumn(3);
        bin1AL++;
        bin1A = 0;
      }
    }
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
    StartSimptris();

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

  MsgQPtr = YKQCreate(MsgQ, 40);

  YKNewTask(StatsTask, (void *) &StatsTaskStk[512], 50);

  SeedSimptris(10947);

  NPSemPtr = YKSemCreate(0);
  RCSemPtr = YKSemCreate(1);


  YKRun();

}
