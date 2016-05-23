Car myCar;
PImage img;

//Setup window size
void setup()
{
  size(400,400);
  background(192,64,0);
  stroke(255,255,255,255); //rgb transparency
  myCar = new Car(color(255,0,0),float(width/2),float(height/2),float(2));
  img = loadImage("flamingo.jpeg");
}

void draw()
{
  frameRate(30);
  loadPixels();
  img.loadPixels();
  for (int i =0;i<img.width;i++)
  {
    for(int j=0;j<img.height/2;j++)
    {
      int imageloc = i + j*img.width;
      float r = red(img.pixels[imageloc]);
      float g = green(img.pixels[imageloc]);
      float b = blue(img.pixels[imageloc]);
      int displayloc = i + j*width;
      pixels[displayloc] = color(r,g,b);
    }
  }
  updatePixels();
  //image(img,0,0);
  //Draw a line
  int[] F = {255,255,255,255};
  int[][] F2 = {{1,1},{2,2}};
  fill(F[0],F[1],F[2],F[3]);
  line(0,0,mouseX,mouseY); 
  point(width/2,height/2);
  noFill();
  rect(width/3,height/3,50,50);
  fill(255,0,255);
  ellipse(width/5,width/5,50,20);
  myCar.drive();
  myCar.display();
  //Grayscale Array
  int[][] I = {{200,255},{100,50}};
  for (int i = 0;i<2;i++)
  {
    for(int j = 0;j<2;j++)
  {
    fill(random(255),random(255),random(255));
    rect(I[i][j],I[i][j],20,20);
  }
  }
  float[] J = {1,2};
  //Next step is arcs and splines
  noFill();
  arc(width/2,height/2,100,200,0,PI/2);
  }

void mousePressed()
{
  saveFrame("output.png");
  background(192,64,0);
}

class Car
{
   color c;
   float xpos;
   float ypos;
   float speed;
   
   Car(color inc,float inx,float iny,float inspeed) 
   {
      c = inc;
      xpos = inx;
      ypos = iny;
      speed = inspeed;
   }
   void drive()
  {
    xpos = xpos + speed;
    if  (xpos > width)
    {
      xpos = 0;
    }
  }
  void display()
  {
    fill(c);
    rect(xpos,ypos,20,10);
  }
}
