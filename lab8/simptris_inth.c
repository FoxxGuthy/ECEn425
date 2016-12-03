///////////////////////////////////
// SIMPTRIS INTERRUPTS
 void gameOverISRC(void) {
    exit(0);
 }

 void newPeiceISRC(void) {
    YKSemPost(NPSemPtr);
 }

 void receivedCommandISRC(void) {
    YKSemPost(RCSemPtr);
 }

 void touchdownISRC(void) {

 }

 void lineclearISRC(void) {

 }
