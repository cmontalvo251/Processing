import processing.serial.*;

Serial myport;

void setup() {
  size(100,100);
  myport = new Serial(this,"/dev/ttyACM0",115200);
  println("Ready");
}

void draw() {
}

void mouseClicked() {
  //Ok when we mouse click we are going to send the Arduino 
  //a 'w' and then a '\r'
  //so let's look up the ascii codes for 'w' and '\r'
  myport.write(119);
  myport.write(13);
  print("w and slash r sent \n");
  //We then need to wait until myport is available because the arduino
  //is going to send us some data as well.
  while (myport.available() == 0) {
    //print("Waiting....");
    delay(10);
  }
  //Ok the port is ready. let's read
  while (myport.available() > 0) {
    int inByte = myport.read();
    print("Byte Read = " + inByte);
    print("\n");
  }
}
