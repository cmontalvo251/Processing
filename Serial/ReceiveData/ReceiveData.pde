import processing.serial.*;

Serial myport;
int numVars = 3; //Make sure this is the same as the arduino
float[] serialinarray = new float[numVars];

void setup() {
  size(200,200);
  //This assumes that your arduino is plugged into the first Serial port
  //If you have multiple serial ports used this may be different.
  //print Serial.list() //Uncomment this line to figure out which port your arduino is plugged into
  myport = new Serial(this,Serial.list()[0],9600); 
  delay(2000); //wait for arduino to initialize
  println("Ready");
}

void draw() {
    //Ok so now what you need to do is get the Arduino to sent floats
    //use SerialPrintFloatArray and then check and see if myport.available > number 
    //of bytes required 
    //Check and see if Data has been received from Arduino
    readFloats();
}

void readFloats() {
 if (myport.available() >= 4*(numVars-1)) { 
   //Each variable is 4 bytes so if you have more than 4*(N-1) bytes you can read it.
   //In this example N=3 so 4*(N-1) = 4*2 = 8.
   String inputString = myport.readStringUntil('\n'); //the .ino writes "\r\n" so all you need to do is read until you hit the line break
   if (inputString != null && inputString.length() > 0) {
     String [] inputStringArr = split(inputString, ","); //this splits the elements using a comma as a delimiter
     //if you look at the source code for serialPrintFloatArr you'll see that the arduino sends each float
     //separated by a comma
     if (inputStringArr.length >= numVars+1) { //numVars,\r\n the \r\n is a line feed element
       //if you are reading raw values it means that there are numVars elements
       for (int idx = 0;idx<numVars;idx++) {
         serialinarray[idx] = decodeFloat(inputStringArr[idx]); //decode the float from hex     
       }
       //We finally have the data. Print it to stdout. This is where you can print
       //this data to a text file if you'd like
       print("Arduino   : ");
       for (int idx = 0;idx<3;idx++) {
           print(serialinarray[idx] + " ");
       }
       print("\n");
     }
   }
 }
}

//This is the unhexing bullshit I know nothing about
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