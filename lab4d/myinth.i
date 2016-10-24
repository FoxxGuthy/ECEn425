# 1 "myinth.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "myinth.c"
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
# 2 "myinth.c" 2
extern int KeyBuffer;

void resetISRC(void) {
 exit(0);
}

void tickISRC(void) {
 static int tickCount = 0;
 tickCount++;
 printNewLine();
 printString("TICK ");
 printInt(tickCount);
 printNewLine();
 YKTickHandler();
}

void kbISRC(void) {

 if(KeyBuffer == 100){
  int i = 0;
  printNewLine();
  printString("DELAY KEY PRESSED");
  printNewLine();
  while(i < 5000) {
   i++;
  }
  printNewLine();
  printString("DELAY COMPLETE");
  printNewLine();
 } else {
  printNewLine();
  printString("KEYPRESS (");
  printChar(KeyBuffer);
  printString(") IGNORED");
  printNewLine();
 }
}
