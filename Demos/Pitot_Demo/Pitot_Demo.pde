import processing.serial.*; //library for serial communication

Serial port; //creates object "port" of serial class
int numVars = 6; //Number of variables to read
int numPitots = 4;
String [] names = {"Q West (m/s)","Q North (m/s)","Q South (m/s)","Q East (m/s)","Var5","Var6","Var7","Var8","Var9","Var10","Var11","Var12"};  //Names of variables
float [] miny = {0,0,0,0,0,0}; //max and min values of data read in
float [] maxy = {5,5,5,5,5,5};
int textsize = 32; //Size of text
float rad = 20; //Compute the radius of the circle
int widthx = 1000; //size of the screen
int widthy = 700;
float [] data = new float [numVars];
float [] outdata = new float [numVars];
int [] numReadings = new int [numVars];

void setup()
{  
  //Debugging
  //print(Serial.list());
  //port = new Serial(this, Serial.list()[0],9600); //set baud rate - make sure to have the arduino plugged in, otherwise the code will not work.
  port = new Serial(this,"/dev/ttyUSB0",9600); 
  size(1000,700); //window size (doesn't matter)
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

void readSerial() {
 if (port.available() >= 20) { 
   //Each variable is 4 bytes so if you have more than N-1)*4 bytes you can read it.
   String inputString = port.readStringUntil('\n'); //the .ino writes "" which apparently is a line break 
   if (inputString != null && inputString.length() > 0) {
     String [] inputStringArr = split(inputString, ","); //this splits the elements using a comma as a delimiter
     if (inputStringArr.length >= numVars+1) { //numVars,\r\n the \r\n is a line feed element
       //if you are reading raw values it means that there are 11 elements
       for (int idx = 0;idx<numVars;idx++) {
         data[idx] = decodeFloat(inputStringArr[idx]);
         //if (data[idx] > 0) {
           numReadings[idx]++;
           outdata[idx] = (outdata[idx]*(numReadings[idx]-1)+data[idx])/numReadings[idx];
         //}
       }
     }
   }
 }
}

void FakeData() {
  data[0] = random(1,100);
  numReadings[0]++;
  outdata[0] = (outdata[0]*(numReadings[0]-1)+data[0])/numReadings[0];
}

void draw()
{
  //frameRate(1);
  background(0);
  readSerial(); //Read Serial data
  //FakeData();
  float xdist = widthx/numPitots;
  for (int idx = 0;idx<numPitots;idx++) {
    //data[idx] = sin((idx+1)*millis()/1000.0);
    float x = xdist*idx+xdist/2;
    float y0 = (3.0/4.0)*widthy+rad*1.1;
    float y = (3.0/4.0)*(widthy - widthy/2.0*(outdata[idx]-miny[idx])/maxy[idx])+rad*1.1;
    //Put Names[idx] in here
    textSize(textsize);
    text(names[idx],x-names[idx].length()*textsize/4.0,y0+textsize);
    //Now put the outdata number in here
    textSize(textsize/2.0);
    text(outdata[idx],x-names[idx].length()*textsize/4.0,y0+2*textsize);
    //Now put the data number in here
    textSize(textsize/2.0);
    text(data[idx],x-names[idx].length()*textsize/4.0,y0+3*textsize);
    //Output the number of readings
    textSize(textsize/2.0);
    text(numReadings[idx],x-names[idx].length()*textsize/4.0,y0+3.5*textsize);
    //Output the ellipse
    ellipse(x,y,rad,rad);
  }
  if (mousePressed) {
    for (int idx = 0;idx<numVars;idx++) {
      numReadings[idx] = 0;
      outdata[idx] = 0;
    }
  }
}