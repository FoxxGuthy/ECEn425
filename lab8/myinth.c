#include "clib.h"
#include "yakk.h"
// #include "lab7defs.h"
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

}
