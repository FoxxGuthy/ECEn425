#include "clib.h"
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
