#include "clib.h"
#include "yakk.h"
#include "lab6defs.h"
// #include "yakc.c"

// extern int KeyBuffer;  // Needed by old kbISRC, which printed the keypress.
extern YKQ *MsgQPtr;
extern struct msg MsgArray[];
extern int GlobalFlag; // TODO: where to define this?
extern int YKTickNum;  // defined in yakc.c

void resetISRC(void) {
	exit(0);
}

void tickISRC(void) {

	static int next = 0;
	static int data = 0;

	/* create a message with tick (sequence #) and pseudo-random data */
	MsgArray[next].tick = YKTickNum;
	data = (data + 89) % 100;
	MsgArray[next].data = data;
	if (YKQPost(MsgQPtr, (void *) &(MsgArray[next])) == 0)
			printString("  TickISR: queue overflow! \n");
	else if (++next >= MSGARRAYSIZE)
			next = 0;

	/*The OLD tickISRC*/
	// static int tickCount = 0;
	// tickCount++;
	// printNewLine();
	// printString("TICK ");
	// printInt(tickCount);
	// printNewLine();
	// YKTickHandler();
}

void kbISRC(void) {
		GlobalFlag = 1;
	// // 'd' is 100
	// if(KeyBuffer == 100){
	// 	int i = 0;
	// 	printNewLine();
	// 	printString("DELAY KEY PRESSED");
	// 	printNewLine();
	// 	while(i < 5000) {
	// 		i++;
	// 	}
	// 	printNewLine();
	// 	printString("DELAY COMPLETE");
	// 	printNewLine();
	// }
	// // 'p' is 112
	// else if(KeyBuffer == 112) {
	// 	YKSemPost(NSemPtr);
	// }
	// else {
	// 	printNewLine();
	// 	printString("KEYPRESS (");
	// 	printChar(KeyBuffer);
	// 	printString(") IGNORED");
	// 	printNewLine();
	// }
}
