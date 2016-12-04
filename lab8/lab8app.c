/*
File: lab6app.c
Revision date: 4 November 2009
Description: Application code for EE 425 lab 6 (Message queues)
*/

#include "clib.h"
#include "yakk.h"                   /* contains kernel definitions */
#include "lab6defs.h"               /* contains definitions for this lab */
#include "simptris.h"

#define TASK_STACK_SIZE   512       /* stack size in words */
#define MSGQSIZE          10
#define SLIDE 0
#define ROTATE 1
#define LEFT 0
#define RIGHT 1
#define CW 1
#define CCW 0
#define FLAT 0
#define CORNER 1
#define STRAIGHT 1


struct msg MsgArray[MSGARRAYSIZE];  /* buffers for message content */
int nextMsg = 0;


int SimpCommTaskStk[TASK_STACK_SIZE];      /* a stack for each task */
int NewPieceTaskStk[TASK_STACK_SIZE];
int StatsTaskStk[TASK_STACK_SIZE];


void *MsgQ[MSGQSIZE];           /* space for message queue */
YKQ *MsgQPtr;                   /* actual name of queue */

YKSEM *RCSemPtr;                        /* YKSEM must be defined in yakk.h */
YKSEM *NPSemPtr;

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

void addToQueue(int pieceID, int cmd, int direction){

  MsgArray[nextMsg].pieceID = pieceID;
  MsgArray[nextMsg].cmd = cmd;
  MsgArray[nextMsg].direction = direction;
  printString("ATQ: CMD:");
  printInt(cmd);
  printString(" DIR:");
  printInt(direction);
  printNewLine();

  if (YKQPost(MsgQPtr, (void *) &(MsgArray[nextMsg])) == 0)
			printString("  addToQ: queue overflow! \n");
	else if (++nextMsg >= MSGARRAYSIZE)
			nextMsg = 0;

}

void setOrientation(int Orientation){
  int dif = NewPieceOrientation - Orientation;

  switch(dif) {
    case -3:
      addToQueue(NewPieceID, ROTATE, CW);
      break;
    case -2:
      addToQueue(NewPieceID, ROTATE, CCW);
      addToQueue(NewPieceID, ROTATE, CCW);
      break;
    case -1:
      addToQueue(NewPieceID, ROTATE, CCW);
      break;
    case 0:
      break;
    case 1:
      addToQueue(NewPieceID, ROTATE, CW);
      break;
    case 2:
      addToQueue(NewPieceID, ROTATE, CW);
      addToQueue(NewPieceID, ROTATE, CW);
      break;
    case 3:
      addToQueue(NewPieceID, ROTATE, CCW);
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
      addToQueue(NewPieceID, SLIDE, LEFT);
    }
  }else if(NewPieceColumn < Column){
      dif = Column - NewPieceColumn;
      for(i=0;i<dif;i++){
        addToQueue(NewPieceID, SLIDE, RIGHT);
      }
  }


  return ;
}

void SimpCommTask(void)                /* processes data in messages */
{
struct msg *tmp;
while (1)
  {
  YKSemPend(RCSemPtr);
  tmp = (struct msg *) YKQPend(MsgQPtr); /* get next msg */
  printString("C: ");
  printInt(tmp->cmd);
  printString(" D: ");
  printInt(tmp->direction);
  printNewLine();
    if(tmp->cmd == SLIDE){
      SlidePiece(tmp->pieceID, tmp->direction);
    }else{
      RotatePiece(tmp->pieceID, tmp->direction);
    }
  }
}

int getFirstOne(int column){
  int i;
  int tmp = 1;

  for(i=15;i>=0;i--){
    if((tmp & column)==tmp){
      return i+1;
    }else{
      tmp = tmp<<1;
    }
  }
  return i+1;
}

void NewPieceTask(void)
{
  int col0Level;
  int col1Level;
  int col2Level;
  int col3Level;
  int col4Level;
  int col5Level;
  char bin0 = FLAT;
  char bin1 = FLAT;

  while(1){
    YKSemPend(NPSemPtr);
    printString("NP NPTSK \r\n");
    col0Level = getFirstOne(ScreenBitMap0);
    col1Level = getFirstOne(ScreenBitMap1);
    col2Level = getFirstOne(ScreenBitMap2);
    col3Level = getFirstOne(ScreenBitMap3);
    col4Level = getFirstOne(ScreenBitMap4);
    col5Level = getFirstOne(ScreenBitMap5);
    printInt(col0Level);
    printInt(col1Level);
    printInt(col2Level);
    printInt(col3Level);
    printInt(col4Level);
    printInt(col5Level);
    printNewLine();
    if((col0Level == col1Level) && (col1Level==col2Level)){
      bin0 = FLAT;
    }else{
      bin0 = CORNER;
    }
    if((col3Level == col4Level) && (col4Level==col5Level)){
      bin1 = FLAT;
    }else{
      bin1 = CORNER;
    }
    printString("B0:");
    printInt(bin0);
    printString(" B1:");
    printInt(bin1);
    printNewLine();

    //Let's Just get the piece off the wall for now
    if(NewPieceColumn==0){
      setColumn(1);
    }else if(NewPieceColumn==5){
      setColumn(4);
    }

    if(NewPieceType==STRAIGHT){
      //fix the rotation
      if(NewPieceOrientation==1){ // if the piece is vertical
        addToQueue(NewPieceID, ROTATE, CW);
      }
      if(bin0==FLAT){
        setColumn(1);
      }
      if(bin1==FLAT){
        setColumn(4);
      }


    }else{// the piece is a corner piece
      if((bin0==FLAT) && (bin1==FLAT)){
        if(col0Level < col5Level){
          setOrientation(0);
          setColumn(0);
        }else{
          setOrientation(1);
          setColumn(5);
        }
      }
      if(bin0 != FLAT){
        setOrientation(2);
        setColumn(1);
      }else{
        setOrientation(3);
        setColumn(4);
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

    YKNewTask(SimpCommTask, (void *) &SimpCommTaskStk[TASK_STACK_SIZE], 30);
    YKNewTask(NewPieceTask, (void *) &NewPieceTaskStk[TASK_STACK_SIZE], 10);
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

  MsgQPtr = YKQCreate(MsgQ, MSGQSIZE);

  YKNewTask(StatsTask, (void *) &StatsTaskStk[TASK_STACK_SIZE], 50);

  SeedSimptris(10947);

  NPSemPtr = YKSemCreate(0);
  RCSemPtr = YKSemCreate(1);

  YKRun();

}
