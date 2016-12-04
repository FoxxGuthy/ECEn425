///////////////////////////////////
// SIMPTRIS INTERRUPTS

#include "clib.h"
#include "yakk.h"
// #include "lab7defs.h"
// #include "yakc.c"

extern YKSEM *NPSemPtr;
extern YKSEM *RCSemPtr;
 void gameOverISRC(void) {
    exit(0);
 }

 void newPieceISRC(void) {
    printString("NP ISRC \r\n");
    YKSemPost(NPSemPtr);
 }

 void receivedCommandISRC(void) {
    YKSemPost(RCSemPtr);
 }

 void touchdownISRC(void) {

 }

 void lineclearISRC(void) {

 }
