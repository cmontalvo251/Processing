import processing.serial.*; //library for serial communication

Serial port; //creates object "port" of serial class
String str;
float var;

void setup()
{  
  port = new Serial(this, Serial.list()[0],9600); //set baud rate - make sure to have the arduino plugged in, otherwise the code will not work.
  size(300,300); //window size (doesn't matter)
}

void draw()
{
  if (port.available() > 0) {
    str = port.readStringUntil(10);
    var = float(str);    
  }
  delay(1000);
  println(var);
}