PFont font;
final int VIEW_SIZE_X = 800, VIEW_SIZE_Y = 600;

//In order to talk to the Arduino
boolean oktosend = true;
import processing.serial.*;
Serial myport;
float[] received_data = new float[3];
int numVars = 3; //load, battery and solar voltages
float time_now = 0;
float last_send = 0;
PrintWriter file;

void setup() 
{  
  size(800, 600, P3D); //set view size with 3D processing
  
  int d = day();    // Values from 1 - 31
  int m = month();  // Values from 1 - 12
  int y = year();   // 2003, 2004, 2005, etc.
  int s = second();  // Values from 0 - 59
  int min = minute();  // Values from 0 - 59
  int h = hour();    // Values from 0 - 23
  file = createWriter("/home/carlos/Desktop/Logging_"+str(y)+"_"+str(m)+"_"+str(d)+"_"+str(h)+"_"+str(min)+"_"+str(s)+".txt");
  
  font = createFont("Courier", 32); //built in processing command
  //Talk to Arduino
  myport = new Serial(this,"/dev/ttyACM1",115200);
  //myport = new Serial(this,"/dev/ttyUSB0",9600);
  delay(2000); //wait for arduino to initialize
  println("Ready");
}

//Alright here is our draw loop
void draw() {
  
  GetSerial(); 
    
  background(#000000); //set the background to white? 
  fill(#ffffff); //set the background to black? maybe vice versa. Doesn't really matter
  textFont(font, 20);  //set the textfont to Courier and size 20
  textAlign(LEFT, TOP); //set the test to left and top
  text("Voltages :\n Load  : " + received_data[0] + "\n Battery: " + received_data[1] + "\n Solar Panel: " + received_data[2], 150, 20); 
  textAlign(LEFT,BOTTOM);
  text("Time = " + hour() + ":" + minute() + ":" + second(),200,200);
  
  delay(1000);
}

void GetSerial() {
 //println(myport.available());
 //3*4 = 12 + \r\n = 24 + 2 + 2 = 28?
 //each variable is 4 bytes using the serialPrintFloatArr function
 if (myport.available() >= numVars*4) { 
   //Each variable is 4 bytes so if you have more than N-1)*4 bytes you can read it.
   String inputString = myport.readStringUntil('\n'); //the .ino writes "" which apparently is a line break
   if (inputString != null && inputString.length() > 0) {
     String [] inputStringArr = split(inputString, ","); //this splits the elements using a comma as a delimiter
     if (inputStringArr.length >= numVars+1) { //numVars,\r\n the \r\n is a line feed element
       //if you are reading raw values it means that there are 11 elements
       for (int idx = 0;idx<numVars;idx++) {
         received_data[idx] = decodeFloat(inputStringArr[idx]);          
       }
       //print("Received Data: ");
       file.write(hour()+","+minute()+","+second()+",");
       for (int idx = 0;idx<numVars;idx++) {
           //print(received_data[idx] + " ");
           file.write(received_data[idx]+",");
       }
       file.write(0+"\n");
       file.flush();
       print("\n");
       oktosend = true;
     }
   }
 }
 
}

float decodeFloat(String inString) {
 //Again this routine is so beyond me it's insane
 byte [] inData = new byte[4];

 if (inString.length() == 8) {
   inData[0] = (byte) unhex(inString.substring(0, 2)); //unhex and substring are all methods
   inData[1] = (byte) unhex(inString.substring(2, 4)); //for hexadecimal
   inData[2] = (byte) unhex(inString.substring(4, 6)); //REVISIT REVISIT - need to look at this
   inData[3] = (byte) unhex(inString.substring(6, 8)); //later if I want
 }

 //More bit shift operations 24,16,8, and then 0xff which is 255
 int intbits = (inData[3] << 24) | ((inData[2] & 0xff) << 16) | ((inData[1] & 0xff) << 8) | (inData[0] & 0xff);
 return Float.intBitsToFloat(intbits);
}