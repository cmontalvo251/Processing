PFont font;
final int VIEW_SIZE_X = 800, VIEW_SIZE_Y = 600;

//In order to talk to the Arduino
boolean oktosend = true;
import processing.serial.*;
Serial myport;
float[] received_data = new float[4];
//int numVars = 4; //time,phi,theta,psi
int numVars = 2; //time, altitude
float time_now = 0;
float last_send = 0;
PrintWriter file;

void setup() 
{  
  size(800, 600); 
  
  int d = day();    // Values from 1 - 31
  int m = month();  // Values from 1 - 12
  int y = year();   // 2003, 2004, 2005, etc.
  int s = second();  // Values from 0 - 59
  int min = minute();  // Values from 0 - 59
  int h = hour();    // Values from 0 - 23
  file = createWriter("/home/carlos/Desktop/Logging_"+str(y)+"_"+str(m)+"_"+str(d)+"_"+str(h)+"_"+str(min)+"_"+str(s)+".txt");
  
  font = createFont("Courier", 32); //built in processing command
  //Talk to Arduino
  //myport = new Serial(this,"/dev/ttyACM0",9600);
  myport = new Serial(this,"/dev/ttyUSB0",9600);
  delay(2000); //wait for arduino to initialize
  println("Ready");
}

void SendSerial() {   
   if (oktosend) {
      last_send = time_now;
      //delay(200);
      print("Requesting Data: ");
      String messageToSend="\n";
      print(messageToSend);
      myport.write(messageToSend);
      oktosend = false;
    }
}

float maptopixels(float input) {
  float max = 30;
  float min = -30;
  float screenheight = 600;
  
  return (600-((input-min)*screenheight/(max-min)));
}

void drawAltitude() {
  float altitude = received_data[1];
  float altitude_command = 10;
  float ground = 0;
  
  textAlign(LEFT,BOTTOM);
  
  strokeWeight(10);
  stroke(255,0,0); //Make the current altitude red
  float pixelheight = maptopixels(altitude);  
  line(0,pixelheight,800,pixelheight);
  text("Altitude: " + received_data[1],150,20);
  
  stroke(0,255,0); //the ground is green
  pixelheight = maptopixels(ground);
  line(0,pixelheight,800,pixelheight);
  text("Ground = 0",150,pixelheight*0.95);
  
  stroke(0,0,255); //the altitude command is in blue
  pixelheight = maptopixels(altitude_command);
  line(0,pixelheight,800,pixelheight);
  text("Altitude Command = " + str(altitude_command),150,pixelheight*0.95);
}

//Alright here is our draw loop
void draw() {
  
  time_now = millis()/1000.0;
  
  SendSerial(); 
  GetSerial(); 
    
  background(#000000); //set the background to white? 
  fill(#ffffff); //set the background to black? maybe vice versa. Doesn't really matter
  textFont(font, 20);  //set the textfont to Courier and size 20
  textAlign(LEFT, TOP); //set the test to left and top
  //text("Euler Angles:\nYaw (psi)  : " + degrees(received_data[3]) + "\nPitch (theta): " + degrees(received_data[2]) + "\nRoll (phi)  : " + degrees(received_data[1]), 150, 20); //this outputs the euler angles
  //text("RG(deg/s):\n" + "R:" + Angular_Rates[2] + "\n Q:" + Angular_Rates[1] + "\n P:" + Angular_Rates[0],500,20);
  //Alright then we draw a cube on the screen - let's check this out
  
  drawAltitude();
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
       print("Received Data: ");
       for (int idx = 0;idx<numVars;idx++) {
           print(received_data[idx] + " ");
           file.write(received_data[idx]+",");
       }
       file.write("\n");
       file.flush();
       print("\n");
       oktosend = true;
     }
   }
 }
 
 if (time_now - last_send > 5) {
   oktosend = true;
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