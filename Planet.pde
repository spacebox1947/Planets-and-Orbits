class Planet {
  /*
  *
  *
  *
  *
  *
  */
  float xOrig, yOrig;
  float radius, minRadius;
  int cMax, cMin;
  float decay = .95;
  boolean rSet = false;
  
  // ---- You've got to constructivize ----
  Planet(float xOrigInit, float yOrigInit, float radiusInit) {
    xOrig = xOrigInit;
    yOrig = yOrigInit;
    radius = radiusInit;
  }
  
  float getRadius() {
    return radius;
  }
  
  void setMinRadius(float newMinRadius) {
    minRadius = newMinRadius;
  }
  
  float getMinRadius() {
    return minRadius;
  }
  
  void makePlanet(float max, float min, int nSteps, int cSteps) {
    /*
    * makes a nStep gradient from max -> min
    *
    * obviously, only does grayscale. fucker.
    */
    float r;
    if (cSteps > 0) {
      r = (radius + random(-.133, .167)) * pow(decay, nSteps-cSteps);
    }
    else {
      r = radius * pow(decay, nSteps-cSteps);
      if (rSet == false) {
        setMinRadius(r);
        rSet = true;
      }
    }
    float filly = map(cSteps, nSteps, 0, max, min);
    //println(min, max, nSteps, cSteps, r, filly);
    pushMatrix();
    fill(filly-1);
    ellipse(xOrig, yOrig, r, r);
    popMatrix();
    
    if (cSteps > 0) {
      makePlanet(max, min, nSteps, cSteps-1);
    }
  }
  
  float[] getPlanetOrigin() {
    float[] planet = {xOrig, yOrig};
    return planet;
  }
 
  // ---- End Planet ----
}