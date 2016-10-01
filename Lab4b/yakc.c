#include "yakk.h"
#include "clib.h"

struct TCB {
    char ready;// = 0; // running = 1, delayed, suspended
    char priority;// = 0;
    struct TCB *nextTask;
    int programCounter;
    int SP;        // stack pointer
    int delayCount;// = 0;
};

struct TCB TCBArray[MAXTASKS];
int YKCtxSwCount;

void YKInitialize(void){


	printString("IN YKINITIALIZE");
}

void YKEnterMutex(void){

	
}

void YKExitMutex(void){

}

void YKIdleTask(void){

}

void YKNewTask(void (* task)(void), void *taskStack, unsigned char priority){

}

void YKRun(void){

}

void YKScheduler(void){

}

void YKDispatcher(void){

}
