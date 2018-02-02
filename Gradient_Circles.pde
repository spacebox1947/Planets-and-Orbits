//int FRAMES = 60;
int FRAMES = 30;

// Planets!
Planet[] jupiter;
float[][] pCoords = {{.25, .25}, {.25, .75}, {.75, .25}, {.75, .75}};
float RAD = 250;
float radius = RAD;
float decay = .95;
int NUM_PLANETS = 4;

// var for phobos satellites
Satellite[] phobos;
float[] tailDistVal = {-.0875, .125};
float[] angleOffset = {45, 45, 45, 45};
float[][] satelliteGrowCoords = new float[4][2];
float satRadius = .233 * RAD;

// Ramps!
Ramp[] orbit;
Ramp[] scales;
Ramp[] trails;
float r1Max = 360.0;
float[] r1Target = {0.0, r1Max};// orbit
float[] r2TargetMaxi = {0.0, 1.0};// maxi radius
float[] r2TargetMini = {1.0, 0.0};// mini radius
float scaleDur = 1.5;
float[][] numTrails;

// control values
/*
//revol[][]... [state, visibility init, visibility, scale init, min/max]
[0] 0 = Scaling State
    1 = Orbitting State

...........Orbit
[1] 0 = needs to initialize
    1 = is initialized
    
[2] 0 = invisible
    1 = visible

...........Scale
[3] 0 = needs to initialize
    1 = is initialized
    
[4] 0 = minimized
    1 = maximized
*/
int[][] revol = {{0, 0, 0, 0, 0}, {0, 0, 0, 0, 0}, {0, 0, 0, 0, 0}, {0, 0, 0, 0, 0}};
int ctl = 0;
int goal = 60;


// ---- setup() ---- + ---- + ---- + ---- + ---- + ----
void setup() {
  size(800, 800);
  background(255);
  frameRate(FRAMES);
  
  jupiter = new Planet[NUM_PLANETS];
  phobos = new Satellite[NUM_PLANETS];
  orbit = new Ramp[NUM_PLANETS];
  scales = new Ramp[NUM_PLANETS];
  trails = new Ramp[NUM_PLANETS];
  numTrails = new float[NUM_PLANETS][2];
  for (int i = 0; i < jupiter.length; i++) {
    jupiter[i] = new Planet(pCoords[i][0]*width, pCoords[i][1]*height, RAD);
    phobos[i] = new Satellite(i*2+10, true);
    phobos[i].setDistortPair(tailDistVal[0], tailDistVal[1]);
  }
}

