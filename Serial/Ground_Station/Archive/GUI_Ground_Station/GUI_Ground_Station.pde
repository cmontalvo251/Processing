////////////GLOBAL VARIABLES/////////////
float[] ptp = new float[3];
float[] pqr = new float[3];
float[] ned = new float[3];
float[] rx = new float[4];
float lat = 0; // initialize Latitude
float lon = 0; // initialize Longitude
float Da = 0; // Difference in altitudes
float hardware_time = 0;
float baro_altitude = 0;
float zero_altitude = 0; // Initializing zero altitude shouldn't have to change
float GPS_altitude = 0; // Initializing GPS altitude will change based on signal but should be linear
float MYGUESS_altitude = 0; // The most probable location based on finding the mean difference between GPS and Bamometer (Stats) 
float airspeed = 0;
int numVars = 11;
int cycle = 0;
float[] received_data = new float[numVars];
float time_now = 0;
color w = color(255, 255, 255); // Initializing some colors for further use
color r = color(75, 0, 0);
color g = color(0, 75, 0);

////////VIEWPORT VARIABLES//////////////////
PFont font;

///////////SERIAL VARIABLS
//In order to talk to the Arduino
boolean oktosend = true;
import processing.serial.*;
Serial myport;
char[]inLine = new char[60];
float last_send = 0;
float time_wait = 5; //time to wait before another messenger is sent

///////////////DATALOGGING VARIABLES//////////
PrintWriter file;


////FLAGS
int DEBUG = 1;
int DATALOG = 1;

