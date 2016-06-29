import processing.serial.*;

Serial myport;
int numVars = 3;
//int[] serialinarray = new int[numVars];
float[] serialinarray = new float[numVars];
boolean oktosend = true;

void setup() {
  size(200,200);
  myport = new Serial(this,Serial.list()[0],9600);
  delay(2000); //wait for arduino to initialize
  println("Ready");
}

void draw() {
    //Send Data to Arduino
    String messageToSend="";
    if (oktosend) {
    //if (mousePressed) {
      delay(200);
      float outVar;
      
      print("Processing: ");
      for (int idx = 0;idx<3;idx++){
      outVar = random(0,100)/random(0,10);
       messageToSend+=str(outVar);
       if (idx < 2) {
         messageToSend+=",";
       }
      }
      //messageToSend = "-2.0,3.0,5.0";
      messageToSend+="\n"; //throw in a carriage return so we do readStringUntil
      print(messageToSend);
      //print("\n");
      myport.write(messageToSend);
      oktosend = false;
    }
    //Ok so now what you need to do is get the Arduino to sent floats
    //use SerialPrintFloatArray and then check and see if myport.available > number 
    //of bytes requires and instead of readInts put readSerial.
    //Check and see if Data has been received from Arduino
    //An int is actually 2 bytes but .write can only send over 1 byte at a time.
    //So if you want to send over more you need to use write(buf,len);
    //but buf must be a const unsigned char* and len is the length in characters. This 
    //is not something I want to do.
    //if (myport.available() > 2) { //I think 2 means integers. Either that or an int is 1 byte.
    //  readInts();
    //}
    readFloats();
}

void readInts() {
  print("Arduino   : ");
  for (int idx = 0;idx<3;idx++) {
    serialinarray[idx] = myport.read();
    print(serialinarray[idx] + " ");
  }
  print("\n");
  oktosend = true;
}

void readFloats() {
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
         serialinarray[idx] = decodeFloat(inputStringArr[idx]);          
       }
       print("Arduino   : ");
       for (int idx = 0;idx<3;idx++) {
          //serialinarray[idx] = myport.read();
           print(serialinarray[idx] + " ");
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