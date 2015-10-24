//Define Globals
int screenSize = 500;
float[] myState = {500/2,500/2};
float myMass = 200;
float theirMass = 10;
float mysize = sqrt(myMass);
float myspeed = 1;
float[] mycolor = {random(255)+1,random(255)+1,random(255)+1}; 
int numberofDots = 100;
float[][] smallDots = new float[numberofDots][6];

void setup()
{
  size(screenSize,screenSize);
  //Generate Ramdom Dots
  for (int i = 0; i<numberofDots; i++) {
   smallDots[i][0] = random(screenSize)+1;
   smallDots[i][1] = random(screenSize)+1;
   smallDots[i][2] = random(255)+1;
   smallDots[i][3] = random(255)+1;
   smallDots[i][4] = random(255)+1;
   smallDots[i][5] = theirMass;
  }
}

int signum(float f) {
  if (f > 0) return 1;
  if (f < 0) return -1;
  return 0;
} 

void draw()
{
  clear();
  frameRate(30);
  //plot my state
  fill(mycolor[0],mycolor[1],mycolor[2]);
  ellipse(screenSize/2,screenSize/2,mysize,mysize);
  
  //get mouse states
  float delx = (float)mouseX-screenSize/2;
  float dely = (float)mouseY-screenSize/2;
  int movex = -1;
  int movey = -1;
  
  if (delx > 0) {
    movex = 1;
  }
  if (dely > 0) {
    movey = 1;
  }
  
  //Plot Small Dots and move them
  for (int i = 0;i < numberofDots; i++) {
     float x = smallDots[i][0];
     float y = smallDots[i][1];
     float c1 = smallDots[i][2];
     float c2 = smallDots[i][3];
     float c3 = smallDots[i][4];
     float s = smallDots[i][5];
     if (s != 0) {
       fill(c1,c2,c3);
       ellipse(x,y,s,s);
       smallDots[i][0] += -myspeed*movex;
       smallDots[i][1] += -myspeed*movey;
       float dist = sqrt(pow(x-screenSize/2,2)+pow(y-screenSize/2,2));
       if (dist < mysize) {
         myMass += theirMass;
         mysize = sqrt(myMass);
         smallDots[i][0] = random(screenSize)+1;
         smallDots[i][1] = random(screenSize)+1;
       }
     }
  }
}
  
