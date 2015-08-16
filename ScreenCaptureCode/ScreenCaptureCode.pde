//Developed by Rajarshi Roy
import java.awt.Robot; //java library that lets us take screenshots
import java.awt.AWTException;
import java.awt.event.InputEvent;
import java.awt.image.BufferedImage;
import java.awt.Rectangle;
import java.awt.Dimension;
import processing.serial.*; //library for serial communication


Serial port; //creates object "port" of serial class
Robot robby; //creates object "robby" of robot class

int width_ = 1600;
int height_ = 900;
//float brightness_ = 255;


void setup()
{  
  port = new Serial(this, Serial.list()[0],9600); //set baud rate - make sure to have the arduino plugged in, otherwise the code will not work.
  size(300,300); //window size (doesn't matter)
  try //standard Robot class error check
  {
    robby = new Robot();
  }
  catch (AWTException e)
  {
    println("Robot class not supported by your system!");
    exit();
  }
  //D = new Dimension(1600,900);
}

void draw()
{
  int pixel; //ARGB variable with 32 int bytes where
  //sets of 8 bytes are: Alpha, Red, Green, Blue
  float r=0;
  float g=0;
  float b=0;

  //get screenshot into object "screenshot" of class BufferedImage
  BufferedImage screenshot = robby.createScreenCapture(new Rectangle(new Dimension(width_,height_)));
  //1600*900 is the screen resolution


  int i=0;
  int j=0;
  //1368*928
  //I skip every fourth pixel making my program faster
  for(i =0;i<width_; i=i+4){
    for(j=0; j<height_;j=j+4){
      pixel = screenshot.getRGB(i,j); //the ARGB integer has the colors of pixel (i,j)
      r = r+(int)(255&(pixel>>16)); //add up reds bit shift operator
      g = g+(int)(255&(pixel>>8)); //add up greens
      b = b+(int)(255&(pixel)); //add up blues 
    }
  }
  r=r/(width_/4*height_/4); //average red (remember that I skipped ever alternate pixel)
  g=g/(width_/4*height_/4); //average green
  b=b/(width_/4*height_/4); //average blue
  
//  r = random(0,255);
//  g = random(0,255);
//  b = random(0,255);
//  
//  //Normalize by a certain brightness
//  print("-----------\n");
//  float total = r + g + b;
//  
//  print("total = " + total + "\n");
//  
//  //Normalize everything by total to get a sum of brightness_
//  r = brightness_*r/total;
//  b = brightness_*b/total;
//  g = brightness_*g/total;
//  
//  //Check for overflow
//  float[] list = {r,g,b};
//  float m = max(list); 
//  
//  if (m > 255)
//  { 
//    r = 255*r/m;
//    b = 255*b/m;
//    g = 255*g/m;
//  }  
//  
//  total = r + g + b;
//  
//  print("red =  " + r + "\n");
//  print("blue = " + b + "\n");
//  print("green = " + g + "\n");
//  print("total = " + total + "\n");
//  print("-----------\n");

  port.write(0xff); //write marker (0xff) for synchronization
  port.write((byte)(r)); //write red value
  port.write((byte)(b)); //write green value
  port.write((byte)(g)); //write blue value
  delay(100); //delay for safety 200 milliseconds makes the response time slower but it makes the code runs faster

  background(r,g,b); //make window background average color
}

