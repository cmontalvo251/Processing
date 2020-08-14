import processing.serial.*;

Serial myport;

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
    //Check and see if Data has been received from Arduino
    //Convert mouseY to an integer
    char output = getChar();
}

char getChar() {
  int number = mouseY*10/height;
  char output = char(number+48);
  print(mouseY,number,output);
  print('\n');
  return output;
}

void mouseClicked() {
  char output = getChar();
  sendChar(output);
}

void sendChar(char output) {
  myport.write(output);
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
