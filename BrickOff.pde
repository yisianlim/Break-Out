Paddle paddle;
Ball ball;
ArrayList<Ice> ices;
int BrickWidth = 100;
int BrickHeight = 35;
int offset = 40;
int spacing = 5;
Brick[][] bricks; //brick array for level 1
Brick[][] bricks2; //brick array for level 2
Brick[][] bricks3; //brick array for level 3
Game game;
int GameWidth = 900;
ImageManager brickShatter;
ImageManager heart;
ImageManager ObstacleHit;
StartScreen screen;
Obstacle obstacle, obstacle2, obstacle3;
GameOver gameOver;

boolean GameLevel1;
boolean GameLevel2;
boolean GameLevel3;
boolean GameOver;

/*********************************SPECIAL BRICK GENERATOR*******************************/
//LEVEL 1
int ROW, COL, ROW1, COL1, ROW2, COL2, ROW3, COL3;
Brick iceQueenBrick, iceQueenBrick2, sizerBrick, LiveBrick;

//LEVEL2
Brick Level2IceQueenBrick1, Level2IceQueenBrick2, Level2LiveBrick, Level2sizerBrick1, Level2sizerBrick2;

//LEVEL3 
Brick Level3IceQueenBrick1, Level3IceQueenBrick2, Level3LiveBrick1, Level3LiveBrick2;
/***************************************************************************************/

void setup() {

  size(1300, 900);
  reset();
  frameRate(100);
}

void reset() {
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
  bricks3 = new Brick[11][8];
  paddle = new Paddle();
  ball = new Ball(paddle.x+paddle.PWidth/2, 730);
  game = new Game();
  brickShatter = new ImageManager("poof");
  heart = new ImageManager("heart");
  ObstacleHit = new ImageManager("obstacleHIT");
  screen = new StartScreen();
  obstacle = new Obstacle(450, 520);
  obstacle2 = new Obstacle(30, 580);
  obstacle3 = new Obstacle(800, 640);
  ices = new ArrayList<Ice>();

//setup the array of bricks for level 1
  for (int row=0; row<game.colors.length; row++) {
    for (int col=0; col<game.colors[row].length; col++) {
      if (game.colors[row][col]!=null) {
        bricks[row][col] = new Brick(game.colors[row][col], ((BrickWidth+spacing)*col)+offset, ((BrickHeight+spacing)*row)+offset);
      }
    }
  }

//setup the array of bricks for level 2
  for (int row=0; row<game.colors2.length; row++) {
    for (int col=0; col<game.colors2[row].length; col++) {
      if (game.colors2[row][col]!=null) {
        bricks2[row][col] = new Brick(game.colors2[row][col], ((BrickWidth+spacing)*col)+offset, ((BrickHeight+spacing)*row)+offset);
      }
    }
  }

//setup the array of bricks for level 3 - Halloween special!
  for (int row=0; row<game.colors3.length; row++) {
    for (int col=0; col<game.colors3[row].length; col++) {
      if (game.colors3[row][col]!=null) {
        bricks3[row][col] = new Brick(game.colors3[row][col], ((BrickWidth+spacing)*col)+offset, ((BrickHeight+spacing)*row)+offset);
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
      GameLevel3 = false;
    }
  }
//level 1 mechanism 
  if (GameLevel1 && !GameLevel2 && !GameLevel3) {

    background(38, 69, 81);
    drawBoundaries();
    paddle.draw();
    ball.draw();
    ball.check();
    ball.DidItLoseALive();
    ball.HasBallMoved();
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
      GameLevel3 = false;
      GameOver = true;
    }

    if (game.checkIfItAdvancesToLevel2()) {
      GameLevel1 = false;
      GameLevel2 = true;
      GameLevel3 = false;
      ball = new Ball(paddle.x+paddle.PWidth/2, 730);
    }
    //level 2 mechanism 
  } else if (GameLevel2) {
    background(38, 69, 81);
    drawBoundaries();
    paddle.draw();
    obstacle.draw();
    ball.draw();
    ball.check();
    ball.DidItLoseALive();
    ball.HasBallMoved();
    game.build(bricks2);
    game.scoreDisplay();
    game.DrawLives();
    game.DrawHP(obstacle.HP,600);

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

    if (game.checkIfItAdvancesToLevel3()) {
      GameLevel1 = false;
      GameLevel2 = false;
      GameLevel3 = true;
      ball = new Ball(paddle.x+paddle.PWidth/2, 730);
    }

    if (game.GameIsOver()) {
      GameLevel1 = false;
      GameLevel2 = false;
      GameLevel3 = false;
      GameOver = true;
    }
    //level 3 mechanism 
  } else if (GameLevel3) {
    background(38, 69, 81);
    drawBoundaries();
    paddle.draw();
    obstacle.draw();
    obstacle2.draw();
    obstacle3.draw();
    ball.draw();
    ball.check();
    ball.DidItLoseALive();
    ball.HasBallMoved();
    game.build(bricks3);
    game.scoreDisplay();
    game.DrawLives();
    game.DrawHP(obstacle.HP,600);
    game.DrawHP(obstacle2.HP,650);
    game.DrawHP(obstacle3.HP,700);
    
    Level3IceQueenBrick1.specialBrickMove();
    Level3IceQueenBrick2.specialBrickMove();
    Level3LiveBrick1.specialBrickMove();
    Level3LiveBrick2.specialBrickMove();

    //check if the ice destroyed the bricks 
    for (int i=0; i<ices.size(); i++) {
      if (i>=ices.size() || ices.size()<=0)break;
      ices.get(i).move();
      if (ices.size()>0) {
        if (GameLevel3){
          ices.get(i).DestroyedEnemy(obstacle);
          ices.get(i).DestroyedEnemy(obstacle2);
          ices.get(i).DestroyedEnemy(obstacle3);
        }
        ices.get(i).draw();
      }
      //check if the ice is touching any brick
      for (int row=0; row<bricks3.length; row++) {
        for (int col=0; col<bricks3[row].length; col++) {
          if (ices.size()>0 && bricks3[row][col]!=null)ices.get(i).DestroyedBrick(bricks3[row][col]);
        }
      }
    }

    if (game.GameIsOver()) {
      GameLevel1 = false;
      GameLevel2 = false;
      GameLevel3 = false;
      GameOver = true;
    }
    //game over screen
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
