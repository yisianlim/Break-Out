class Ball {
  PVector pos, vel;
  float radius = 15;
  
  //array to store the old x and y positions
  int num = 4;
  float x[] = new float[num]; 
  float y[] = new float[num];

  Ball(float x, float y) {
    pos = new PVector(x, y);
    vel = new PVector(4, 6); 
  }

  void draw() {
//the positions of the ball are recorded into an array and played back every frame. 
//Between each frame, the newest value are added to the end of the array and the oldrest value is deleted
    int current = frameCount % num;
    x[current] = pos.x;
    y[current] = pos.y;

    noStroke();
    for (int i=0; i<num; i++) {
      if (i==0) fill(92, 81, 84); //the color closest to the background color
      if (i==1) fill(117, 86, 85);
      if (i==2) fill(142, 92, 84);
      if (i==3) fill(230, 110, 80); //the original color of the ball
      int index = (current+1+i)%num;
      ellipse(x[index], y[index], (radius*2)+i, (radius*2)+i);
    }
    move();
  }

  void move() {
    pos.add(vel);
  }

  void isTouchingWall() {
    if (ball.pos.x + radius > width-30 || ball.pos.x - radius < 30) vel.x*=-1;
    if (ball.pos.y - radius <30 || ball.pos.y + radius > height) vel.y*=-1;
  }

  void isTouchingPaddle(Paddle paddle) {    
    //for the top of paddle
    if (ball.pos.y+radius>paddle.y && ball.pos.y<paddle.y && ball.pos.x>paddle.x && ball.pos.x<paddle.x+paddle.PWidth){
      vel.y*=-1;
      ball.pos.y = paddle.y-radius;
    }
    
    //left corner of paddle
    if(dist(ball.pos.x, ball.pos.y, paddle.x, paddle.y) < radius){
      vel.y*=-1;
      vel.x*=-1;
    }
    
    //right corner of paddle
    if(dist(ball.pos.x, ball.pos.y, paddle.x+paddle.PWidth, paddle.y) < radius){
      vel.y*=-1;
      vel.x*=-1;
    }
  }
}
