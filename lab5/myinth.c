#include "clib.h"
#include "yakk.h"
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
	
	// 'd' is 100
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
	}
	// 'p' is 112
	else if(KeyBuffer == 112) {
		YKSemPost(NSemPtr);
	}
	else {
		printNewLine();
		printString("KEYPRESS (");
		printChar(KeyBuffer);
		printString(") IGNORED");
		printNewLine();
	}
}
