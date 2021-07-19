////////////GLOBAL VARIABLES/////////////
int numVars = 7;
float[] received_data = new float[numVars];

////////VIEWPORT VARIABLES//////////////////
PFont font;

///////////SERIAL VARIABLS
//In order to talk to the Arduino
import processing.serial.*;
Serial myport;
char[]inLine = new char[60];

///////////////DATALOGGING VARIABLES//////////
PrintWriter file;

////FLAGS
void setup() 
{  
  //SETUP VIEW WINDOM
  size(400,400, P3D); //set view size with 3D processing
  surface.setResizable(true);

  //BACKGROUND
  // I put the background in setup not draw this causes corners to be cut off on the cube
  background(#000000);
 
  ////CREATE A FONT
  font = createFont("Courier", 18); //built in processing command
 
  try {
    myport = new Serial(this,"/dev/ttyUSB0",57600);
  } catch (RuntimeException e) {
    print("Error Opening Serial Port");
  }

  ///SETUP DATALOGGING FILE
  int d = day();    // Values from 1 - 31
  int m = month();  // Values from 1 - 12
  int y = year();   // 2003, 2004, 2005, etc.
  int s = second();  // Values from 0 - 59
  int min = minute();  // Values from 0 - 59
  int h = hour();    // Values from 0 - 23
  file = createWriter("Logging_"+str(y)+"_"+str(m)+"_"+str(d)+"_"+str(h)+"_"+str(min)+"_"+str(s)+".txt");
 
  //Initialize all receive vars to zero
  for (int i = 0;i<numVars;i++){
    received_data[i] = 0;
  }
  
  println("Ready");
}

//Alright here is our draw loop
void draw() {
    
  ////Check for Response EveryLoop
  //H:nnnnnnn\r<mutiplenumbers>\n
  if (myport.available()>0) {
    print("Something is in the pipe\n");
    SerialGetNumber();
  }
  
  //Set the view port color
  background(#000000); // I kept this here if we want to revert the background to original 
  fill(#FFFFFF);
  
  //GRID 2,1 - PTP
  stroke(255);
  textFont(font, 8*((width+height)/2.0)/200.0);  //set the textfont to Courier and size 20
  textAlign(LEFT, TOP); //set the test to left and top
  for (int i = 0;i<numVars;i++) {
    text(received_data[i] + "\n",width/3.0,height*i/numVars);
  }
}
  
//Write data to file
void logdata() {
  //Log Data to Home Screen
  print("Logging Data: ");
  for (int idx = 0;idx<numVars;idx++) {
    print(received_data[idx] + " ");
    file.write(received_data[idx]+" ");
  }
  file.write("\n");
  file.flush();
  print("\n");
}

void SerialGetNumber() {
  int d = 0;
  int i = 0;
  char inchar = '\0';
  int numchars_received = 0;
  int w = 0;
  //Set some key characters in inLine to NULL
  for (int j = 0;j<12;j++) {
    inLine[j] = '\0';
  }
  println("Waiting for characters");
  do {
    w = 0;
    do {
      inchar = myport.readChar();
      if (numchars_received>0) {
        w++;
      }
    } while ((int(inchar) == 65535) && (w<100000));
    if (int(inchar) != 65535) {
      println("Receiving: i = "+str(i)+" char = "+inchar+" chartoint = " + str(int(inchar)));
      inLine[i++] = inchar;
      numchars_received++; 
    } else {
      print("Loss of communcation w = " + str(w) + "\n");
      return;
    }
  } while ((inchar != '\r') && (i<60));
  println("Response received");
   
  // Now Convert from ASCII to HEXSTRING to FLOAT
  if ((inLine[1] == ':') && ((inLine[10] == '\r') || (inLine[11] == '\r'))) {
     // Format from Arduino:
    // H:nnnnnnnn
    d = int(inLine[0])-48;
    print("Index Received = "+str(d)+"\n");
    String inString = String.valueOf(inLine);
    println("Converting to Float");
    String clean = inString.substring(2).replaceAll(" ","");
    String truncated = clean.substring(0,8);
    println(inString);
    println(clean);
    println(truncated);
    received_data[d] = Float.intBitsToFloat(unhex(truncated));
  }
  //Update time that we received a response
  if (d == numVars - 1) {
    logdata();
  }
}
