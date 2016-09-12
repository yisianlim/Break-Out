class Ball {
  PVector pos, vel;
  float radius = 15;

  Ball(float x, float y) {
    pos = new PVector(x, y);
    vel = new PVector(3, 5);
  }

  void draw() {
    noStroke();
    fill(240, 72, 93);
    ellipse(pos.x, pos.y, radius*2, radius*2);
  }

  void move() {
    pos.add(vel);
  }

  void isTouchingWall() {
    if (ball.pos.x + radius > width-30 || ball.pos.x - radius < 30) vel.x*=-1;
    if (ball.pos.y - radius <30 || ball.pos.y + radius > height) vel.y*=-1;
  }

  void isTouchingPaddle(Paddle paddle) {
    //if statement to prevent ball from repeatedly changing direction 
    
    //for the top of paddle
    if (ball.pos.y+radius>paddle.y && ball.pos.y<paddle.y && ball.pos.x>paddle.x && ball.pos.x<paddle.x+paddle.PWidth) vel.y*=-1;
  }
}