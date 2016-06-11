import processing.serial.*; //library for serial communication
Serial port; //creates object "port" of serial class
String names = "Servo Degree";
int textsize = 32; //Size of text
float rad = 20; //Compute the radius of the circle
int widthx = 500; //size of the screen
int widthy = 500;
int data = 0;

void setup()
{  
  //Debugging
  //print(Serial.list());
  //port = new Serial(this, Serial.list()[0],9600); //set baud rate - make sure to have the arduino plugged in, otherwise the code will not work.
  port = new Serial(this,"/dev/ttyACM0",9600); 
  size(500,500); //window size (doesn't matter)
}

void draw()
{
  background(0);
  float y = mouseY;
  data = int(y*255.0/380.0);
  if (data > 255) {
    data = 255;
    y = 380.0;
  }
  float y0 = (3.0/4.0)*widthy+rad*1.1;
  textSize(textsize);
  text(names,widthx/3,y0+textsize);
  textSize(textsize/2.0);
  
  //Convert 0-255 to int
  int ival = int(data);
  //Now convert ival to a char
  //String val = str(ival);
  //println(ival);
  port.write(ival);
  //delay(10);
  
  text(ival*180.0/255.0,widthx/3,y0+2*textsize);
  ellipse(widthx/3,y,rad,rad);
  
}