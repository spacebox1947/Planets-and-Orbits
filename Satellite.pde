class Satellite {
 /*
 *
 *
 *
 *
 *
 */
  int trailLen;
  boolean hasTailDistortion;
  float distort = 0;
  float low, high;
  float x, y;
  // ---- You've got to constructivize ----
  Satellite(int trailLenInit, boolean hasTailDistortionInit) {
    trailLen = trailLenInit;
    hasTailDistortion = hasTailDistortionInit;
  }
  
  void setDistortPair(float newLow, float newHigh){
    /*
    * Takes a pair of floats to define distortion in radius of tails:
    *   e.g. random(low, high)
    */
    low = newLow;
    high = newHigh;
  }
  
  void setTailDistortion(boolean newTailDistortion) {
    /*
    * Blurp. Sets distortion to true or false.
    */
    hasTailDistortion = newTailDistortion;
  }
  
  void setTrailLen(int newTrailLen) {
    /*
    * Takes an int for the number of trailing circles
    */
    trailLen = newTrailLen;
  }
  
  int getTrailLen() {
    return trailLen;
  }
  
  float getDistortVal() {
    return random(low, high);
  }
  
  void makeSatellite(Planet p, float rampVal, float initAngle, float radius) {
    for (int i = trailLen; i >= 0; i--) {
      //x = radius * sin(radians(rampVal + initAngle - i*2.33));
      //y = radius * cos(radians(rampVal + initAngle - i*2.33));
      //x = .25 * p.getRadius() * sin(radians(rampVal + initAngle - i*2.33));
      //y = .25 * p.getRadius() * cos(radians(rampVal + initAngle - i*2.33));
      x = .375*p.getMinRadius() * sin(radians(rampVal + initAngle - i*2.33));
      y = .375*p.getMinRadius() * cos(radians(rampVal + initAngle - i*2.33));
      float filly = map(float(i), trailLen * 2, 0, 32, 196);
      pushMatrix();
      noStroke();
      fill(filly);
      if (i >= 1) {
        if (hasTailDistortion == true) {
          distort = getDistortVal();
        }
        ellipse(x+p.getPlanetOrigin()[0], y+p.getPlanetOrigin()[1], (.5*radius)-(i*(.75+distort)), (.5*radius)-(i*(.75+distort)));
      }
      else {
        ellipse(x+p.getPlanetOrigin()[0], y+p.getPlanetOrigin()[1], (.5*radius)-(i*.75), (.5*radius)-(i*.75));
      }
      popMatrix();
    }
  }
  
  // ---- end Satellite ----
}