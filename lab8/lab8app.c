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
#define MSGQSIZE          40
#define SLIDE 0
#define ROTATE 1
#define LEFT 0
#define RIGHT 1
#define CW 1
#define CCW 0
#define FLAT 0
#define CORNER 1
#define STRAIGHT 1

#define DEBUG 0


struct msg MsgArray[MSGARRAYSIZE];  /* buffers for message content */
int nextMsg = 0;


int SimpCommTaskStk[TASK_STACK_SIZE];      /* a stack for each task */
int NewPieceTaskStk[TASK_STACK_SIZE];
int StatsTaskStk[TASK_STACK_SIZE];


void *MsgQ[MSGQSIZE];           /* space for message queue */
YKQ *MsgQPtr;                   /* actual name of queue */

YKSEM *RCSemPtr;                        /* YKSEM must be defined in yakk.h */
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


// Variable for new task piece tracking

char bin0B = FLAT;
char bin1B = FLAT;
char bin0BL = 0;
char bin1BL = 0;


char bin0A = FLAT;
char bin1A = FLAT;
char bin0AL = 0;
char bin1AL = 0;

void addToQueue(int pieceID, int cmd, int direction){

  MsgArray[nextMsg].pieceID = pieceID;
  MsgArray[nextMsg].cmd = cmd;
  MsgArray[nextMsg].direction = direction;
  if(DEBUG==1){
    printString("ATQ: CMD:");
    printInt(cmd);
    printString(" DIR:");
    printInt(direction);
    printNewLine();
  }

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
  if(DEBUG==1){
    printString("C: ");
    printInt(tmp->cmd);
    printString(" D: ");
    printInt(tmp->direction);
    printNewLine();
  }
    if(tmp->cmd == SLIDE){
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
    if(DEBUG==1){
      printInt(bin0B);
      printInt(bin1B);
      printInt(bin0BL);
      printInt(bin1BL);
      printNewLine();
    }

    YKSemPend(NPSemPtr);
    if(DEBUG==1){
      printString("NP NPTSK \r\n");
    }


    //Let's Just get the piece off the wall for now
    if(NewPieceColumn==0){
      setColumn(1);
      NewPieceColumn = 1;
    }else if(NewPieceColumn==5){
      setColumn(4);
      NewPieceColumn = 4;
    }

    if(NewPieceType==STRAIGHT){
      //fix the rotation
      if(NewPieceOrientation==1){ // if the piece is vertical
        addToQueue(NewPieceID, ROTATE, CW);
      }
      if(bin0B==FLAT && bin1B==FLAT){
        if(bin0BL < bin1BL){
          setColumn(1);
          bin0AL++;
          bin0A = FLAT;
        }else{
          setColumn(4);
          bin1AL++;
          bin1A = FLAT;

        }
      }else{
        if(bin0B==FLAT){
          setColumn(1);
          bin0AL++;
          bin0A = FLAT;
        }else{
          setColumn(4);
          bin1AL++;
          bin1A = FLAT;
        }
      }


    }else{// the piece is a corner piece
      if((bin0B==FLAT) && (bin1B==FLAT)){
        if(bin0BL < bin1BL){
          setOrientation(0);
          setColumn(0);
          bin0AL++;
          bin0A = CORNER;
        }else{
          setOrientation(1);
          setColumn(5);
          bin1AL++;
          bin1A = CORNER;
        }
      }else if(bin0B != FLAT){
        setOrientation(2);
        setColumn(2);
        bin0AL++;
        bin0A = FLAT;
      }else{
        setOrientation(3);
        setColumn(3);
        bin1AL++;
        bin1A = FLAT;
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
  //87245
  NPSemPtr = YKSemCreate(0);
  RCSemPtr = YKSemCreate(1);


  YKRun();

}
