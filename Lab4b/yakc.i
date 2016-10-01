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
# 1 "clib.h" 1



void print(char *string, int length);
void printNewLine(void);
void printChar(char c);
void printString(char *string);


void printInt(int val);
void printLong(long val);
void printUInt(unsigned val);
void printULong(unsigned long val);


void printByte(char val);
void printWord(int val);
void printDWord(long val);


void exit(unsigned char code);


void signalEOI(void);
# 3 "yakc.c" 2

struct TCB {
    char ready;
    char priority;
    struct TCB *nextTask;
    int programCounter;
    int SP;
    int delayCount;
};

struct TCB TCBArray[3];
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
