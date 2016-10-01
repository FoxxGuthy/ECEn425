// header file for YAK kernel. Contains function prototypes
// and extern declarations of some global variables.
#include "yaku.h"

void YKInitialize(void);

void YKEnterMutex(void);

void YKExitMutex(void);

void YKIdleTask(void);

void YKNewTask(void (* task)(void), void *taskStack, unsigned char priority);

void YKRun(void);

void YKScheduler(void);

void YKDispatcher(void);

extern int YKCtxSwCount;

extern int YKIdleCount;
