class Paddle {
  PImage img;
  float PWidth = 200; //width of paddle
  float PHeight = 25; //height of paddle
  int dx = 10; //speed of paddle

  float x,y;

  Paddle() {
    img = loadImage("paddle.png");
    x = 450;
    y = 750;
  }

  void move() {
    if (keyPressed) {
      if (key == CODED) {
        
        if (keyCode == LEFT) {
          if (x>30) x-=dx; //move to the left as long as it doesn't hit the boundary
        } else if (keyCode == RIGHT) {
          if(x+PWidth<width-30)x+=dx; //move to the right as long as it doesn't hit the boundary
        }
        
      }
    }
  }

  void draw() {
    image(img, x, y, PWidth, PHeight);
  }
}