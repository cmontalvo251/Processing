import processing.serial.*;

Serial myport;
int numVars = 3;
int[] serialinarray = new int[numVars];
boolean oktosend = true;

void setup() {
  size(200,200);
  myport = new Serial(this,Serial.list()[0],9600);
  delay(2000); //wait for arduino to initialize
}

void draw() {
    //Send Data to Arduino
    if (oktosend) {
    //if (mousePressed) {
      delay(200);
      int outByte;
      print("Processing: ");
      for (int idx = 0;idx<3;idx++){
       outByte = int(random(1,10));
       print(str(outByte) + " ");
       myport.write(outByte);
      }
      print("\n");
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
    if (myport.available() > 2) { //I think 2 means integers. Either that or an int is 1 byte.
      readInts();
    }
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