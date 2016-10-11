class Ball {
  PVector pos, vel;
  float radius = 15;
  float m;
  boolean BallMoved = false;

  //array to store the old x and y positions
  int num = 4;
  float x[] = new float[num]; 
  float y[] = new float[num];

  PVector old;
  PVector current = new PVector(0, 0);

  Ball(float x, float y) {
    pos = new PVector(x, y);
    vel = new PVector(0, 0); //2,5
  }

  void HasBallMoved() {
    if (keyPressed) if (key=='s') {
      BallMoved = true;
      vel = new PVector(2, 5);
    }
  }


  void draw() {
    //the positions of the ball are recorded into an array and played back every frame. 
    //Between each frame, the newest value are added to the end of the array and the oldest value is deleted
    int current = frameCount % num;
    x[current] = pos.x;
    y[current] = pos.y;

    noStroke();
    for (int i=0; i<num; i++) {
      if (i==0) fill(101, 239, 184, 25);
      if (i==1) fill(101, 239, 184, 50);
      if (i==2) fill(101, 239, 184, 150);
      if (i==3) fill(101, 239, 184, 255);
      int index = (current+1+i)%num;
      ellipse(x[index], y[index], (radius*2)+i, (radius*2)+i);
    }
    move();
  }

  void move() {
    pos.add(vel);
  }

  //the different checks for the ball for each level
  void check() {
    isTouchingWall(pos);
    isTouchingPaddle(pos, paddle);
    if (GameLevel1) {
      for (int row=0; row<bricks.length; row++) {
        for (int col=0; col<bricks[row].length; col++) {
          isTouchingBrick(pos, bricks[row][col]);
        }
      }
    }
    if (GameLevel2) {
      for (int row=0; row<bricks2.length; row++) {
        for (int col=0; col<bricks2[row].length; col++) {
          if (bricks2[row][col]!=null) {
            isTouchingBrick(pos, bricks2[row][col]);
          }
        }
      }
      isTouchingObstacle(pos, obstacle);
    }

    if (GameLevel3) {
      for (int row=0; row<bricks3.length; row++) {
        for (int col=0; col<bricks3[row].length; col++) {
          if (bricks3[row][col]!=null) {
            isTouchingBrick(pos, bricks3[row][col]);
          }
        }
      }
      isTouchingObstacle(pos, obstacle);
      isTouchingObstacle(pos, obstacle2);
      isTouchingObstacle(pos, obstacle3);
    }
  }

  //to check if the ball went past the bottom boundary and lost a live
  void DidItLoseALive() {
    if (ball.pos.y + radius > height) { 
      //reset the position of the ball
      ball = new Ball(paddle.x+paddle.PWidth/2, 730);
      game.lives = game.lives-1;
      paddle.state = "normal"; //paddle state is back to the default 
      return;
    }
  }

  //check if the ball touch the boundary
  void isTouchingWall(PVector vector) {
    if (vector.x + radius > GameWidth-20) {
      vel.x*=-1;
      ball.pos.x = (GameWidth-30)-radius;
    }
    if (vector.x - radius < 30) {
      vel.x*=-1;
      ball.pos.x = 30+radius;
    }
    if (vector.y - radius <30) {
      vel.y*=-1;
      ball.pos.y = 30+radius;
    }
  }

  //check if the ball touch the paddle
  void isTouchingPaddle(PVector vector, Paddle paddle) {    
    //for the top of paddle
    if (vector.y+radius>paddle.y && vector.y<paddle.y && vector.x>paddle.x && vector.x<paddle.x+paddle.PWidth) {
      vel.y*=-1;
      ball.pos.y = paddle.y-radius;
    }

    //left corner of paddle
    if (dist(vector.x, vector.y, paddle.x, paddle.y) < radius) {
      vel.y*=-1;
      vel.x*=-1;
    }

    //right corner of paddle
    if (dist(vector.x, vector.y, paddle.x+paddle.PWidth, paddle.y) < radius) {
      vel.y*=-1;
      vel.x*=-1;
    }

    //for the left of paddle
    if (vector.y > paddle.y && vector.y < paddle.y+paddle.PHeight && vector.x+radius > paddle.x && vector.x<paddle.x) {
      vel.x*=-1;
    }

    //for the right of obstacle
    if (vector.y > paddle.y && vector.y < paddle.y+ paddle.PHeight && vector.x+radius > paddle.x+paddle.PWidth && vector.x-radius <paddle.x+paddle.PWidth) {
      vel.x*=-1;
    }
  }

  //check if the ball is touching the brick
  void isTouchingBrick(PVector vector, Brick brick) {
    if (!brick.isActive())return;

    //for the bottom of the brick
    if (vector.y-radius<brick.y+BrickHeight && vector.y>brick.y+BrickHeight && vector.x>brick.x && vector.x<brick.x+BrickWidth) {
      vel.y*=-1;
      brickShatter.display(brick.x, brick.y);
      brick.deactivate();
    }

    //for the top of the brick
    if (vector.y+radius > brick.y && vector.y-radius < brick.y && vector.x > brick.x && vector.x<brick.x+BrickWidth) {
      vel.y*=-1;
      brickShatter.display(brick.x, brick.y);
      brick.deactivate();
    }

    //for the left of brick
    if (vector.y > brick.y && vector.y < brick.y+ BrickHeight && vector.x+radius > brick.x && vector.x<brick.x) {
      vel.x*=-1;
      brickShatter.display(brick.x, brick.y);
      brick.deactivate();
    }

    //for the right of brick
    if (vector.y > brick.y && vector.y < brick.y+ brick.BrickHeight && vector.x+radius > brick.x+BrickWidth && vector.x-radius <brick.x+BrickWidth) {
      vel.x*=-1;
      brickShatter.display(brick.x, brick.y);
      brick.deactivate();
    }

    //for the top right corner
    if (dist(vector.x, vector.y, brick.x+BrickWidth, brick.y) < radius) {
      vel.y*=-1;
      vel.x*=-1;
      brickShatter.display(brick.x, brick.y);
      brick.deactivate();
    }

    //for the top left of paddle
    if (dist(vector.x, vector.y, brick.x, brick.y) < radius) {
      vel.y*=-1;
      vel.x*=-1;
      brickShatter.display(brick.x, brick.y);
      brick.deactivate();
    }

    //for the bottom right corner
    if (dist(vector.x, vector.y, brick.x, brick.y+BrickHeight) < radius) {
      vel.y*=-1;
      vel.x*=-1;
      brickShatter.display(brick.x, brick.y);
      brick.deactivate();
    }

    //for the bottom left corner
    if (dist(vector.x, vector.y, brick.x+BrickWidth, brick.y+BrickHeight) < radius) {
      vel.y*=-1;
      vel.x*=-1;
      brickShatter.display(brick.x, brick.y);
      brick.deactivate();
    }
  }

  //check if the ball is touching the obstacle
  void isTouchingObstacle(PVector vector, Obstacle obstacle) {
    if (obstacle.dead)return; //if the obstacle is dead, then return

    //for the bottom of the obstacle
    if (vector.y-radius<obstacle.y+obstacle.ObstacleHeight && vector.y>obstacle.y+obstacle.ObstacleHeight && vector.x>obstacle.x && vector.x<obstacle.x+obstacle.ObstacleWidth) {
      vel.y*=-1;
      ball.pos.y = (obstacle.y+obstacle.ObstacleHeight)+radius;
    }

    //for the top of the obstacle
    if (vector.y+radius > obstacle.y && vector.y-radius < obstacle.y && vector.x > obstacle.x && vector.x<obstacle.x+ obstacle.ObstacleWidth) {
      vel.y*=-1;
      ball.pos.y = obstacle.y-radius;
    }

    //for the left of obstacle
    if (vector.y > obstacle.y && vector.y < obstacle.y+obstacle.ObstacleHeight && vector.x+radius > obstacle.x && vector.x<obstacle.x) {
      vel.x*=-1;
    }

    //for the right of obstacle
    if (vector.y > obstacle.y && vector.y < obstacle.y+ obstacle.ObstacleHeight && vector.x+radius > obstacle.x+obstacle.ObstacleWidth && vector.x-radius <obstacle.x+obstacle.ObstacleWidth) {
      vel.x*=-1;
    }

    //for the top right corner
    if (dist(vector.x, vector.y, obstacle.x+obstacle.ObstacleWidth, obstacle.y) < radius) {
      vel.y*=-1;
      vel.x*=-1;
    }

    //for the top left of obstacle
    if (dist(vector.x, vector.y, obstacle.x, obstacle.y) < radius) {
      vel.y*=-1;
      vel.x*=-1;
    }

    //for the bottom right corner
    if (dist(vector.x, vector.y, obstacle.x, obstacle.y+obstacle.ObstacleHeight) < radius) {
      vel.y*=-1;
      vel.x*=-1;
    }

    //for the bottom left corner
    if (dist(vector.x, vector.y, obstacle.x+obstacle.ObstacleWidth, obstacle.y+obstacle.ObstacleHeight) < radius) {
      vel.y*=-1;
      vel.x*=-1;
    }


    //backup check 
    //for the bottom of the obstacle
    float x0 = obstacle.x + (obstacle.ObstacleWidth/6);
    float y0 = obstacle.y + (obstacle.ObstacleHeight/6);
    float w0 = (2/3)*(obstacle.ObstacleWidth);
    float h0 = (2/3)*(obstacle.ObstacleHeight);



    if (vector.y-radius<y0+h0 && vector.y>y0+h0 && vector.x>x0 && vector.x<x0+w0) {
      vel.y*=-1;
      ball.pos.y = (obstacle.y+obstacle.ObstacleHeight)+radius;
    }

    //for the top of the obstacle
    if (vector.y+radius > y0 && vector.y-radius < y0 && vector.x > x0 && vector.x<x0+w0) {
      vel.y*=-1;
      ball.pos.y = obstacle.y-radius;
    }

    //for the left of obstacle
    if (vector.y > y0 && vector.y < y0+h0 && vector.x+radius > x0 && vector.x<x0) {
      vel.x*=-1;
    }

    //for the right of obstacle
    if (vector.y > y0 && vector.y < y0+h0 && vector.x+radius > x0+w0 && vector.x-radius <x0+w0) {
      vel.x*=-1;
    }

    //for the top right corner
    if (dist(vector.x, vector.y, x0+w0, y0) < radius) {
      vel.y*=-1;
      vel.x*=-1;
    }

    //for the top left of obstacle
    if (dist(vector.x, vector.y, x0, y0) < radius) {
      vel.y*=-1;
      vel.x*=-1;
    }

    //for the bottom right corner
    if (dist(vector.x, vector.y, x0, y0+h0) < radius) {
      vel.y*=-1;
      vel.x*=-1;
    }

    //for the bottom left corner
    if (dist(vector.x, vector.y, x0+w0, y0+h0) < radius) {
      vel.y*=-1;
      vel.x*=-1;
    }
  }
}
