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
    myport.write("test");
    println("Getting Data");
    delay(100);
    //myport.write('A');
    //delay(200);
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
      println("contact");
      myport.write('A'); //send something to the arduino so that something
      //becomes available
    }
  }
  else {
    serialinarray[serialcount] = inByte;
    serialcount++;
    //Once we get 3 bytes
    if (serialcount > 2) {
       println(serialinarray[0] + "\t" + serialinarray[1] + "\t" + serialinarray[2]);
       //myport.write('A');
       serialcount = 0;
    }
  }
}