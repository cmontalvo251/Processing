PFont font;
final int VIEW_SIZE_X = 800, VIEW_SIZE_Y = 600;
int NUMSTATES = 6;
float [] State = new float [NUMSTATES];
float TIME = 0;
float TIMESTEP = 0.05;
float [] Euler = new float [3];
float [] Angular_Rates = new float [3];
float [][] Iner = new float [3][3];
float [][] InerInv = new float [3][3];
float [] StateDot = new float [NUMSTATES];
float [] sNominal = new float [NUMSTATES];
float [][] krkbody = new float [NUMSTATES][4];
float [] rkalfa = new float [4];
float [] M_T = new float [3];
float [] M_Control = new float [3];
float [] Kp = new float [3];
float [] Kd = new float [3];
float [] ptpc = new float [3];
float [] pqrc = new float [3];
float nowTime = 0;
float startTime = 0;

//In order to talk to the Arduino
boolean oktosend = true;
import processing.serial.*;
Serial myport;
int numVars = 3; //LMN

void setup() 
{  
  size(800, 600, P3D); //set view size with 3D processing
  
  font = createFont("Courier", 32); //built in processing command
  //initialize state vector
  for (int idx = 0;idx<NUMSTATES;idx++){
    State[idx] = 0;
  }
  //Give system an initial angular rate
  State[3] = 1.0;
  State[4] = 1.0;
  State[5] = 1.0;
  //Inpute Inertia matrices
  Iner[1][0] = 0;
  Iner[2][0] = 0;
  Iner[2][1] = 0;
  Iner[0][0] = 2.5;
  Iner[1][1] = 2.5;
  Iner[2][2] = 2.5;
  //Set up inertia matrix
  Iner[1][0] = Iner[0][1];
  Iner[2][0] = Iner[0][2];
  Iner[2][1] = Iner[1][2];
  for (int ii=0;ii<3;ii++)  {
    for(int jj=0;jj<3;jj++)    {
        Iner[ii][jj] = Iner[ii][jj];
      }
   }  
   /* Calculate the Inverse of the Mass Moment of Inertia Matrix */
   float det = Iner[0][1]*Iner[1][2]*Iner[2][0] - Iner[0][2]*Iner[1][1]*Iner[2][0] + Iner[0][2]*Iner[1][0]*Iner[2][1] - Iner[0][0]*Iner[1][2]*Iner[2][1] + Iner[0][0]*Iner[1][1]*Iner[2][2] - Iner[0][1]*Iner[1][0]*Iner[2][2];
   InerInv[0][0] = (Iner[1][1]*Iner[2][2] - Iner[1][2]*Iner[2][1])/det;
   InerInv[0][1] = (Iner[0][2]*Iner[2][1] - Iner[0][1]*Iner[2][2])/det;
   InerInv[0][2] = (Iner[0][1]*Iner[1][2] - Iner[0][2]*Iner[1][1])/det;
   InerInv[1][0] = (Iner[1][2]*Iner[2][0] - Iner[1][0]*Iner[2][2])/det;
   InerInv[1][1] = (Iner[0][0]*Iner[2][2] - Iner[0][2]*Iner[2][0])/det;
   InerInv[1][2] = (Iner[0][2]*Iner[1][0] - Iner[0][0]*Iner[1][2])/det;
   InerInv[2][0] = (Iner[1][0]*Iner[2][1] - Iner[1][1]*Iner[2][0])/det;
   InerInv[2][1] = (Iner[0][1]*Iner[2][0] - Iner[0][0]*Iner[2][1])/det;
   InerInv[2][2] = (Iner[0][0]*Iner[1][1] - Iner[0][1]*Iner[1][0])/det;
   /* Define the Runge-Kutta Constants */
   rkalfa[0] = 1.00000000;
   rkalfa[1] = 2.00000000;
   rkalfa[2] = 2.00000000;
   rkalfa[3] = 1.00000000;
   //Initialize Control Variables (MOVE THIS TO ARDUINO IF YOU WANT TO COMPUTE THIS ON THE ARDUINO
   for (int idx = 0;idx<3;idx++){
     Kp[idx] = 5.0;
     Kd[idx] = 2.0;
     pqrc[idx] = 0;
     ptpc[idx] = 0;
   }
   
  //Talk to Arduino
  myport = new Serial(this,"/dev/ttyACM0",9600);
  delay(2000); //wait for arduino to initialize
  println("Ready");
  
   //Initialize Starttime of Simulation
   startTime = millis()/1000.0;
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
  rotateZ(-Euler[0]); //phi 
  rotateX(-Euler[1]); //theta
  rotateY(-Euler[2]); //psi in that order for standard Aerospace sequences

  buildBoxShape(); //use QUADS to draw the faces in different colors

  popMatrix(); //restore the orientation window 
}

void Control() {
  //Assume you are reading the Statevector perfectly for now
  //LMNC = Kp*(ptpc-ptp) + Kd*(pqrc-pqr);
  for (int idx = 0;idx < NUMSTATES;idx++){
      if (idx >= 3) {
        //These are angular rates so hit it with Kd
        M_Control[idx-3]+=Kd[idx-3]*(pqrc[idx-3]-State[idx]);
      }
      else {
        //These are euler angles so hit it with Kp
        M_Control[idx] = Kp[idx]*(ptpc[idx]-State[idx]);
      }
  }
}

