# 1 "yakc.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "yakc.c"
# 1 "yakk.h" 1


# 1 "yaku.h" 1
# 4 "yakk.h" 2

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
# 2 "yakc.c" 2

struct TCB {
    char ready;
    char priority;
    struct TCB *nextTask;
    int programCounter;
    int SP;
    int delayCount;
};

struct TCB TCBArray[3];

void YKInitialize(void){


 printString("IN YKINITIALIZE");
}
