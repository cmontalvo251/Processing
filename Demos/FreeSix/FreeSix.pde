import processing.serial.*;

Serial myPort;  // Create object from Serial class

//REVISIT REVISIT - need to change this to the correct serialPort
//final String serialPort = "/dev/tty.usbmodem621"; // replace this with your serial port. On windows you will need something like "COM1".

float [] q = new float [4];
float [] accelcal = new float [3];
float [] rg = new float [3];
float [] accel = new float[3];
float [] hq = null;
float [] Euler = new float [3]; // psi, theta, phi
float [] Euler_Temp = new float [3];

int lf = 10; // 10 is '\n' in ASCII
byte[] inBuffer = new byte[22]; // this is the number of chars on each line from the Arduino (including /r/n)

PFont font;
final int VIEW_SIZE_X = 800, VIEW_SIZE_Y = 600;


void setup() 
{
  size(800, 600, P3D); //set view size with 3D processing
  //myPort = new Serial(this, serialPort, 115200); //this will need to change. Maybe 9600 baud rate?
  myPort = new Serial(this,"/dev/ttyACM0",115200); //make sure the baud rate is the same as the ino code
  //connect to the arduino

  font = createFont("Courier", 32); //built in processing command 

  /*
  float [] axis = new float[3];
   axis[0] = 0.0;
   axis[1] = 0.0;
   axis[2] = 1.0;
   float angle = PI/2.0;
   
   hq = quatAxisAngle(axis, angle);
   
   hq = new float[4];
   hq[0] = 0.0;
   hq[1] = 0.0;
   hq[2] = 0.0;
   hq[3] = 1.0;
   */

  delay(3000);
  //myPort.clear();
  //myPort.write("1"); //wait, why are we writing? the arduino isn't listening
  //Whatever, maybe we don't need this. I might comment it out and see what happens
  //REVISIT REVISIT - not sure why this is happening
  //accel[2] = 0;
  //while (abs(accel[2]) < 10) { 
  //for (int idx = 0;idx<100;idx++){
  //  readQ();
  //}
  //}
  //for (int idx = 0;idx<3;idx++) {
  //  accelcal[idx] = accel[idx];
  //}
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



void readQ() {
  //print(myPort.available());
  //print("\n");
  if (myPort.available() >= 44) { //more than 18 bytes coming in. Not sure if this is right. May need to REVISIT.
    //so if the serial command is 4 numbers at 4 bytes per float that means there is only 16 bytes.
    //so this may never execute correctly - ok so apprently there are 5 numbers because a line end is another one so it's
    //5*4 = 20 bytes so I think this will be fine
    //If you are printing raw values as well then there are 4+6+1 = 11
    //11*4 = 44 bytes
    //If you're doing Euler Angles and Rates you have 7*4 = 32 bytes
    String inputString = myPort.readStringUntil('\n'); //line 71 of the .ino writes "" which apparently is a line break so
    //hopefully this will work right. REVISIT REVISIT
    //print(inputString);
    if (inputString != null && inputString.length() > 0) {
      String [] inputStringArr = split(inputString, ","); //this splits the elements using a comma as a delimiter
      //print(inputStringArr.length);
      //print("\n");
      if (inputStringArr.length >= 11) { // q0,q1,q2,q3,\r\n so we have 5 elements
        //if you are reading raw values it means that there are 11 elements
        q[0] = decodeFloat(inputStringArr[0]);
        q[1] = decodeFloat(inputStringArr[1]);
        q[2] = decodeFloat(inputStringArr[2]);
        q[3] = decodeFloat(inputStringArr[3]);
        accel[0] = decodeFloat(inputStringArr[4]);
        accel[1] = decodeFloat(inputStringArr[5]);
        accel[2] = decodeFloat(inputStringArr[6]);
        rg[0] = decodeFloat(inputStringArr[7]);
        rg[1] = decodeFloat(inputStringArr[8]);
        rg[2] = decodeFloat(inputStringArr[9]);        
      }
    }
  }
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
  rotateZ(-Euler[2]); //phi 
  rotateX(-Euler[1]); //theta
  rotateY(-Euler[0]); //psi in that order for standard Aerospace sequences

  buildBoxShape(); //use QUADS to draw the faces in different colors

  popMatrix(); //restore the orientation window 
}


//Alright here is our draw loop
void draw() {
  background(#000000); //set the background to white? 
  fill(#ffffff); //set the background to black? maybe vice versa. Doesn't really matter

  readQ(); //Whoops I skipped this routine. so this just reads the serial data from the 
  //arduino. Some revisits in here but basically it does crazy bit shifting and pulls in the
  //data

  //Hq is initially set to null so until hq is initialized
  if (hq != null) { // use home quaternion
    //If h has been pressed we convert the product of hq and q to Euler
    //QuatProd is a Hamilton Product which is equivalent to rotating a vector
    quaternionToEuler(quatProd(hq, q), Euler);
    text("Disable home position by pressing \"n\"", 20, VIEW_SIZE_Y - 30);
  }
  else {
    //this command will be set if hq is null or n is pressed
    //This just converts the quaternion to Euler
    quaternionToEuler(q, Euler);
    text("Point FreeIMU's X axis to your monitor then press \"h\"", 20, VIEW_SIZE_Y - 30);
    //so it looks like there is a keypress function
  }
  
  //This is for putting the code inside the Duplo airplane
  for (int idx = 0;idx<3;idx++) {
   Euler_Temp[idx] = Euler[idx]; 
  }
  Euler[1] = -Euler_Temp[2]; //Switch phi and theta
  Euler[2] = Euler_Temp[1];

  textFont(font, 20);  //set the textfont to Courier and size 20
  textAlign(LEFT, TOP); //set the test to left and top
  text("Q:\n" + q[0] + "\n" + q[1] + "\n" + q[2] + "\n" + q[3], 20, 20); // this outputs the quaternion values
  text("Euler Angles:\nYaw (psi)  : " + degrees(Euler[0]) + "\nPitch (theta): " + degrees(Euler[1]) + "\nRoll (phi)  : " + degrees(-Euler[2]), 200, 20); //this outputs the euler angles
  //rg[0] = 0;
  //rg[1] = 0;
  //rg[2] = 0;
  text("RG(deg/s):\n" + "X:" + int(rg[0]) + "\n Y:" + int(rg[1]) + "\n Z:" + int(rg[2]),500,20);
  //accel[0] = 0;
  //accel[1] = 0;
  //accel[2] = 0;
  //for (int idx = 0;idx<3;idx++) {
  //  accel[idx] = accel[idx] - accelcal[idx];
  //  accel[idx] /= 500;
  //  accel[idx] = int(accel[idx]);
 // }
  //accel[2] = accel[2]+1;
  text("ACCEL(Gs):\n" + "X:" + accel[0] + "\n Y:" + accel[1] + "\n Z:" + accel[2],200,450);
  //text("ACCELCAL(Gs):\n" + "X:" + accelcal[0] + "\n Y:" + accelcal[1] + "\n Z:" + accelcal[2],20,450);

  //Alright then we draw a cube on the screen - let's check this out
  drawCube(); //using openGL
}


void keyPressed() {
  //Ok cool so if h is pressed hq is set to the conjugate quaternion
  //if n is pressed, hq is reset to null
  if (key == 'h') {
    println("pressed h");

    // set hq the home quaternion as the quatnion conjugate coming from the sensor fusion
    hq = quatConjugate(q);
  }
  else if (key == 'n') {
    println("pressed n");
    hq = null;
  }
}

// See Sebastian O.H. Madwick report 
// "An efficient orientation filter for inertial and intertial/magnetic sensor arrays" Chapter 2 Quaternion representation

void quaternionToEuler(float [] q, float [] euler) {
  //Standard quaternion to Euler conversion routine
  euler[0] = atan2(2 * q[1] * q[2] - 2 * q[0] * q[3], 2 * q[0]*q[0] + 2 * q[1] * q[1] - 1); // psi
  euler[1] = -asin(2 * q[1] * q[3] + 2 * q[0] * q[2]); // theta
  euler[2] = atan2(2 * q[2] * q[3] - 2 * q[0] * q[1], 2 * q[0] * q[0] + 2 * q[3] * q[3] - 1); // phi
}

//The product of two quaternions is equivalent to two rotations. This removes the bias in the 
//sensors to plot the cube correctly
//Google Hamilton Product
float [] quatProd(float [] a, float [] b) {
  float [] q = new float[4];

  q[0] = a[0] * b[0] - a[1] * b[1] - a[2] * b[2] - a[3] * b[3];
  q[1] = a[0] * b[1] + a[1] * b[0] + a[2] * b[3] - a[3] * b[2];
  q[2] = a[0] * b[2] - a[1] * b[3] + a[2] * b[0] + a[3] * b[1];
  q[3] = a[0] * b[3] + a[1] * b[2] - a[2] * b[1] + a[3] * b[0];

  return q;
}

// returns a quaternion from an axis angle representation
// this uses the TIB rotation matrix. This is the same equation I derived from 
// my research with Jonny Rogers on the Smortar project
float [] quatAxisAngle(float [] axis, float angle) {
  float [] q = new float[4];

  float halfAngle = angle / 2.0;
  float sinHalfAngle = sin(halfAngle);
  q[0] = cos(halfAngle);
  q[1] = -axis[0] * sinHalfAngle;
  q[2] = -axis[1] * sinHalfAngle;
  q[3] = -axis[2] * sinHalfAngle;

  return q;
}

// return the quaternion conjugate of quat
float [] quatConjugate(float [] quat) {
  float [] conj = new float[4];

  conj[0] = quat[0]; //while the scalar portion stays the same
  conj[1] = -quat[1];
  conj[2] = -quat[2]; //the conjugate of a quaternion is just the negative of the vector
  conj[3] = -quat[3];

  return conj;
}