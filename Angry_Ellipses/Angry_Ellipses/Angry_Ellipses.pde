int xsize = 500;
int ysize = 500;
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
float xbad = xsize/2;
float ybad = y;

void setup()
{
 size(xsize,ysize);
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
 if (y > ysize)
 {
   x = ellipsesize;
   y = ysize-ellipsesize;
   xdot = 0;
   ydot = 0;
   g = 0;
   red = int(random(255));
   blue = int(random(255));
   green = int(random(255));
 }
 if (mousePressed && xdot == 0)
 {
   angle = -atan2(mouseY-y,mouseX-0);
   xdot = V0*cos(angle);
   ydot = V0*sin(angle);
   g = 9.81;
 }
}

