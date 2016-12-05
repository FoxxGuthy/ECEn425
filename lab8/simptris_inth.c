///////////////////////////////////
// SIMPTRIS INTERRUPTS

#include "clib.h"
#include "yakk.h"
// #include "lab7defs.h"
// #include "yakc.c"

extern YKSEM *NPSemPtr;
extern YKSEM *RCSemPtr;
extern YKSEM *TDSemPtr;
extern char bin0AL;
extern char bin1AL;
 void gameOverISRC(void) {
    exit(0);
 }

 void newPieceISRC(void) {
    //printString("NP ISRC \r\n");
    YKSemPost(NPSemPtr);
 }

 void receivedCommandISRC(void) {
    YKSemPost(RCSemPtr);
 }

 void touchdownISRC(void) {

 }

 void lineclearISRC(void) {
   bin0AL--;
   bin1AL--;
 }
