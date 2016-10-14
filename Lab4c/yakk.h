// header file for YAK kernel. Contains function prototypes
// and extern declarations of some global variables.
#include "yaku.h"

void YKInitialize(void);

void YKEnterMutex(void); // this is an assembly function. declare here

void YKExitMutex(void); // this is an assembly function. declare here

void YKIdleTask(void);

void YKNewTask(void (* task)(void), void *taskStack, unsigned char priority);

void YKRun(void);

void YKScheduler(void);

void YKDispatcher(); // this is an assembly function. declare here

extern int YKCtxSwCount;

extern int YKIdleCount;

// Lab 4c functions

void YKDelayTask(unsigned count);

void YKEnterISR(void);

void YKExitISR(void);

void YKTickHandler(void);