void Derivatives() {
  //Extract States
  float phi = State[0];
  float theta = State[1];
  float psi = State[2];
  float p = State[3];
  float q = State[4];
  float r = State[5];
  //Useful parameters
  float sphi = sin(phi);
  float ttheta = tan(theta);
  float cphi = cos(phi);
  float ctheta = cos(theta);
  //Kinematics
  StateDot[0] = p + sphi * ttheta * q + cphi * ttheta * r;
  StateDot[1] = cphi * q - sphi * r;
  StateDot[2] = (sphi / ctheta) * q + (cphi / ctheta) * r;
  //Moments on the Body
  M_T[0] = M_Control[0];
  M_T[1] = M_Control[1];
  M_T[2] = M_Control[2];
  //Dynamics 
  float int1 = M_T[0] - p*(q*Iner[0][2] - r*Iner[0][1]) - q*(q*Iner[1][2]-r*Iner[1][1]) - r*(q*Iner[2][2]-r*Iner[1][2]);
  float int2 = M_T[1] - p*(r*Iner[0][0] - p*Iner[0][2]) - q*(r*Iner[0][1]-p*Iner[1][2]) - r*(r*Iner[0][2]-p*Iner[2][2]);
  float int3 = M_T[2] - p*(p*Iner[0][1] - q*Iner[0][0]) - q*(p*Iner[1][1]-q*Iner[0][1]) - r*(p*Iner[1][2]-q*Iner[0][2]);
  StateDot[3] = InerInv[0][0]*int1 + InerInv[0][1]*int2 + InerInv[0][2]*int3;
  StateDot[4] = InerInv[1][0]*int1 + InerInv[1][1]*int2 + InerInv[1][2]*int3;
  StateDot[5] = InerInv[2][0]*int1 + InerInv[2][1]*int2 + InerInv[2][2]*int3;   
}

void SendSerial() {
   String messageToSend="";
   if (oktosend) {
      //delay(200);
      print("State Vector: ");
      for (int idx = 0;idx<NUMSTATES;idx++){
       messageToSend+=str(State[idx]);
       if (idx < NUMSTATES-1) {
         messageToSend+=",";
       }
      }
      messageToSend+="\n"; //throw in a carriage return so we do readStringUntil on the Arduino
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
  //Otherwise you can just use the control routine in this code
  //Control();
  
  //Get time since start
  nowTime = millis()/1000.0-startTime;
  //while (nowTime < TIME) {
  //  delay(int(TIMESTEP*100));
  //  nowTime = millis()/1000.0-startTime;
  //}
  //Run System in real time
  //Propogate system only if the realtime of the world is greater than the simulation time
  //If this isn't working properly you will need to increase the timestep
  //If you find the simulation is super jittery you can decrease the timestep
  if (nowTime > TIME) { 
  //RK4 Function call
  float tNominal = TIME;
  for (int j=0; j<NUMSTATES; j++) {
    sNominal[j] = State[j];
  }
  for (int j=0; j<4; j++)
  {
    /* State Values to Evaluate Derivatives */
    if (j != 0)
      {  
        TIME = tNominal + TIMESTEP/rkalfa[j];
        for (int k=0; k<NUMSTATES; k++) {
          State[k] = sNominal[k] + krkbody[k][j-1]/rkalfa[j];
        }
      }
    /* Compute Derivatives at Current Value */
    Derivatives();
    /* Runge-Kutta Constants */
    for (int k=0; k<NUMSTATES; k++) {
      krkbody[k][j] = TIMESTEP*StateDot[k];
    }
  }
  /* Step Time */
  TIME = tNominal + TIMESTEP; 
  /* Step States */
  for (int j=0; j<NUMSTATES; j++)
  {
    float summ = 0.00000000;
    for (int k=0; k<4; k++) {
      summ = summ + rkalfa[k]*krkbody[j][k];
    }
    State[j] = sNominal[j] + summ/6.00000000;
  }
  }
  //Put States in Euler and Angular_Rates
  for (int idx = 0;idx<6;idx++) {
    if (idx >= 3) {
      Angular_Rates[idx-3] = (180.0/PI)*State[idx];
    }
    else {
      Euler[idx] = State[idx];
    }
  }
  
  background(#000000); //set the background to white? 
  fill(#ffffff); //set the background to black? maybe vice versa. Doesn't really matter
  textFont(font, 20);  //set the textfont to Courier and size 20
  textAlign(LEFT, TOP); //set the test to left and top
  text("Euler Angles:\nYaw (psi)  : " + degrees(Euler[2]) + "\nPitch (theta): " + degrees(Euler[1]) + "\nRoll (phi)  : " + degrees(Euler[0]), 150, 20); //this outputs the euler angles
  text("RG(deg/s):\n" + "R:" + Angular_Rates[2] + "\n Q:" + Angular_Rates[1] + "\n P:" + Angular_Rates[0],500,20);
  textAlign(LEFT,BOTTOM);
  text("Time = " + TIME,200,200);
  //Alright then we draw a cube on the screen - let's check this out
  drawCube(); //using openGL
}

void GetSerial() {
 //println(myport.available());
 //3*4 = 12 + \r\n = 24 + 2 + 2 = 28?
 if (myport.available() >= 12) { 
   //Each variable is 4 bytes so if you have more than N-1)*4 bytes you can read it.
   String inputString = myport.readStringUntil('\n'); //the .ino writes "" which apparently is a line break
   if (inputString != null && inputString.length() > 0) {
     String [] inputStringArr = split(inputString, ","); //this splits the elements using a comma as a delimiter
     if (inputStringArr.length >= numVars+1) { //numVars,\r\n the \r\n is a line feed element
       //if you are reading raw values it means that there are 11 elements
       for (int idx = 0;idx<numVars;idx++) {
         M_Control[idx] = decodeFloat(inputStringArr[idx]);          
       }
       print("Control Vector: ");
       for (int idx = 0;idx<numVars;idx++) {
           print(M_Control[idx] + " ");
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