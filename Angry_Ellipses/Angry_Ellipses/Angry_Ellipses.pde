int xsize = 700;
int ysize = 700;
int ellipsesize = 10;
float factor = 0.5;
float y = ysize-ellipsesize;
float x = ellipsesize;
float deltat = 0.1;
float angle = 0;
float V0 = xsize*0.15;
float xdot = 0;
float ydot = 0;
float g = 0;
int red = 100;
int blue = 100;
int green = 100;
float xbad = random(xsize)/2+xsize/2;
float ybad = y;
int numclicks = 0;
float[] xclicked = new float[100];
float[] yclicked = new float[100];
float[][] colors = new float[100][3];

void setup()
{
 size(700,700);
 background(255); 
}

void draw()
{
 fill(red,green,blue);
 ellipse(x,y,ellipsesize,ellipsesize); 
 fill(0,255,0);
 ellipse(xbad,ybad,ellipsesize,ellipsesize);
 x = x + xdot*deltat;
 y = y - ydot*deltat;
 ydot = ydot - g*deltat;
 for (int i = 0;i<numclicks;i++)
 {
   fill(colors[i][0],colors[i][1],colors[i][2]);
   ellipse(xclicked[i],yclicked[i],ellipsesize*2,ellipsesize*2);
 }
 if (y > ysize)
 {
   if (abs(x-xbad) < ellipsesize)
   {
     textSize(64);
     fill(red,blue,green);
     text("YOU WIN!!!", xsize/3,ysize/2); 
   }
   else
   {
     x = ellipsesize;
     y = ysize-ellipsesize;
   }
   xdot = 0;
   ydot = 0;
   g = 0;
   red = int(random(255));
   blue = int(random(255));
   green = int(random(255));
 }
 if (mousePressed && xdot == 0)
 {
   colors[numclicks][0] = red;
   colors[numclicks][1] = green;
   colors[numclicks][2] = blue;
   xclicked[numclicks] = mouseX;
   yclicked[numclicks] = ysize/8;
   numclicks++;
   angle = PI/2-mouseX*PI/(4*xsize);
   xdot = V0*cos(angle);
   ydot = V0*sin(angle);
   g = 9.81;
 }
}

