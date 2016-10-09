class Paddle {
  PImage img, transformedPaddle;
  float PWidth = 200; //width of paddle
  float PHeight = 25; //height of paddle
  int dx = 15; //speed of paddle
  float x, y;
  String state;
  String prevState;

  Paddle() {
    img = loadImage("paddle.png");
    transformedPaddle = loadImage("transformed.png");
    x = 450;
    y = 750;
    state = "normal";
  }

  void move() {
    if (keyPressed) {
      if (key == CODED) {

        if (keyCode == LEFT) {
          if (x>30) x-=dx; //move to the left as long as it doesn't hit the boundary
        } else if (keyCode == RIGHT) {
          if (x+PWidth<GameWidth-30)x+=dx; //move to the right as long as it doesn't hit the boundary
        }
      }
      if (key==' ' && frameCount%5==0 && ((paddle.state.equals("transformed")) || (paddle.state.equals("sizer") && paddle.prevState.equals("transformed")))) {
        //create new ice 
        Ice ice = new Ice(x+(PWidth/2), y-20);
        ices.add(ice);
      }
    }
  }

  boolean PaddleCaughtTheSpecialBrick(Brick special) {
    //if the paddle intersects with the special brick
    if (special.y+BrickHeight>paddle.y && (special.x+BrickWidth/2)>x && (special.x+BrickWidth/2)<x+PWidth && special.y < paddle.y) {
      return true;
    }
    return false;
  }

  void draw() {
    move();
    if (paddle.state.equals("transformed")) {
      image(transformedPaddle, x, y, PWidth, PHeight);
    }
    else if(paddle.state.equals("sizer")){
      PWidth = 300;
      if(paddle.prevState.equals("transformed")) image(transformedPaddle, x, y, PWidth, PHeight); 
      else image(img, x, y, PWidth, PHeight);
    }
    
    else if(paddle.state.equals("normal")){
      PWidth = 200;
      image(img, x, y, PWidth, PHeight);
    }
  }
}
