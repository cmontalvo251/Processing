////////////GLOBAL VARIABLES/////////////
float MilesinScramble = 65;
float ScrambleHours = 24;
float RequiredPace = MilesinScramble/ScrambleHours;

////////VIEWPORT VARIABLES//////////////////
PFont font;

///////////Inputs
float StartTimeHour = 8;
float StartTimeMinutes = 0;
float CurrentTimeHour = 12;
float CurrentTimeMinutes = 0;
float MilesCompleted = 12;

//Calculated Values
float CurrentTime_Minutes = 0;
float StartTime_Minutes = 0;
float HowLongRacing_Minutes = 0;
float HowLongRacing_Hours = 0;
float HowFarShouldTraveled = 0;
float MilesAheadorBehind = 0;
float HowLongShouldGoneBy = 0;
float HoursAheadorBehind = 0;
float MinutesAheadorBehind = 0;

////FLAGS
void setup() 
{  
  //SETUP VIEW WINDOM
  size(800,400, P3D); //set view size with 3D processing
  surface.setResizable(true);

  //BACKGROUND
  // I put the background in setup not draw this causes corners to be cut off on the cube
  background(#000000);
 
  ////CREATE A FONT
  font = createFont("Courier", 18); //built in processing command
  println("Ready");
  
  //Make all Calculations
  CurrentTime_Minutes = CurrentTimeHour*60 + CurrentTimeMinutes;
  StartTime_Minutes = StartTimeHour*60 + StartTimeMinutes;
  HowLongRacing_Minutes = CurrentTime_Minutes - StartTime_Minutes;
  HowLongRacing_Hours = HowLongRacing_Minutes / 60.0;
  HowFarShouldTraveled = HowLongRacing_Hours * RequiredPace;
  MilesAheadorBehind = MilesCompleted - HowFarShouldTraveled;
  HowLongShouldGoneBy = MilesCompleted / RequiredPace;
  HoursAheadorBehind = HowLongShouldGoneBy - HowLongRacing_Hours;
  MinutesAheadorBehind = HoursAheadorBehind * 60;
}

//Alright here is our draw loop
void draw() {  
  //Set the view port color
  background(#000000); // I kept this here if we want to revert the background to original 
  fill(#FFFFFF);
  
  //Place Text
  stroke(255);
  textFont(font, 8*((width+height)/2.0)/200.0);  //set the textfont to Courier and size 20
  textAlign(LEFT, TOP); //set the test to left and top
  text("Current Time in Minutes: ",width*0.1,height*0.1);
  text(str(CurrentTime_Minutes),width*0.8,height*0.1);
  
  text("Start Time in Minutes: ",width*0.1,height*0.15);
  text(str(StartTime_Minutes),width*0.8,height*0.15);
  
  text("How Long Have you been racing (min)?: ",width*0.1,height*0.2);
  text(str(HowLongRacing_Minutes),width*0.8,height*0.2);
  
  text("How Long Have you been racing (hr)?: ",width*0.1,height*0.25);
  text(str(HowLongRacing_Hours),width*0.8,height*0.25);
  
  text("How far should you have traveled?: ",width*0.1,height*0.3);
  text(str(HowFarShouldTraveled),width*0.8,height*0.3);
  
  text("Miles ahead or behind: ",width*0.1,height*0.35);
  text(str(MilesAheadorBehind),width*0.8,height*0.35);
  
  text("How many hours should have gone by?: ",width*0.1,height*0.4);
  text(str(HowLongShouldGoneBy),width*0.8,height*0.4);
  
  text("Hours ahead or behind: ",width*0.1,height*0.45);
  text(str(HoursAheadorBehind),width*0.8,height*0.45);
  
  text("Minutes ahead or behind: ",width*0.1,height*0.5);
  text(str(MinutesAheadorBehind),width*0.8,height*0.5);
  
}
