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

struct msg MsgArray[MSGARRAYSIZE];  /* buffers for message content */

int SimpCommTaskStk[TASK_STACK_SIZE];      /* a stack for each task */
int NewPieceTaskStk[TASK_STACK_SIZE];
int StatsTaskStk[TASK_STACK_SIZE];


void *MsgQ[MSGQSIZE];           /* space for message queue */
YKQ *MsgQPtr;                   /* actual name of queue */

void SimpCommTask(void)                /* processes data in messages */
{
    struct msg *tmp;

    while (1)
    {
        tmp = (struct msg *) YKQPend(MsgQPtr); /* get next msg */

        /* check sequence count in msg; were msgs dropped? */
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

        /* update sequence count */
        count = tmp->tick;

        /* process data; update statistics for this sample */
        if (tmp->data < min)
            min = tmp->data;
        if (tmp->data > max)
            max = tmp->data;

        /* output min, max, tick values */
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

    MsgQPtr = YKQCreate(MsgQ, MSGQSIZE);
    YKNewTask(StatsTask, (void *) &StatsTaskStk[TASK_STACK_SIZE], 50);
    YKNewTask(SimpCommTask, (void *) &SimpCommTaskStk[TASK_STACK_SIZE], 30);
    YKNewTask(NewPieceTask, (void *) &NewPieceTaskStk[TASK_STACK_SIZE], 10);


    YKRun();
}
