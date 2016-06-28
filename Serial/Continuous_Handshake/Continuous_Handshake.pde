import processing.serial.*;

Serial myport;
int numVars = 3;
int[] serialinarray = new int[numVars];
int serialcount = 0;
boolean firstcontact = false;
boolean oktosend = true;

void setup() {
  size(200,200);
  myport = new Serial(this,Serial.list()[0],9600);
  //myport.bufferUntil('\n');
}

void draw() {
    //Send Data to Arduino
    if (oktosend && firstcontact) {
      int outByte;
      print("Processing: ");
      for (int idx = 0;idx<3;idx++){
       outByte = int(random(1,10));
       print(str(outByte) + " ");
       myport.write(outByte);
      }
      print("\n");
      //println("Getting Data....");
      oktosend = false;
    }
}

//This only runs if the arduino sends us a value over serial
void serialEvent(Serial myport) {
 //println("Serial Event");
 int inByte = myport.read(); 
  if (firstcontact == false) {
    if (inByte == 'A') {
      myport.clear();
      println("Contact Established");
      myport.write('A'); //send something to the arduino so that something
      //becomes available - what's wierd is the fact that writing 'A' still writes \r\n which is 13 and 15 in ascii
      //A is 65. Anyway because of the \r\n you have to throw a while loop in there
      //to flush out the Serial port. I wish there was a Serial.clear
      firstcontact = true;
    }
  }
  else {
    serialinarray[serialcount] = inByte;
    serialcount++;
    //Once we get 3 bytes
    if (serialcount > 2) {
       println("Arduino   : "+serialinarray[0] + " " + serialinarray[1] + " " + serialinarray[2]);
       serialcount = 0;
       oktosend = true;
    }
  }
}