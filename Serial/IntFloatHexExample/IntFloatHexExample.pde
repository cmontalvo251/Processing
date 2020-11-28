//Sending = -3.600000 -1067030938 
//Hex = H:c0666666  
//Sending = 4.500000 1083179008 
//Hex = H:40900000  
//Sending = 2.400000 1075419546 
//Hex = H:4019999a  

void setup() {
  size(200,200);
  float num = -3.6;
  int bits = Float.floatToIntBits(num);
  String str = Integer.toBinaryString(bits);
  String hexa = hex(bits);
  //int maxN = unhex("C0666666");
  int maxN =   unhex("7FFFFFFF");
  println(num);
  println(str);
  println(bits);
  println(hexa);
  println(maxN);
  
  
}

void draw() {
}
