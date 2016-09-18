Paddle paddle;
Ball ball;

void setup() {
  size(900, 900);
  frameRate(120);
  paddle = new Paddle();
  ball = new Ball(450,450);
}

void draw() {
  background(38, 69, 81);
  drawBoundaries();
  paddle.draw();
  ball.draw();
  ball.isTouchingWall();
  ball.isTouchingPaddle(paddle);
}

//draw the bounding line at all sides except the bottom
void drawBoundaries() {
  strokeWeight(50);
  stroke(34, 124, 111);
  line(0, 0, width, 0);
  line(0, 0, 0, height);
  line(width, 0, width, height);
}
