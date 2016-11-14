// header file for YAK kernel. Contains function prototypes
// and extern declarations of some global variables.
#include "yaku.h"

#define EVENT_WAIT_ANY 0

#define EVENT_WAIT_ALL 1


// Struct that holds the semaphore value
typedef int YKSEM;

// struct for message queues.
typedef struct {
  void **queueAddress;
  unsigned length;
  void **nextEmpty;
  void **nextRemove;
  unsigned state;

} YKQ;

typedef struct {
  unsigned value;
} YKEVENT;

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

extern int YKTickNum;

extern YKSEM *NSemPtr;

void YKDelayTask(unsigned count);

void YKEnterISR(void);

void YKExitISR(void);

void YKTickHandler(void);

// --- SEMAPHORES ---

YKSEM* YKSemCreate(int initialValue);

void YKSemPend(YKSEM *semaphore);

void YKSemPost(YKSEM *semaphore);

// --- MESSAGE QUEUES ---

YKQ *YKQCreate(void **start, unsigned size);

void *YKQPend(YKQ *queue);

int YKQPost(YKQ *queue, void *msg);

// --- EVENTS ---

YKEVENT *YKEventCreate(unsigned initialValue);

unsigned YKEventPend(YKEVENT *event, unsigned eventMask, int waitMode);

void YKEventSet(YKEVENT *event, unsigned eventMask);

void YKEventReset(YKEVENT *event, unsigned eventMask);
