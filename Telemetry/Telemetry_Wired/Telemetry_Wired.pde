PFont font;
final int VIEW_SIZE_X = 800, VIEW_SIZE_Y = 600;

//In order to talk to the Arduino
boolean oktosend = true;
import processing.serial.*;
Serial myport;
float[] received_data = new float[4];
int numVars = 4; //time,phi,theta,psi

void setup() 
{  
  size(800, 600, P3D); //set view size with 3D processing
  
  font = createFont("Courier", 32); //built in processing command
  //Talk to Arduino
  //myport = new Serial(this,"/dev/ttyACM0",9600);
  myport = new Serial(this,"/dev/ttyUSB0",9600);
  delay(2000); //wait for arduino to initialize
  println("Ready");
}

void buildBoxShape() {
  //box(60, 10, 40);
  noStroke();
  beginShape(QUADS); //again openGL commands to draw a cube

  //Z+ (to the drawing area)
  fill(#00ff00); // oh wow the cube is different colors
  vertex(-30, -5, 20);
  vertex(30, -5, 20);
  vertex(30, 5, 20);
  vertex(-30, 5, 20);

  //Z-
  fill(#0000ff); 
  vertex(-30, -5, -20);
  vertex(30, -5, -20);
  vertex(30, 5, -20);
  vertex(-30, 5, -20);

  //X-
  fill(#ff0000);
  vertex(-30, -5, -20);
  vertex(-30, -5, 20);
  vertex(-30, 5, 20);
  vertex(-30, 5, -20);

  //X+
  fill(#ffff00);
  vertex(30, -5, -20);
  vertex(30, -5, 20);
  vertex(30, 5, 20);
  vertex(30, 5, -20);

  //Y-
  fill(#ff00ff);
  vertex(-30, -5, -20);
  vertex(30, -5, -20);
  vertex(30, -5, 20);
  vertex(-30, -5, 20);

  //Y+
  fill(#00ffff);
  vertex(-30, 5, -20);
  vertex(30, 5, -20);
  vertex(30, 5, 20);
  vertex(-30, 5, 20);

  endShape(); //done with shape and quit
}

void drawCube() {  
  pushMatrix();  //sets the view port window - these are openGL commands
  translate(VIEW_SIZE_X/2, VIEW_SIZE_Y/2 + 50, 0); //translate the cube 
  scale(5, 5, 5); //scale the cube

  // a demonstration of the following is at 
  // http://www.varesano.net/blog/fabio/ahrs-sensor-fusion-orientation-filter-3d-graphical-rotating-cube
  rotateZ(-received_data[0]); //phi 
  rotateX(-received_data[1]); //theta
  rotateY(-received_data[2]); //psi in that order for standard Aerospace sequences

  buildBoxShape(); //use QUADS to draw the faces in different colors

  popMatrix(); //restore the orientation window 
}

void SendSerial() {   
   if (oktosend) {
      //delay(200);
      print("Requesting Data: ");
      String messageToSend="\n";
      print(messageToSend);
      myport.write(messageToSend);
      oktosend = false;
    }
}

//Alright here is our draw loop
void draw() {
  //If you're doing the control system routine on the Arduino itself you need to send the statevector to the Arduino via the serial command
  SendSerial(); //REVISIT
  //Then you need to get the Control State from the Arduino
  GetSerial(); //REVISIT
    
  background(#000000); //set the background to white? 
  fill(#ffffff); //set the background to black? maybe vice versa. Doesn't really matter
  textFont(font, 20);  //set the textfont to Courier and size 20
  textAlign(LEFT, TOP); //set the test to left and top
  text("Euler Angles:\nYaw (psi)  : " + degrees(received_data[3]) + "\nPitch (theta): " + degrees(received_data[2]) + "\nRoll (phi)  : " + degrees(received_data[1]), 150, 20); //this outputs the euler angles
  //text("RG(deg/s):\n" + "R:" + Angular_Rates[2] + "\n Q:" + Angular_Rates[1] + "\n P:" + Angular_Rates[0],500,20);
  textAlign(LEFT,BOTTOM);
  text("Time = " + received_data[0],200,200);
  //Alright then we draw a cube on the screen - let's check this out
  drawCube(); //using openGL
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
       }
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