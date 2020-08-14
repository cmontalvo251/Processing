import processing.serial.*;
int num_digits=3;
char[] output_chars = new char[3];
Serial myport;

void setup() {
  size(200,200);
  //This assumes that your arduino is plugged into the first Serial port
  //If you have multiple serial ports used this may be different.
  //print(Serial.list()); //Uncomment this line to figure out which port your arduino is plugged into
  //myport = new Serial(this,Serial.list()[0],9600);
  myport = new Serial(this,"/dev/ttyACM0",9600);
  clearDigits();
  delay(2000); //wait for arduino to initialize
  println("Ready");
}

void draw() {
    //Check and see if Data has been received from Arduino
    //Convert mouseY to an integer
    getString();
}

void clearDigits() {
  for (int i = 0;i<num_digits;i++){
    output_chars[i] = '0';
  }
}

void printDigits() {
  for (int i = 0;i<num_digits;i++) {
    print(output_chars[i]);
    print('.');
  }
}

void string2chars(String output) {
  clearDigits();
  int j = num_digits-1;
  for (int i=output.length()-1;i>=0;i--) {
    output_chars[j] = char(output.charAt(i));
    j--;
  }
}

void getString() {
  int number = mouseY*256/height;
  String output = str(number);
  string2chars(output);
  print(mouseY,number,output);
  print(' ');
  printDigits();
  print('\n');
}

void mouseClicked() {
  getString();
  sendChars();
}

void sendChars() {
  for (int i = 0;i<num_digits;i++){
   myport.write(output_chars[i]); 
   print(output_chars[i]);
   print('.');
  }
  myport.write('\n');
  println("Sent");
  delay(1000);
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
