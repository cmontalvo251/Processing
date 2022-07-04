////////VIEWPORT VARIABLES//////////////////
PFont font;

///////////Globals
double NM2FT = 6076.115485560;
double FT2M = 0.3048;
double GPSVAL = 60*NM2FT*FT2M;
double lon_origin = 0;
double lat_origin = 0;
double time_prev = 0;
double latitude_prev = 0;
double longitude_prev = 0;
double X_prev = 0;
double Y_prev = 0;
double heading = 0;
double VXf = 0;
double VYf = 0;

//Calculated Values

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
}

//Alright here is our draw loop
void draw() {  
  //Set the view port color
  background(#000000); // I kept this here if we want to revert the background to original 
  fill(#FFFFFF);
  
  delay(1000);
  
  //Measure time
  double time = millis()/1000.0;
 
  //Software in the loop
  //double speed = 10.0 + 0.0*time;
  //float heading_actual = 45*PI/180.0;
  //double vxactual = 10;
  //double vyactual = 
  //double Xactual = 10*cos((float) time);
  //double Yactual = 10*sin((float) time);
  double xnoise = 6*random(-1.0,1.0);
  double ynoise = 6*random(-1.0,1.0);
  double Xactual = 10*time + xnoise;
  double Yactual = 5*time + ynoise;
  double latactual = 0.0;
  double lonactual = 0.0;
  if (lat_origin == 0 || lon_origin == 0) {
    latactual = 30.69;
    lonactual = -88.1;
  } else {
    latactual = Xactual/GPSVAL + lat_origin;
    float argument = (float) lat_origin*PI/180.0;
    lonactual = Yactual/(GPSVAL*cos(argument))+lon_origin;
  }
  
  //Measure latitude and longitude
  double latitude = latactual;
  double longitude = lonactual;
  
  //Set Origin if needed
  if (lat_origin == 0 || lon_origin == 0) {
    lat_origin = latitude;
    lon_origin = longitude;
  }
  
  //Compute Velocity if previous values populated
  double X = 0;
  double Y = 0;
  double VX = 0;
  double VY = 0;
  double Vtotal = 0;
  if ((time_prev != 0) && (lat_origin != 0)) {
    //First convert to X/Y
    X = (latitude - lat_origin)*GPSVAL;
    float argument = (float) lat_origin*PI/180.0;
    Y = (longitude - lon_origin)*GPSVAL*cos(argument);
    
    //Then Compute the delta
    double dx = X-X_prev;
    double dy = Y-Y_prev;
    double dt = time-time_prev;
    //And the velocity
    VX = dx/dt;
    VY = dy/dt;
    
    //Filter
    float filterconstant = 0.2;
    VXf = VX*filterconstant + (1-filterconstant)*VXf;
    VYf = VY*filterconstant + (1-filterconstant)*VYf;
    
    //println("dx = ",dx,"latitude = ",latitude," latitude_prev = ",latitude_prev);
    //println("dx = ",dx,"X = ",X," X_prev = ",X_prev,"latitude = ",latitude,"latitude_prev = ",latitude_prev," latactual = ",latactual," Xactual = ",Xactual);
    argument = (float) (VXf*VXf + VYf*VYf);
    Vtotal = sqrt(argument);
    
    //Compute Heading
    heading = atan2((float) VYf,(float) VXf)*180.0/PI;
    if (heading < 0) {
      heading += 360;
    }
  }
  
  //Place Text
  stroke(255);
  textFont(font, 8*((width+height)/2.0)/200.0);  //set the textfont to Courier and size 20
  textAlign(LEFT, TOP); //set the test to left and top
  text("Current Time: ",width*0.1,height*0.1);
  text(str((float) time),width*0.8,height*0.1);
  
  text("Current Latitude: ",width*0.1,height*0.15);
  text(str((float) latitude),width*0.8,height*0.15);  
  
  text("Current Longitude: ",width*0.1,height*0.2);
  text(str((float) longitude),width*0.8,height*0.2);
  
  //text("Previous Latitude: ",width*0.1,height*0.25);
  //text(str(latitude_prev),width*0.8,height*0.25);  
  
  //text("Previous Longitude: ",width*0.1,height*0.3);
  //text(str(longitude_prev),width*0.8,height*0.3);
  
  text("Latitude Origin: ",width*0.1,height*0.25);
  text(str((float) lat_origin),width*0.8,height*0.25);  
  
  text("Longitude Origin: ",width*0.1,height*0.3);
  text(str((float) lon_origin),width*0.8,height*0.3);
  
  text("X coordinate: ",width*0.1,height*0.35);
  text(str((float) X),width*0.8,height*0.35);  
  
  text("Y coordinate: ",width*0.1,height*0.4);
  text(str((float) Y),width*0.8,height*0.4);
  
  text("X velocity: ",width*0.1,height*0.45);
  text(str((float) VXf),width*0.8,height*0.45);  
  
  text("Y velocity: ",width*0.1,height*0.5);
  text(str((float) VYf),width*0.8,height*0.5);
  
  text("Total velocity: ",width*0.1,height*0.55);
  text(str((float) Vtotal),width*0.8,height*0.55); 
  
  text("Heading: ",width*0.1,height*0.6);
  text(str((float) heading),width*0.8,height*0.6); 
  
  
  //Set previous timestep vals
  time_prev = time;
  latitude_prev = latitude;
  longitude_prev = longitude;
  X_prev = X;
  Y_prev = Y;
  
}
