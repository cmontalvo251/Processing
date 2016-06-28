import processing.serial.*;

Serial myport;
int numVars = 3;
int[] serialinarray = new int[numVars];
int serialcount = 0;
boolean firstcontact = false;

void setup() {
  size(200,200);
  myport = new Serial(this,Serial.list()[0],9600);
  //myport.bufferUntil('\n');
}

void draw() {
  if(mousePressed==true){
    int outByte;
    print("Sending Data = ");
    for (int idx = 0;idx<3;idx++){
     outByte = int(random(1,10));
     print(str(outByte) + " ");
     myport.write(outByte);
    }
    print("\n");
    println("Getting Data....");
    delay(100);
   }
}

//This only runs if the arduino sends us a value over serial
void serialEvent(Serial myport) {
 //println("Serial Event");
 int inByte = myport.read(); 
  if (firstcontact == false) {
    if (inByte == 'A') {
      myport.clear();
      firstcontact = true;
      println("Contact Established");
      myport.write('A'); //send something to the arduino so that something
      //becomes available
    }
  }
  else {
    serialinarray[serialcount] = inByte;
    serialcount++;
    //Once we get 3 bytes
    if (serialcount > 2) {
       println("Data Acquired: "+serialinarray[0] + "\t" + serialinarray[1] + "\t" + serialinarray[2]);
       serialcount = 0;
    }
  }
}