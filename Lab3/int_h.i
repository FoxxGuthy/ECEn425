# 1 "int_h.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "int_h.c"
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
# 2 "int_h.c" 2
extern int KeyBuffer;

void resetHandler(void) {
 exit(0);
}

void tickHandler(void) {
 static int tickCount = 0;
 tickCount++;

 printNewLine();
 printString("TICK ");
 printInt(tickCount);
 printNewLine();
}

void kbHandler(void) {
 int i = 0;
 if (KeyBuffer == 100) {
  printNewLine();
  printString("DELAY KEY PRESSED");
  printNewLine();

  for (i; i < 5000; i++) {


  }
  printNewLine();
  printString("DELAY COMPLETE");
  printNewLine();
 }
 else {
  printNewLine();
  printString("KEY PRESS (");
  printChar(KeyBuffer);
  printString(") IGNORED");
  printNewLine();
 }
}
