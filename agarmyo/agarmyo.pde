float[] otherStates;

void setup()
{
  size(500,500);
}

float[] myState = {500/2,500/2};
float mysize = 10;
float myspeed = 1;

void draw()
{
  clear();
  //plot my state
  ellipse(myState[0],myState[1],mysize,mysize);
  //get mouse states
  float delx = (float)mouseX - myState[0];
  float dely = (float)mouseY - myState[1];
  //Move world based on mouse state
  if (delx > -500/2 && dely > -500/2 ){
    myState[0] = myState[0] + delx*myspeed;
    myState[1] = myState[1] + dely*myspeed;
  }
  print("myState[0] =");
  print(myState[0]);
  print('\n');
  print("delx = ");
  print(delx);
  print('\n');
  print("mouseX = ");
  print(mouseX);
  print('\n');
}
  
