//Plot the Mandelbrot Set

//Initial Global Variables
int gamesize1 = 600;
int gamesize2 = 600;
int lifefactor1 = 1; //Size of game must be lifesize*lifefactor
int lifefactor2 = 1;
int lifesize1 = gamesize1/lifefactor1;
int lifesize2 = gamesize2/lifefactor2;
int current_iteration = 0;
//Save Iterations
int[][] iter_matrix;
//Save c Number and initial z
Complex[][] z_matrix;
Complex c;
//Complex[][] c_matrix;

////Setup the Plotter
void setup()
{
  size(600,600);
  //Setup Matrices
  iter_matrix = new int[lifesize1][lifesize2];
  z_matrix = new Complex[lifesize1][lifesize2];
  c = new Complex(random(-1.0,1.0),random(-1.0,1.0));
  //c = new Complex(-1.5,1.0);
  for (int idx = 0;idx<lifesize1;idx++)
  {
    float real = -2.0+float(idx)/(float(lifesize1)-1)*4.0;
    //float real = 0.28;
    for (int jdx = 0;jdx<lifesize2;jdx++)
    {
     float imag = -2.0+float(jdx)/(float(lifesize2)-1)*4.0;
     //float imag = 0.0;
     //print(real+" "+imag+"\n");
     //c_matrix[idx][jdx] = new Complex(real,imag);
     z_matrix[idx][jdx] = new Complex(real,imag);
     iter_matrix[idx][jdx] = 0;
    }
  }
  
}

//Draw the Current Iteration of the Mandelbrot Set
void draw()
{
  //Clear Screen to white
  background(255);
  
  ///Set Frame Rate
  //frameRate(10);
  
  //Increment Iteration Number
  current_iteration++;
  print(current_iteration+"\n");
  
  //Plot Iterate
  spy(iter_matrix,current_iteration);
  
  //Iterate z_matrix
  for (int idx = 0;idx<lifesize1;idx++) {
    for (int jdx = 0;jdx<lifesize2;jdx++) {
      //z = z^2 + c
      //print("idx = "+idx+" jdx = "+jdx+"\n");
      //z_matrix[idx][jdx].puts();
      //c_matrix[idx][jdx].puts();
      //print(iter_matrix[idx][jdx]+"\n");
      //print(z_matrix[idx][jdx].getMagnitude()+"\n");
      //textSize(10);
      //fill(255,0,0);
      //text(nf(z_matrix[idx][jdx].real,1,2)+" "+nf(z_matrix[idx][jdx].imag,1,2)+"i",(idx+0.5)*lifefactor1,(jdx+0.5)*lifefactor2);
      //text(z_matrix[idx][jdx].getMagnitude(),(idx+0.5)*lifefactor1,(jdx+0.5)*lifefactor2);
      //text("Test",300,300); 
      if (z_matrix[idx][jdx].getMagnitude() > 2.0) {
        if (iter_matrix[idx][jdx] == 0) {
          iter_matrix[idx][jdx] = current_iteration;
        }
      } else {
        z_matrix[idx][jdx].multiply(z_matrix[idx][jdx],z_matrix[idx][jdx]);
        z_matrix[idx][jdx].plus(z_matrix[idx][jdx],c);
      }
     }
  }
}

void spy(int[][] info,int current_iteration)
{
 for (int i = 0;i<lifesize1;i++) {
    for (int j = 0;j<lifesize2;j++) {
      //Convert info[i][j] to from -1 to 1
      float gray = -1.0 + float(info[i][j])*2.0/float(current_iteration);
      int r = int(255*red(gray));
      int g = int(255*green(gray));
      int b = int(255*blue(gray));
      stroke(r,g,b);
      fill(r,g,b);
      rect(lifefactor1*i,lifefactor2*j,lifefactor1,lifefactor2);
    }
  }
}

///Colormap Jet from - http://stackoverflow.com/questions/7706339/grayscale-to-red-green-blue-matlab-jet-color-scale - 10/4/2015
float interpolate( float val, float y0, float x0, float y1, float x1 ) {
    return (val-x0)*(y1-y0)/(x1-x0) + y0;
}

float base( float val ) {
    if ( val <= -0.75 ) return 0;
    else if ( val <= -0.25 ) return interpolate( val, 0.0, -0.75, 1.0, -0.25 );
    else if ( val <= 0.25 ) return 1.0;
    else if ( val <= 0.75 ) return interpolate( val, 1.0, 0.25, 0.0, 0.75 );
    else return 0.0;
}

float red( float gray ) {
    return base( gray - 0.5 );
}
float green( float gray ) {
    return base( gray );
}
float blue( float gray ) {
    return base( gray + 0.5 );
}

///Complex Number Toolbox - C. Montalvo 10/3/2015
class Complex {
  float real,imag;
  Complex (float real_in,float imag_in) {
    real = real_in;
    imag = imag_in;   
  }
  void plus(Complex var1,Complex var2) {
   real = var1.real + var2.real;
   imag = var1.imag + var2.imag; 
  }
  void multiply(Complex var1,Complex var2) {
   float realtemp = var1.real*var2.real - var1.imag*var2.imag;
   imag = var1.real*var2.imag + var2.real*var1.imag;
   real = realtemp;
   //imag = imagtemp; 
  }
  //void iterate(Complex var1,Complex var2) {
  // multiply(var1,var1);
  // plus(var1,var2); 
  //}
  float getMagnitude() {
   return (sqrt(real*real + imag*imag)); 
  }
  void puts() {
    print(real + "+" + imag + "i\n");
  }
}
