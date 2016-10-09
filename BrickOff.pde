Paddle paddle;
Ball ball;
ArrayList<Ice> ices;
int BrickWidth = 100;
int BrickHeight = 35;
int offset = 40;
int spacing = 5;
Brick[][] bricks; //brick array for level 1
Brick[][] bricks2; //brick array for leve 2
Game game;
PImage bg;
int GameWidth = 900;
ImageManager brickShatter;
ImageManager heart;
ImageManager ObstacleHit;
StartScreen screen;
Obstacle obstacle;
Explosion explode;
GameOver gameOver;

boolean GameLevel1;
boolean GameLevel2;
boolean GameOver;

/*********************************SPECIAL BRICK GENERATOR*******************************/
//LEVEL 1
int ROW, COL, ROW1, COL1, ROW2, COL2, ROW3, COL3;
Brick iceQueenBrick, iceQueenBrick2, sizerBrick, LiveBrick;

//LEVEL2
Brick Level2IceQueenBrick1, Level2IceQueenBrick2, Level2LiveBrick, Level2sizerBrick1, Level2sizerBrick2;
/***************************************************************************************/

void setup() {

  size(1300, 900);
  reset();
  frameRate(100);
}

void reset() {
  bg = loadImage("GameBG.png");
  explode = new Explosion(1000, 500);
  //generate the chosen row & col of the special brick to make the paddle go on ice queen mode
  ROW = 1;
  COL = (int)random(0, 7);
  ROW1 = 7;
  COL1 = (int)random(0, 7);

  //generate the chosen row & col of the sizer brick to make the paddle increase in size
  ROW2 = 6;
  COL2 = (int)random(0, 7);

  //generate the chosen row & col of the live brick to allow the player to gain more lives
  ROW3 = 7;
  COL3 = (int)random(0, 7);

  GameLevel1 = false;
  GameOver = false;
  GameLevel2 = false;
  gameOver = new GameOver();
  bricks  = new Brick[8][8]; 
  bricks2 = new Brick[10][8];
  paddle = new Paddle();
  ball = new Ball(450, 450);
  game = new Game();
  brickShatter = new ImageManager("poof");
  heart = new ImageManager("heart");
  ObstacleHit = new ImageManager("obstacleHIT");
  screen = new StartScreen();
  obstacle = new Obstacle();
  ices = new ArrayList<Ice>();

  for (int row=0; row<game.colors.length; row++) {
    for (int col=0; col<game.colors[row].length; col++) {
      if (game.colors[row][col]!=null) {
        bricks[row][col] = new Brick(game.colors[row][col], ((BrickWidth+spacing)*col)+offset, ((BrickHeight+spacing)*row)+offset);
      }
    }
  }

  for (int row=0; row<game.colors2.length; row++) {
    for (int col=0; col<game.colors2[row].length; col++) {
      if (game.colors2[row][col]!=null) {
        bricks2[row][col] = new Brick(game.colors2[row][col], ((BrickWidth+spacing)*col)+offset, ((BrickHeight+spacing)*row)+offset);
      }
    }
  }
}

void draw() {
  if (!GameLevel1) {
    screen.display();
    if (screen.GameHasStarted()) {
      GameLevel1 = true;
      GameLevel2 = false;
    }
  }

  if (GameLevel1 && !GameLevel2) {

    background(38, 69, 81);
    //image(bg,25,25,860,900);
    explode.draw();
    drawBoundaries();
    paddle.draw();
    ball.draw();
    ball.check();
    ball.DidItLoseALive();
    game.build(bricks);
    game.scoreDisplay();
    game.DrawLives();

    iceQueenBrick.specialBrickMove();
    iceQueenBrick2.specialBrickMove();
    sizerBrick.specialBrickMove();
    LiveBrick.specialBrickMove();

    //check if the ice destroyed the bricks 
    for (int i=0; i<ices.size(); i++) {
      if (i>=ices.size() || ices.size()<=0)break;
      ices.get(i).move();
      if (ices.size()>0) {
        ices.get(i).draw();
      }
      //check if the ice is touching any brick
      for (int row=0; row<bricks.length; row++) {
        for (int col=0; col<bricks[row].length; col++) {
          if (ices.size()>0)ices.get(i).DestroyedBrick(bricks[row][col]);
        }
      }
    }

    if (game.GameIsOver()) {
      GameLevel1 = false;
      GameLevel2 = false;
      GameOver = true;
    }

    if (game.checkIfItAdvances()) {
      GameLevel1 = false;
      GameLevel2 = true;
      ball = new Ball(450, 450);
    }
  } else if (GameLevel2) {
    background(38, 69, 81);
    drawBoundaries();
    paddle.draw();
    obstacle.draw();
    ball.draw();
    ball.check();
    ball.DidItLoseALive();
    game.build(bricks2);
    game.scoreDisplay();
    game.DrawLives();
    game.DrawHP(obstacle.HP);

    Level2IceQueenBrick1.specialBrickMove(); 
    Level2IceQueenBrick2.specialBrickMove(); 
    Level2LiveBrick.specialBrickMove(); 
    Level2sizerBrick1.specialBrickMove(); 
    Level2sizerBrick2.specialBrickMove();

    //check if the ice destroyed the bricks 
    for (int i=0; i<ices.size(); i++) {
      if (i>=ices.size() || ices.size()<=0)break;
      ices.get(i).move();
      if (ices.size()>0) {
        if (GameLevel2)ices.get(i).DestroyedEnemy(obstacle);
        ices.get(i).draw();
      }
      //check if the ice is touching any brick
      for (int row=0; row<bricks2.length; row++) {
        for (int col=0; col<bricks2[row].length; col++) {
          if (ices.size()>0 && bricks2[row][col]!=null)ices.get(i).DestroyedBrick(bricks2[row][col]);
        }
      }
    }
    if (game.GameIsOver()) {
      GameLevel1 = false;
      GameLevel2 = false;
      GameOver = true;
    }
  } else if (GameOver) {
    image(gameOver.over, 0, 0, width, height);
    gameOver.display();
    if (gameOver.GameHasRestarted()) {
      reset();
      GameLevel1 = true;
      GameLevel2 = false;
    }
  }
}

//draw the bounding line at all sides except the bottom
void drawBoundaries() {
  strokeWeight(50);
  stroke(34, 124, 111);
  line(0, 0, GameWidth-10, 0);
  line(0, 0, 0, height);
  strokeWeight(30);
  line(GameWidth, 0, GameWidth, height);
}
