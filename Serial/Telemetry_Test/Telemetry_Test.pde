import processing.serial.*;
float[] rec_number_array = new float[3];
int number_of_rec_numbers = 3;
Serial my;
char[]inLine = new char[60];
float ix,iy,iz;

//How to do this in Processing?
union inparser {
  long inversion;
  float floatversion;
};

void setup() {
  size(200,200);
  //This assumes that your arduino is plugged into the first Serial port
  //If you have multiple serial ports used this may be different.
  //print(Serial.list()); //Uncomment this line to figure out which port your arduino is plugged into
  //myport = new Serial(this,Serial.list()[0],9600);
  println("Initializing the dev Port");
  my = new Serial(this,"/dev/ttyACM0",115200);
  delay(2000); //wait for arduino to initialize
  println("Ready");
}


void SerialPutHello() {
  println("Sending w slash r");
  my.write('w');
  my.write('\r');
  println("Sent");
}

int SerialGetHello() {
  //Consume w\r\n
  println("Reading the Serial Buffer for w slash r slash n");
  char inchar;
  int err = 0;
  for (int i = 0;i<3;i++) {
    inchar = my.readChar();
    int val = int(inchar);
    err+=val;
    println(val);
  }
  return err;
}

void SerialGetArray() {
  union inparser inputvar;
  for (int d = 0;d<number_of_rec_numbers;d++) {
    int i = 0;
    
    char inchar = '\0';
    println("Waiting for characters");
    do {
      do {
        inchar = my.readChar();
      } while (inchar == '\0');
      println("Receiving: i = "+str(i)+" char = "+inchar+" chartoint = " + str(int(inchar)));
      inLine[i++] = inchar;
    } while ((inchar != '\r') && (i<60));
    println("Response received");

    // Format from Arduino:
    // H:nnnnnnnn 

    // Now Convert from ASCII to HEXSTRING to FLOAT
    println("Converting to Float");
    inputvar.inversion = 0;
    for(i=2;i<10;i++){
      println("Hex Digit: i = " + str(i) + " char = " + inLine[i]);
      inputvar.inversion <<= 4;
      inputvar.inversion |= (inLine[i] <= '9' ? inLine[i] - '0' : toupper(inLine[i]) - 'A' + 10);
    }
    println("Integer Received = " + str(inputvar.inversion))
    println("");
    rec_number_array[d] = inputvar.floatversion;
  }
}

void draw() {
  print(ix,iy,iz);
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
  iz = rec_number_array[2];
  
  return 0;
}