// ---- draw() ---- + ---- + ---- + ---- + ---- + ----
void draw() {
  
  pushMatrix();
  rectMode(CORNER);
  fill(255);
  rect(0, 0, width, height);
  popMatrix();
  
  // Drawing Planets and Satellites
  for (int i = 0; i < jupiter.length; i++) {
    // make planet[i]
    pushMatrix();
    noStroke();
    jupiter[i].makePlanet(208, 96, 6, 6);
    popMatrix();
    
    // ----                               ----
    // ---- Managing Satellites and Ramps ----
    // ----                               ----
    if (revol[i][0] == 0) {
  
      // we are scaling. boom
      if (revol[i][3] == 0) {
        // the satellite's scaling needs to be initialized
        if (revol[i][4] == 1) {
          //switch from max to min
          scales[i] = new Ramp(r2TargetMini, scaleDur*.85, 0);
          numTrails[i][0] = numTrails[i][1];
          phobos[i].setTrailLen(int(numTrails[i][1]));
          numTrails[i][1] = 1;
          trails[i] = new Ramp(numTrails[i], scaleDur*.85, 0);
          revol[i][4] = 0;
        }
        else {
          //switch from min to max
          scales[i] = new Ramp(r2TargetMaxi, scaleDur*.85, 0);
          numTrails[i][0] = 1;
          numTrails[i][1] = int(random(6, 15));
          trails[i] = new Ramp(numTrails[i], scaleDur*.85, 0);
          revol[i][4] = 1;
        }
        // update state so that the satellite has been initialized
        revol[i][3] = 1;
        println("Satellite " + str(i) + " has been initialized for scaling!");
        println("\tMin|Max: " + str(revol[i][4]) + "\t\tInitialized: " + str(revol[i][3]) + "\n");
      }
      
      // object[i] is flagged 'on'
      // continues scaling until flagged 'off'
      if (revol[i][3] == 1) {// the satellite's scaling has been initialized
        // generate the next step of the orbit
        // irregardless of the object's scale direction
        scales[i].nextStep();
        // check to see if trails[i] has completed yet
        if (trails[i].getRampCount() == 0) {
          // generate next step of the number of trails
          trails[i].nextStep();
        }
        phobos[i].setTrailLen(int(trails[i].getCurrent()));
        phobos[i].makeSatellite(jupiter[i], i*angleOffset[i], 0, scales[i].getCurrent()*satRadius);
      }
      
      // turn off the object
      // switch its visible/invisible state next frame
      if (scales[i].getRampCount() == 1) {
        // pass the number of trails to the sattellite.
        phobos[i].setTrailLen(int(max(numTrails[i][0], numTrails[i][1])));
        
        println("Satellite " + str(i) + " Scaling Count == True!\n");
        revol[i][3] = 0;
        // engage orbitting state
        println("Satellite: [" + str(i) + "]\tSwitching from Scaling to Orbitting.\n");
        revol[i][0] = 1;
        println(str(revol[i][0]) + str(revol[i][1]) + str(revol[i][2]) + str(revol[i][3]) + str(revol[i][4]));
      }
    }
    
    if (revol[i][0] == 1) {
      // we are orbitting. boom.
      
      // object[i] is flagged 'off'
      if (revol[i][1] == 0) {
        //object needs to be initialized
        // the object is visibly orbiting
        // switch to invisible and counting
        // reset ramp count, ramp state, etc.
        if (revol[i][2] == 1) {
          float duration = random(3, 6);
          orbit[i] = new Ramp(r1Target, duration, 1);
          revol[i][2] = 0;
        }
        // the object is invisible
        // switch to visible and orbiting
        // reset ramp count, ramp state, etc.
        else {
          float duration = random(3, 6);
          orbit[i] = new Ramp(r1Target, duration, 1);
          revol[i][2] = 1;
        }
        // update state so that the satellite has been initialized
        revol[i][1] = 1;
        println("Satellite " + str(i) + " has been initialized for orbitting!");
        println("\tVisibility: " + str(revol[i][2]) + "\t\tInitialized: " + str(revol[i][1]) + "\t\tTrail Length: " + str(phobos[i].getTrailLen()) + " " + str(numTrails[i][0]) + " " + str(numTrails[i][1]) + "\n");
      }
      
      // object[i] is flagged 'on'
      // continues counting/orbiting until flagged 'off'
      if (revol[i][1] == 1) {
        // the satellite's orbit has been initialized
        // generate the next step of the orbit
        // irregardless of the object's visibility
        orbit[i].nextStep();
        // the object is visible, draw it to the screen
        if (revol[i][2] == 1) {// the sattelite is visible
          phobos[i].makeSatellite(jupiter[i], orbit[i].getCurrent(), i*angleOffset[i], satRadius);
        }
        // else 0 --> do nothing.
      }
      
      
      
      // turn off the object
      // switch its visible/invisible state next frame
      //if (orbit[i].getRampCount() == 2 + i) {
      if (orbit[i].getCurrent() + orbit[i].getStep() >= orbit[i].getTarget(1)) {
        println("Satellite " + str(i) + " Orbit Count == True!\n");
        revol[i][1] = 0;
        // engage scaling state
        println("Satellite: [" + str(i) + "]\tSwitching from Orbitting to Scaling.\n");
        revol[i][0] = 0;
        println(str(revol[i][0]) + str(revol[i][1]) + str(revol[i][2]) + str(revol[i][3]) + str(revol[i][4]));
      }
      
    }
      //---------------------------------------------------------------------------------------
  }

  if (ctl < goal) {
    ctl += 1;
  }
  else {
    for (int c = 0; c < orbit.length; c++) {
      println("Orbit no.: ", c, "\t# of Revolutions: ", orbit[c].getRampCount(), "\tVisible: ", revol[c][0]);
    }
    println();
    ctl = 0;
  }
  // end DRAW
}