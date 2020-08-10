import processing.serial.*;

Serial myport;
int numVars = 3; //Make sure this is the same as the arduino
float[] serialinarray = new float[numVars];

void setup() {
  size(200,200);
  //This assumes that your arduino is plugged into the first Serial port
  //If you have multiple serial ports used this may be different.
  //print(Serial.list()); //Uncomment this line to figure out which port your arduino is plugged into
  //myport = new Serial(this,Serial.list()[0],9600);
  myport = new Serial(this,"/dev/ttyACM0",9600);
  delay(2000); //wait for arduino to initialize
  println("Ready");
}

void draw() {
    //Ok so now what you need to do is get the Arduino to sent floats
    //use SerialPrintFloatArray and then check and see if myport.available > number 
    //of bytes required 
    //Check and see if Data has been received from Arduino
    readChar();
}

void readChar() {
 if (myport.available() > 0) { 
   //Each variable is 4 bytes so if you have more than 4*(N-1) bytes you can read it.
   //In this example N=3 so 4*(N-1) = 4*2 = 8.
   String inputString = myport.readStringUntil('\n'); //the .ino writes "\r\n" so all you need to do is read until you hit the line break
   if (inputString != null && inputString.length() > 0) {
     print(inputString);
   }
 }
}
