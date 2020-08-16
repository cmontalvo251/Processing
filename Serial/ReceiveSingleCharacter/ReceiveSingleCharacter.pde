import processing.serial.*;

Serial myport;

void setup() {
  size(100,700);
  myport = new Serial(this,"/dev/ttyACM0",9600);
  println("Ready");
}

void draw() {
}

void mouseClicked() {
  int cpx_color = mouseY*255/height;
  String s = str(cpx_color);
  print(cpx_color);
  print(' ');
  print(s);
  if (s.length() < 3) {
    for (int i = 0;i<3-s.length();i++) {
      print(' ');
      print('0');
      print('.');
      myport.write('0');
    }
  }
  for (int i = 0;i<s.length();i++) {
     print(' ');
     print(s.charAt(i));
     print('.');
     myport.write(s.charAt(i));
  }
  myport.write('\n');
  print('\n');
}
