
class Drop {
  float x = random(width);
  float y=random(-200, -100);
  float yspeed= random(8, 14);

  void fall() {
    y = y+yspeed;
    if (y>height) {
      y = random(-200, -100);
    }
  }

  void show() {
    fall();
    fill(145, 29, 6);
    ellipse(x, y, 20, 20);
  }
}