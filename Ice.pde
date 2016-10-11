//shoot in 3 directions 
//paddle loses power up when lose a life
//increase paddle size 
//spawn bricks at each time
//shooting makes the paddle smaller
//shooting allows the obstacle to be destroyed 
//for the ice object that the IceQueen paddle emits
class Ice {
  float x, y;
  float speed=10;
  boolean IceActive;
  PImage img;
  int IceWidth = 10;
  int IceHeight = 20;


  Ice(float x, float y) {
    img = loadImage("ice.png");
    this.x = x;
    this.y = y;
    IceActive = true;
  }

  void move() {
    y -=speed;
    if (y<0) ices.remove(this);
  }

//check if it destroys the brick
  void DestroyedBrick(Brick brick) {
    if (!IceActive || !brick.isActive()) return;
    //if the y coordinate of the ice is less than the bottom of the brick then both the ice and the brick will be the destroyed (inactive)
    if (y<brick.y+BrickHeight && x+IceWidth>brick.x && x<brick.x+BrickWidth) {
      IceActive = false;
      brickShatter.display(brick.x, brick.y);
      brick.deactivate();
      return;
    }
  }

//check if it destroys the obstacle 
  void DestroyedEnemy(Obstacle enemy) {
    if(enemy.dead || !IceActive)return;
    if (y<enemy.y+enemy.ObstacleHeight && x+IceWidth>enemy.x && x<enemy.x+enemy.ObstacleWidth) {
      ObstacleHit.display(enemy.x, enemy.y);
      IceActive = false;
      enemy.HP-=10;
      if(enemy.HP<=0) enemy.dead=true;
      return;
    }
  }

  void draw() {
    if (!IceActive) return;
    image(img, x, y, IceWidth, IceHeight);
  }
}
