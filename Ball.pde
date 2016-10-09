class Ball {
  PVector pos, vel;
  float radius = 15;
  float m;

  //array to store the old x and y positions
  int num = 4;
  float x[] = new float[num]; 
  float y[] = new float[num];

  PVector old;
  PVector current = new PVector(0, 0);

  Ball(float x, float y) {
    pos = new PVector(x, y);
    vel = new PVector(6, 9); //2,5
    m = radius*.1;
  }

  void draw() {
    //the positions of the ball are recorded into an array and played back every frame. 
    //Between each frame, the newest value are added to the end of the array and the oldest value is deleted
    int current = frameCount % num;
    x[current] = pos.x;
    y[current] = pos.y;

    noStroke();
    for (int i=0; i<num; i++) {
      if (i==0) fill(230, 110, 80,25);//fill(92, 81, 84); //the color closest to the background color
      if (i==1) fill(230, 110, 80,50);//fill(117, 86, 85);
      if (i==2) fill(230, 110, 80,150);//fill(142, 92, 84);
      if (i==3) fill(230, 110, 80,255); //the original color of the ball
      int index = (current+1+i)%num;
      ellipse(x[index], y[index], (radius*2)+i, (radius*2)+i);
    }
    move();
  }

  void move() {
    pos.add(vel);
  }

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
  }

  //void check() {
  //  int currentFrame = frameCount%num;
  //  int index;
  //  if (currentFrame==0) index = 3;
  //  else index = currentFrame-1;
  //  old = new PVector(x[index], y[index]);
  //  println("Old :"+old.x);
  //  current = new PVector(pos.x, pos.y);
  //  println("New :"+current.x);

  //  //get the distance between old and current 
  //  float distanceX = old.x - current.x;
  //  println(distanceX);
  //  float distanceY = old.y - current.y;

  //  for (int i=1; i>0; i--) {
  //    //println(i);
  //    float intervalX = distanceX/i;
  //    float intervalY = distanceY/i;
  //    PVector toCheck = new PVector(old.x+intervalX, old.y+intervalY);// value of intervals of distance to check in each frame

  //    isTouchingWall(toCheck);
  //    isTouchingPaddle(toCheck, paddle);
  //    //check if the ball is touching the brick
  //    for (int row=0; row<bricks.length; row++) {
  //      for (int col=0; col<bricks[row].length; col++) {
  //        isTouchingBrick(toCheck, bricks[row][col]); //check the ball 20 times in each frame
  //      }
  //    }

  //    isTouchingObstacle(toCheck, obstacle);
  //  }
  //}

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

  void DidItLoseALive() {
    if (ball.pos.y + radius > height) { 
      //reset the position of the ball
      ball.pos.x = 450;
      ball.pos.y =450;
      vel = new PVector(4, 6);
      game.lives = game.lives-1;
      paddle.state = "normal"; //paddle state is back to the default 
      return;
    }
  }

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

  //  void isTouchingObstacle(PVector vector, Obstacle obstacle) {
  //    if (obstacle.dead)return; //if the obstacle is dead, then return
  //    //position of obstacle
  //    PVector obs = new PVector(obstacle.x, obstacle.y);
  //    //get distances between the ball and the obstacle
  //    PVector bVect = PVector.sub(vector, obs);

  //    //calculate magnitude of the vector separating the ball and obstacle
  //    float bVectMag = bVect.mag();
  //    println(bVectMag);

  //    if (bVectMag < 60) {
  //      println("OH!");
  //      //get the angle of bVect
  //      float theta = bVect.heading();
  //      //precalculate trig values
  //      float sine = sin(theta);
  //      float cosine = cos(theta);

  //      //the ball's position is relative to the obstacle so we can use the vector between them (bVect) as the reference point in the rotation expression
  //      PVector[] bTemp = {new PVector(), new PVector()};
  //      bTemp[1].x = cosine*bVect.x + sine*bVect.y;
  //      bTemp[1].y = cosine*bVect.y - sine*bVect.x;

  //      //rotate Temporary velocities
  //      PVector[] vTemp = {new PVector()};
  //      vTemp[0].x  = cosine * vel.x + sine * vel.y;
  //      vTemp[0].y  = cosine * vel.y - sine * vel.x;

  //      //after velocities are rotated, we use conservation of momentum equations to calculate velocity along the x-axis
  //      PVector[] vFinal = {new PVector(), new PVector()};

  //      //final rotated velocity for the ball
  //      vFinal[0].x = ((m) * vTemp[0].x / (m));
  //      vFinal[0].y = vTemp[0].y;

  //      // hack to avoid clumping
  //      bTemp[0].x += vFinal[0].x;
  //      bTemp[1].x += vFinal[1].x;

  //      PVector[] bFinal = { new PVector()};

  //      bFinal[0].x = cosine * bTemp[0].x - sine * bTemp[0].y;
  //      bFinal[0].y = cosine * bTemp[0].y + sine * bTemp[0].x;

  //      pos.add(bFinal[0]);

  //      // update velocities
  //      vel.x = cosine * vFinal[0].x - sine * vFinal[0].y;
  //      vel.y = cosine * vFinal[0].y + sine * vFinal[0].x;
  //    }
  //  }

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
