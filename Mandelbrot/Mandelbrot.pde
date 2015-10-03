//Plot the Mandelbrot Set

//Initial Global Variables
int gamesize1 = 750;
int gamesize2 = 500;
int lifefactor1 = 5; //Size of game must be lifesize*lifefactor
int lifefactor2 = 5;
int lifesize1 = gamesize1/lifefactor1;
int lifesize2 = gamesize2/lifefactor2;
Complex z = new Complex(0,0);
Complex c = new Complex(0,0);

////Setup the Plotter
void setup()
{
  size(750,500);
  background(255);
    
}

//Draw the Current Iteration of the Mandelbrot Set
void draw()
{
  frameRate(2);
  background(255);
  //z = z^2 + c
  z.multiply(z,z); 
  z.plus(z,c);
  //Print Current Iteration
  z.puts();
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
   real = var1.real*var2.real - var1.imag*var2.imag;
   imag = var1.real*var2.imag + var2.real*var1.imag; 
  }
  void puts() {
    print(real + "+" + imag + "i\n");
  }
}
