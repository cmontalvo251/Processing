void setup(){
  size(480,480);
}

void draw() {
  if (mousePressed) {
    fill(mouseY,0,mouseX);
    ellipse(mouseX,mouseY,240-mouseY/2,240-mouseX/2);
  } else {
    fill(mouseX,mouseY,0);
    ellipse(mouseX,mouseY,mouseY/2,mouseX/2);
  }
  
}
    
