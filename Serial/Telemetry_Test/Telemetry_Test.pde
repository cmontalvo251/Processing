import processing.serial.*;
float[] rec_number_array = new float[2];
int number_of_rec_numbers = 2;
Serial my;
char[]inLine = new char[60];
float ix,iy;

void setup() {
  size(200,200);
  //This assumes that your arduino is plugged into the first Serial port
  //If you have multiple serial ports used this may be different.
  //print(Serial.list()); //Uncomment this line to figure out which port your arduino is plugged into
  //myport = new Serial(this,Serial.list()[0],9600);
  println("Initializing the dev Port");
  my = new Serial(this,"/dev/ttyACM1",115200);
  delay(2000); //wait for arduino to initialize
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
  println("Reading the Serial Buffer for w slash r slash n");
  int err = 0;
  for (int i = 0;i<3;i++) {
    int inByte = 65535;
    do {
      inByte = my.read();
    } while ((inByte == 65535) || (inByte == -1));
    err+=inByte;
    println(inByte);
  }
  return err;
}

void SerialGetArray() {
  for (int d = 0;d<number_of_rec_numbers;d++) {
    int i = 0;
    char inchar = '\0';
    println("Waiting for characters");
    do {
      do {
        inchar = my.readChar();
      } while (int(inchar) == 65535);
      println("Receiving: i = "+str(i)+" char = "+inchar+" chartoint = " + str(int(inchar)));
      inLine[i++] = inchar;
    } while ((inchar != '\r') && (i<60));
    println("Response received");

    // Format from Arduino:
    // H:nnnnnnnn 
    String inString = String.valueOf(inLine);
    
    // Now Convert from ASCII to HEXSTRING to FLOAT
    println("Converting to Float");
    String clean = inString.substring(2).replaceAll(" ","");
    String truncated = clean.substring(0,8);
    println(inString);
    println(clean);
    println(truncated);
    rec_number_array[d] = Float.intBitsToFloat(unhex(truncated));
  }
}

void draw() {
  //println(ix,iy);
}

void mouseClicked() {
  int err = GetData();
  if (err==0) {
    println("Data Received!");
  }
}

int GetData() {
  SerialPutHello();
  int err = SerialGetHello();
  if (err == 0) {
    println("Did not receive response from Hardware. Exiting now \n");
    return 1;
  }
  
  //Now Read from Arduino
  SerialGetArray();

  //Extract Data and place into current vars
  ix = rec_number_array[0];
  iy = rec_number_array[1];
  print(ix,iy);
  
  return 0;
}
