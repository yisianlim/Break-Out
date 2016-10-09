class GameOver {
  Drop[] drops = new Drop[100];
  PImage over;
  PImage restartNormal, restartHover;

  int leftButton = 500;
  int topButton = 400;
  int ButtonWidth = 300;
  int ButtonHeight = 107;

  boolean normal=true;
  boolean hover = false;

  GameOver() {
    for (int i=0; i<drops.length; i++) {
      drops[i] = new Drop();
    }
    over = loadImage("GameOverScreen.png");
    restartNormal = loadImage("RestartNormal.png");
    restartHover = loadImage("RestartHover.png");
  }

  void mouseCheck() {
    //if the mouse is in within the region of button
    if (mouseX>leftButton && mouseX<leftButton+ButtonWidth && mouseY>topButton && mouseY<topButton+ButtonHeight) {
      normal = false;
      hover = true;
    } else {
      normal = true;
      hover = false;
    }
  }
  
  boolean GameHasRestarted() {

    if (mousePressed && mouseX>leftButton && mouseX<leftButton+ButtonWidth && mouseY>topButton && mouseY<topButton+ButtonHeight) {
      return true;
    }
    return false;
  }

  void display() {
    for (int i=0; i<drops.length; i++) {
      drops[i].show();
    }
    mouseCheck();
    if (normal) image(restartNormal, leftButton, topButton, ButtonWidth, ButtonHeight);
    if (hover) image(restartHover, leftButton, topButton, ButtonWidth, ButtonHeight);
  }
}