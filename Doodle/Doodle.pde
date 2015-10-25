//Define Globals

float mouseX0 = mouseX;
float mouseY0 = mouseY;
int FPS = 30;
float delay = 10000000;

void setup()
{
  size(displayWidth,displayHeight);
  background(0); //initialize the background
  mouseX0 = mouseX; //initialize mouse coordinates
  mouseY0 = mouseY; 
}

void draw()
{
  if (mouseX > 0.9*displayWidth && mouseY > 0.9*displayHeight) //Bottom right hand corner
  {
    background(0); //Refresh page
    delay = 10000000;
  }
  frameRate(FPS);
  //Draw a line only if you've moved in a reasonable amount of time
  if (delay < FPS*0.1) //FPS is changed above so the number after is the number of seconds
  {
    //Draw an ellipse where the mouse is
      ellipse(mouseX,mouseY,1,1);
      stroke(255);
      strokeWeight(10);
      line(mouseX0,mouseY0,mouseX,mouseY);
  }
  //If you haven't moved or drawn anything add 1 to the delay counter
  if (mouseX == mouseX0 && mouseY == mouseY0)
  {
    delay++;
  }
  else
  {
    delay = 0;
  }
  //Grab new mouse coordinates
  mouseX0 = mouseX;
  mouseY0 = mouseY;
}