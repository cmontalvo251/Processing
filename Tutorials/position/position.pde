void setup() {
  // Open the file from the createWriter() example
  size(480,480); 
  String lines[] = loadStrings("positions.txt");
  println(lines);
  for (int ii=0;ii<lines.length;ii++)
  {
    String[] pieces = split(lines[ii], ',');
    float x = float(pieces[0]);
    float y = float(pieces[1]);
    ellipse(x, y,20,20);  
  }
}
