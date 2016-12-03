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
#define RIGHT 0
#define CW 1
#define CCW 0

struct msg MsgArray[MSGARRAYSIZE];  /* buffers for message content */

int SimpCommTaskStk[TASK_STACK_SIZE];      /* a stack for each task */
int NewPieceTaskStk[TASK_STACK_SIZE];
int StatsTaskStk[TASK_STACK_SIZE];


void *MsgQ[MSGQSIZE];           /* space for message queue */
YKQ *MsgQPtr;                   /* actual name of queue */

YKSEM *RCSemPtr;                        /* YKSEM must be defined in yakk.h */
YKSEM *NPSemPtr;

extern unsigned NewPieceType;
extern unsigned NewPieceOrientation;

void SimpCommTask(void)                /* processes data in messages */
{
struct msg *tmp;

while (1)
  {
  YKSemPend(RCSemPtr);
  tmp = (struct msg *) YKQPend(MsgQPtr); /* get next msg */
    if(tmp->cmd == SLIDE){
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

    YKNewTask(SimpCommTask, (void *) &SimpCommTaskStk[TASK_STACK_SIZE], 30);
    YKNewTask(NewPieceTask, (void *) &NewPieceTaskStk[TASK_STACK_SIZE], 10);

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

  StartSimptris();
  YKRun();

}
