import processing.serial.*;
float[] rec_number_array = new float[2];
int number_of_rec_numbers = 2;
Serial my;
char[]inLine = new char[60];
float ix,iy;

int w = 0;
int slashr = 0;
int slashn = 0;
int oktosend = 1;

void setup() {
  size(200,200);
  //This assumes that your arduino is plugged into the first Serial port
  //If you have multiple serial ports used this may be different.
  //print(Serial.list()); //Uncomment this line to figure out which port your arduino is plugged into
  //myport = new Serial(this,Serial.list()[0],9600);
  println("Initializing the dev Port");
  my = new Serial(this,"/dev/ttyUSB0",57600);
  println("Ready");
}


void SerialPutHello() {
  println("Sending w slash r");
  my.write(119);
  my.write(13);
  println("Sent");
}
 
int SerialGetHello() {
  //Consume w\r\n
  char inchar = '\0';
  while(my.available()>0){
    inchar = my.readChar();
    if (int(inchar) == 119) {
      println("char = "+inchar + " int = ",int(inchar));
      println("w received ! \n");
      w = 1;
    }
    if ((int(inchar) == 13) && (w == 1)) {
       println("char = "+inchar + " int = ",int(inchar));
       println("slash r received! \n");
       slashr = 1;
    }
    if ((int(inchar) == 10) && (slashr+w == 2)) {
       println("char = "+inchar + " int = ",int(inchar));
       println("slash n received! \n");
       w = 0;
       slashr = 0;
       return 1;
    }
  }
  return 0;
}

void draw() {
  //If we have already requested data then we need to check for data 
  if (oktosend == 0) {
    //This routine checks for data from the drone
    int response = SerialGetHello();
    //if a response was received
    if (response == 1) {
      //We can reset the oktosend and request more data
      println("Response Received \n");
      oktosend = 1;
    }
  }
}

void mouseClicked() {
  ///Have we requested data?
  if (oktosend == 1) {
    //If not go ahead and request data
    SerialPutHello();
    //But don't request data again until we've received a response 
    oktosend = 0;
  }
}
