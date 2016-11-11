#include "clib.h"
#include "yakk.h"
#include "lab7defs.h"
// #include "yakc.c"

extern int KeyBuffer;  // Needed by old kbISRC, which printed the keypress.


void resetISRC(void) {
	exit(0);
}

void tickISRC(void) {
	YKTickHandler();
}

void kbISRC(void) {
	char c;
	c = KeyBuffer;

	// charEvent and numEvent defined in lab7defs.h
	if(c == 'a') YKEventSet(charEvent, EVENT_A_KEY);
	else if(c == 'b') YKEventSet(charEvent, EVENT_B_KEY);
	else if(c == 'c') YKEventSet(charEvent, EVENT_C_KEY);
	else if(c == 'd') YKEventSet(charEvent, EVENT_A_KEY | EVENT_B_KEY | EVENT_C_KEY);
	else if(c == '1') YKEventSet(numEvent, EVENT_1_KEY);
	else if(c == '2') YKEventSet(numEvent, EVENT_2_KEY);
	else if(c == '3') YKEventSet(numEvent, EVENT_3_KEY);
	else {
			print("\nKEYPRESS (", 11);
			printChar(c);
			print(") IGNORED\n", 10);
	}
}
