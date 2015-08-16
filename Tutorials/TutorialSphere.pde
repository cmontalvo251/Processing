void setup() {
  size(1000, 1000, P3D); 
}

void draw() {
  background(200);
  stroke(255, 50);
  translate(500, 500, 0);
  rotateX(mouseY * 0.05);
  rotateY(mouseX * 0.05);
  fill(mouseX/4 , 0, 160);
  sphereDetail(mouseX / 4);
  sphere(400);
}
