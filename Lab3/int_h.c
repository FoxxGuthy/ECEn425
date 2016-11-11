#include "clib.h"
extern int KeyBuffer;  // the key press

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
	if (KeyBuffer == 100) { // d is pressed
		printNewLine();
		printString("DELAY KEY PRESSED");
		printNewLine();
		
		for (i; i < 5000; i++) {
			// DO NOTHING
			// just wait
		}
		printNewLine();
		printString("DELAY COMPLETE");
		printNewLine();
	}
	else {	// anything else is pressed
		printNewLine();
		printString("KEY PRESS (");
		printChar(KeyBuffer);
		printString(") IGNORED");
		printNewLine();
	}
}
