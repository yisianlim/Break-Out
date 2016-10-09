//this is a class of obstacle that the ball interacts with
class Obstacle{
  PImage img;
  float ObstacleWidth = 60;//60; //width of obstacle
  float ObstacleHeight = 40;//40; //height of obstacle
  int HP;
  int dx = 5; //speed of obstacle
  boolean dead = false;

  float x,y;

  Obstacle() {
    img = loadImage("obstacle.png");
    x = 450;
    y = 520;
    HP = 100;
  }
  
  void move() {
    x +=dx;
    if(x<35) dx*=-1;
    else if(x+ObstacleWidth>GameWidth-30)dx*=-1;
  }

  void draw() {
    move();
    if(HP>0)image(img, x, y, ObstacleWidth, ObstacleHeight);
  }
}