#include "yakk.h"

struct TCB {
    char ready;// = 0; // running = 1, delayed, suspended
    char priority;// = 0;
    struct TCB *nextTask;
    int programCounter;
    int SP;        // stack pointer
    int delayCount;// = 0;
};

struct TCB TCBArray[MAXTASKS];

void YKInitialize(void){


	printString("IN YKINITIALIZE");
}
