// header file for YAK kernel. Contains function prototypes
// and extern declarations of some global variables.
#include "yaku.h"

// Struct that holds the semaphore value
typedef int YKSEM;

// struct for message queues. TODO: MAKE THIS QUEUE. DEFINE in yakc.c?
typedef struct YKQ;

void YKInitialize(void);

void YKEnterMutex(void); // this is an assembly function. declare here

void YKExitMutex(void); // this is an assembly function. declare here

void YKIdleTask(void);

void YKNewTask(void (* task)(void), void *taskStack, unsigned char priority);

void YKRun(void);

void YKScheduler(char saveCTX);

void YKDispatcher(char saveCTX); // this is an assembly function. declare here

extern int YKCtxSwCount;

extern int YKIdleCount;

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