void setup() 
{  
  //SETUP VIEW WINDOM
  size(950,950, P3D); //set view size with 3D processing
  surface.setResizable(true);

  //BACKGROUND
  // I put the background in setup not draw this causes corners to be cut off on the cube
  background(#000000);
 
  ////CREATE A FONT
  font = createFont("Courier", 32); //built in processing command
 
  if (DEBUG==0) {
    //SERIAL COMMUNICATION
    myport = new Serial(this,"/dev/ttyUSB0",115200);
  }
  if (DATALOG==1){
    ///SETUP DATALOGGING FILE
    int d = day();    // Values from 1 - 31
    int m = month();  // Values from 1 - 12
    int y = year();   // 2003, 2004, 2005, etc.
    int s = second();  // Values from 0 - 59
    int min = minute();  // Values from 0 - 59
    int h = hour();    // Values from 0 - 23
    file = createWriter("/home/carlos/Desktop/Logging_"+str(y)+"_"+str(m)+"_"+str(d)+"_"+str(h)+"_"+str(min)+"_"+str(s)+".txt");
  }
  delay(2000); //wait for hardware to initialize
  println("Ready");
}

//Alright here is our draw loop
void draw() {
  //Get timer of this laptop
  time_now = millis()/1000.0;
   
  if (DEBUG == 0) {
    //In DEBUG mode we will use fictitious data but if not we will send and get data from
    //the hardware.
    RequestData(); 
  } else {
    //Make up data
    oktosend = true; //Ok to send is always true in DEBUG mode
    
    //ROLL PITCH YAW
    received_data[0] = 1*time_now;
    received_data[1] = -2*time_now;
    received_data[2] = 0.5*time_now;
    
    ///RECEIVER SIGNALS
    received_data[3] = sin(time_now)*495 + 1510;
    received_data[4] = sin(time_now/2)*495 + 1510;
    received_data[5] = sin(2.5*time_now)*495 + 1510;
    received_data[6] = sin(3*time_now - time_now)*495 + 1510;
    
    ///BARO ALTITUDE AND GPS ALTITUDE
    received_data[7] = time_now + 10; //linear relationship for alt so it can be linked to a single integer not a signal wave
    // im asuming the the altitude will not continue to rise without end or you'd loose signal stregth. Like get to a certain altitude and stay there and fluctuate slightly
    // if baro_altitude > 750 the moving bar will go off window this can be scaled as desired
    received_data[8] = 3*time_now + 20; // works the same as baro_altitude
    
    ///LAT AND LON
    received_data[9] = time_now/500+lat;
    received_data[10] = time_now/500+lon;
  }
  
  //Extract Data
  ptp[0] = received_data[0];
  ptp[1] = received_data[1];
  ptp[2] = received_data[2];
  rx[0] = received_data[3];
  rx[1] = received_data[4];
  rx[2] = received_data[5];
  rx[3] = received_data[6];
  baro_altitude = received_data[7];
  GPS_altitude = received_data[8];
  lat = received_data[9];
  lon = received_data[10];
  
  if ((DATALOG==1) && oktosend) {
    logdata();
  }
  
  //Set the view port color
  //background(#000000); // I kept this here if we want to revert the background to original
  fill(#000000); 

  // These rects are my "Background" now 
  rect(0,height/3,width,height);
  rect(2*width/3,0,width/3,height/3);
  rect(0,0,width/3,height/3);
  
  fill(#ffffff);
  textFont(font, 12*((width+height)/2.0)/700.0);  //set the textfont to Courier and size 20
  textAlign(LEFT, TOP); //set the test to left and top
  
  //Set vertical bars
  stroke(255);
  //x is to the right and y is down
  line(width/3.0,0,0,width/3.0,height,0); //x,y,z
  line(2.0*width/3.0,0,0,2.0*width/3.0,height,0); //x,y,z
  
  //Set horizontal bars
  line(0,height/3.0,0,width,height/3.0,0);
  line(0,2.0*height/3.0,0,width,2.0*height/3.0,0);
  noStroke();
  ///SCREEN IS IN A 9X9 GRID
  
  //GRID 1,1 - NED
  text("Latitude (deg): \n" + ned[0] + "\nLongitude (deg): \n" + ned[1] + "\nGPS Altitude (m): \n" + GPS_altitude + "\nBaro Altitude (m): \n" + baro_altitude + "\nProbable Altitude (m): \n" + MYGUESS_altitude ,width/30.0,height/30.0); // Changed ned[2] to GPS_altitude
  
  ///GRID 1,2 - MAP
  // this is the position on the map I gave it a function to make it look like something
  // we can scale lat and lon to the range of the aircraft to ensure it never goes off screeen 
  // I'm not push-poping any point in order to see the start during the whole mission but we could do that if you want
  stroke(255);
  ellipse(width/2+10*lat*sin(lat),height/3-2*(lon*lon),1,1);

  
  //GRID 1,3 - ALT
   if (GPS_altitude > baro_altitude) { // Check Which Altitude is Higher 
     Da = GPS_altitude - baro_altitude; // Check their difference
     MYGUESS_altitude = (Da/2)+ baro_altitude; // My guess is the real altitude is half that difference plus the lower altitude
   }
   else { // GPS_altitude < baro_altitude
     Da = baro_altitude - GPS_altitude;
     MYGUESS_altitude = (Da/2)+ GPS_altitude;
   }
  fill (r); // fills the background with red long enough to show this bar
  rect(1.501*width/3+width/6,-(MYGUESS_altitude)*height/2300 + height/3.05,width/3.0,height/(200));
  fill (w); // fills the background back with white like you initialized
  rect(1.501*width/3+width/6,-(baro_altitude)*height/2300 + height/3.05,width/3.0,height/(200)); // same as control signal just translates up or down based off baro_altitude
  rect(1.501*width/3+width/6,-(GPS_altitude)*height/2300 + height/3.05,width/3.0,height/(200));
  fill (g); // fills the background with green long enough to show this bar
  rect(1.501*width/3+width/6,-(zero_altitude)*height/2300 + height/3.05,width/3.0,height/(200));
  fill (w); // fills the background back with white like you initialized
   
  //GRID 2,1 - PTP
  text("Euler Angles (deg)\nRoll: " + degrees(ptp[0]) + "\nPitch: " + degrees(ptp[1]) + "\nYaw: " + degrees(ptp[2]), width/30.0,height/3.0+height/30.0); 
  
  //GRID 2,3 - PQR
  text("Angular Velocity \n(rad/s) \nP:" + pqr[0] + "\nQ:" + pqr[1] + "\nR:" + pqr[2],2*width/3+width/30.0,height/3.0+height/30.0);
  
  //GRID 3,1 - AIRSPEED
  text("Airspeed (m/s)\n" + airspeed,width/30.0,2*height/3.0 + height/30.0);
  //GRID 3,2 and 3,3 - CONTROL SIGNALS
  rect(2*width/3+width/6,2*height/3 + height/30.0,(rx[0]-1500)/500*width/6.0,height/(5*4));
  rect(2*width/3+width/6,2.216666666666*height/3 + height/30.0,(rx[1]-1500)/500*width/6.0,height/(5*4));
  rect(2*width/3+width/6,2.433333333333*height/3 + height/30.0,(rx[2]-1500)/500*width/6.0,height/(5*4));
  rect(2*width/3+width/6,2.65*height/3 + height/30.0,(rx[3]-1500)/500*width/6.0,height/(5*4));
  //GRID 2,2 - CUBE
  drawCube();

}

//Write data to file
void logdata() {
  //Log Data to Home Screen
  print("Logging Data: ");
  for (int idx = 0;idx<numVars;idx++) {
    print(received_data[idx] + " ");
    file.write(received_data[idx]+",");
  }
  file.write("\n");
  file.flush();
  print("\n");
}

void SerialPutHello() {
  println("Sending w slash r");
  myport.write(119);
  myport.write(13);
  println("Sent");
}

int SerialGetHello() {
  //Consume w\r\n
  println("Reading the Serial Buffer for w slash r slash n");
  int err = 0;
  for (int i = 0;i<3;i++) {
    int inByte = 65535;
    do {
      inByte = myport.read();
    } while ((inByte == 65535) || (inByte == -1));
    err+=inByte;
    println(inByte);
  }
  return err;
}

void SerialGetArray() {
  for (int d = 0;d<numVars;d++) {
    int i = 0;
    char inchar = '\0';
    println("Waiting for characters");
    do {
      do {
        inchar = myport.readChar();
      } while (int(inchar) == 65535);
      println("Receiving: i = "+str(i)+" char = "+inchar+" chartoint = " + str(int(inchar)));
      inLine[i++] = inchar;
    } while ((inchar != '\r') && (i<60));
    println("Response received");

    // Format from Arduino:
    // H:nnnnnnnn 
    String inString = String.valueOf(inLine);
    
    // Now Convert from ASCII to HEXSTRING to FLOAT
    println("Converting to Float");
    String clean = inString.substring(2).replaceAll(" ","");
    String truncated = clean.substring(0,8);
    println(inString);
    println(clean);
    println(truncated);
    received_data[d] = Float.intBitsToFloat(unhex(truncated));
  }
}

///Request Data Serial
void RequestData() {
  
 //If we can request new data let's do it.
 if (oktosend) {
   oktosend = false;
   //First send w\r
   SerialPutHello();
   //Listen for w\r\n
   int err = SerialGetHello();
   if (err == 0) {
     println("DID NOT RECEIVE RESPONSE FROM HARDWARE!!!");
   } else {
     //Assuming we did receive a response
     //Read the Array from the serial port
     SerialGetArray();
   }
   //Then reset the timer 
   last_send = time_now;
 }
  
 //Sometimes the message send to the hardware is not read. Lost in transmission really
 //So after time_wait seconds we will send the hardware another message. This is my solution
 //to the two generals problem. 
 //https://en.wikipedia.org/wiki/Two_Generals%27_Problem
 if (time_now - last_send > time_wait) {
   oktosend = true;
 }
 
}

/////ROUTINE TO ROTATE A BOX ON THE SCREEN
void drawCube() {  
  pushMatrix();  //sets the view port window - these are openGL commands
  translate(width/2.0, height/2.0, 0); //translate the cube
  float c = (1.0/5.0)*(1.0/9.0)*0.8;
  //x is to the right and y is down
  scale(width*c,height*c,(width+height)/2.0*c); //scale the cube
  // a demonstration of the following is at 
  // http://www.varesano.net/blog/fabio/ahrs-sensor-fusion-orientation-filter-3d-graphical-rotating-cube
  rotateZ(-ptp[0]); //phi 
  rotateX(ptp[1]); //theta
  rotateY(-ptp[2]); //psi in that order for standard Aerospace sequences
  buildBoxShape(); //use QUADS to draw the faces in different colors
  popMatrix(); //restore the orientation window 
}

/////ROUTINE TO DRAW A BOX
void buildBoxShape() {
  noStroke();
  beginShape(QUADS); //again openGL commands to draw a cube

  //Z+ (to the drawing area)
  fill(#00ff00); //Cube is in different colors
  vertex(-5, -5, 5);
  vertex(5, -5, 5);
  vertex(5, 5, 5);
  vertex(-5, 5, 5);

  //Z-
  fill(#0000ff); 
  vertex(-5, -5, -5);
  vertex(5, -5, -5);
  vertex(5, 5, -5);
  vertex(-5, 5, -5);

  //X-
  fill(#ff0000);
  vertex(-5, -5, -5);
  vertex(-5, -5, 5);
  vertex(-5, 5, 5);
  vertex(-5, 5, -5);

  //X+
  fill(#ffff00);
  vertex(5, -5, -5);
  vertex(5, -5, 5);
  vertex(5, 5, 5);
  vertex(5, 5, -5);

  //Y-
  fill(#ff00ff);
  vertex(-5, -5, -5);
  vertex(5, -5, -5);
  vertex(5, -5, 5);
  vertex(-5, -5, 5);

  //Y+
  fill(#00ffff);
  vertex(-5, 5, -5);
  vertex(5, 5, -5);
  vertex(5, 5, 5);
  vertex(-5, 5, 5);

  endShape(); //done with shape and quit
}
