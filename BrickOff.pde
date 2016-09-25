Paddle paddle;
Ball ball;
String[][] colors = {
  {"red", "red", "red", "red", "red", "red", "red", "red"}, 
  {"red", "red", "red", "red", "red", "red", "red", "red"}, 
  {"orange", "orange", "orange", "orange", "orange", "orange", "orange", "orange"}, 
  {"orange", "orange", "orange", "orange", "orange", "orange", "orange", "orange"}, 
  {"yellow", "yellow", "yellow", "yellow", "yellow", "yellow", "yellow", "yellow"}, 
  {"yellow", "yellow", "yellow", "yellow", "yellow", "yellow", "yellow", "yellow"}, 
  {"blue", "blue", "blue", "blue", "blue", "blue", "blue", "blue"}, 
  {"blue", "blue", "blue", "blue", "blue", "blue", "blue", "blue"}};

int BrickWidth = 100;
int BrickHeight = 35;
int offset = 35;
int spacing = 5;
Brick[][] bricks = new Brick[8][8];
Game game;
PImage red, blue, orange, yellow;
int GameWidth = 900;
ImageManager brickShatter;

void setup() {

  size(1300, 900);
  paddle = new Paddle();
  ball = new Ball(450, 450);
  game = new Game();
  brickShatter = new ImageManager();

  for (int row=0; row<colors.length; row++) {
    for (int col=0; col<colors[row].length; col++) {
      bricks[row][col] = new Brick(colors[row][col], ((BrickWidth+spacing)*col)+offset, ((BrickHeight+spacing)*row)+offset);
    }
  }
}

void draw() {
  background(38, 69, 81);
  drawBoundaries();
  paddle.draw();
  ball.draw();
  ball.isTouchingWall();
  ball.isTouchingPaddle(paddle);
  game.build(bricks);
  game.scoreDisplay();

  for (int row=0; row<bricks.length; row++) {
    for (int col=0; col<bricks[row].length; col++) {
      ball.isTouchingBrick(bricks[row][col]);
    }
  }
}

//draw the bounding line at all sides except the bottom
void drawBoundaries() {
  strokeWeight(50);
  stroke(34, 124, 111);
  line(0, 0, GameWidth, 0);
  line(0, 0, 0, height);
  line(GameWidth, 0, GameWidth, height);
}
