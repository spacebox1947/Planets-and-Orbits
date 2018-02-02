class Ramp {
  /*
  * Generates a linear ramp 
  * target = goal number, ramp acheives this number over dur / FRAMES
  * dur = length of time for ramp in Seconds
  * loops - defines wether the ramp loops or not.
  * - loops = 0; no loop - ramp freezes at 2nd target value
  * - loops = 1; loops from 1st val to 2nd val
  * 
  * NOTES:
  * - Does not have different fuctions for 'shape' like exponential
  */
  float step, dur;
  float current;
  int loops;
  float[] target = new float[2];
  int rampCount = 0;
  
  // ---- CONSTRUCTOR
  Ramp(float[] targetInit, float durInit, int loopsInit) {
    target = targetInit;
    dur = durInit;
    current = targetInit[0];
    loops = loopsInit;
    setStep();
  }
  
  void printRamp() {
    println("Target: ", target[0], target[1], "\tDuration: ", dur, "\tStep Interval: ", step, "\tLoops: ", loops);
  }
  
  void setStep() {
    /*
    * Sets a constant value by which the ramp increments.
    * simple, really.
    */
    step = (target[1] - target[0]) / (dur * float(FRAMES));
  }
  
  float getStep() {
    return step;
  }
  
  float getCurrent() {
    return current;
  }
  
  float getTarget(int idx) {
    return target[idx];
  }
  
  void nextStep() {
    /*
    * Increments float current by + or 1 step
    */
    switch(loops){
      // Increments current, or does nothing
      case 0:
        if (current != target[1]) {
          current += step;
        }
        else {
          rampCount = 1;
          break;
        }
      // Increments current, or resets to initial target
      case 1:
        if (target[0] < target[1]) {
          if (current < target[1]) {
            current += step;
          }
          else {
            current = target[0];
            rampCount += 1;
            break;
          }
        }
        else if (target[0] > target[1]) {
          if (current > target[1]) {
            current += step;
          }
          else {
            current = target[0];
            rampCount += 1;
            break;
          }
        }
    // end SWITCH
    }
  }
  
  int getRampCount() {
    /*
    * Returns an int that counts the number of times a ramp has completed --
    * Ramp type 0: Returns either 0 or 1.
    * Ramp type 1: counts from 0 to infinity and beyond!
    */
    return rampCount;
  }
  
  void setRampCount(int newRampCount) {
    rampCount = newRampCount;
  }
  
  // ---- END Ramp
}