//Define Globals

void setup()
{
  size(displayWidth,displayHeight);
  background(0); //initialize the background
}

void draw()
{
  if (mouseX < 10 && mouseY < 10)
  {
    background(0); //Refresh page
  }
  frameRate(30);
  //Draw an ellipse where the mouse is
  ellipse(mouseX,mouseY,10,10);
  //This is alot harder than I thought. You need to interpolate the points and draw like a cubic bezier curve between points. A bit harder than I thought but 
  //at least the skeleton is here now.
}