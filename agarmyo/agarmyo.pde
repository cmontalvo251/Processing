//Define Globals
float myMass = 200;
float theirMass = 100;
float theirSize = sqrt(theirMass);
float mysize = sqrt(myMass);
float myspeed = 5;
float[] mycolor = {random(255)+1,random(255)+1,random(255)+1}; 
int numberofDots = 100;
float[][] smallDots = new float[numberofDots][6];

void setup()
{
  size(displayWidth,displayHeight);
  //Generate Ramdom Dots
  for (int i = 0; i<numberofDots; i++) {
   smallDots[i][0] = random(displayWidth)+1;
   smallDots[i][1] = random(displayHeight)+1;
   smallDots[i][2] = random(255)+1;
   smallDots[i][3] = random(255)+1;
   smallDots[i][4] = random(255)+1;
   smallDots[i][5] = theirSize;
  }
}

int signum(float f) {
  if (f > 0) return 1;
  if (f < 0) return -1;
  return 0;
}

void draw()
{
  background(255);
  frameRate(30);
  //plot my state
  fill(mycolor[0],mycolor[1],mycolor[2]);
  ellipse(displayWidth/2,displayHeight/2,mysize,mysize);
  
  //get mouse states
  float delx = (float)mouseX-displayWidth/2;
  float dely = (float)mouseY-displayHeight/2;
  
  float magnitude = sqrt(pow(delx,2) + pow(dely,2));
  
  float movex = delx/magnitude;
  float movey = dely/magnitude;
  
  //Plot Small Dots and move them
  for (int i = 0;i < numberofDots; i++) {
     float x = smallDots[i][0];
     float y = smallDots[i][1];
     //Check to see if dot is off screen
     if ((abs(x) > displayWidth) || (x < 0)) {
       smallDots[i][0] = random(displayWidth)+1;
     }
     if ((abs(y) > displayHeight) || (y < 0)) {
       smallDots[i][1] = random(displayHeight)+1;
     }
     float c1 = smallDots[i][2];
     float c2 = smallDots[i][3];
     float c3 = smallDots[i][4];
     float s = smallDots[i][5];
     if (s != 0) {
       fill(c1,c2,c3);
       ellipse(x,y,s,s);
       smallDots[i][0] += -myspeed*movex;
       smallDots[i][1] += -myspeed*movey;
       float dist = sqrt(pow(x-displayWidth/2,2)+pow(y-displayHeight/2,2));
       if (dist < mysize/2) {
         myMass += theirMass;
         mysize = sqrt(myMass);
         smallDots[i][0] = random(displayWidth)+1;
         smallDots[i][1] = random(displayHeight)+1;
         theirMass+=1;
         theirSize=sqrt(theirMass);
       }
     }
  }
}
