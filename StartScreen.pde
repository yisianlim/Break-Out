class StartScreen {
  PImage main;
  boolean normal = true;
  boolean hover = false;
  PImage normalButton, hoverButton;
  
  int leftButton = 500;
  int topButton = 70;
  int ButtonWidth = 300;
  int ButtonHeight = 107;

  StartScreen() {
    main = loadImage("main.png");
    normalButton = loadImage("normal.PNG");
    hoverButton = loadImage("hover.PNG");
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

  boolean GameHasStarted() {

    if (mousePressed && mouseX>leftButton && mouseX<leftButton+ButtonWidth && mouseY>topButton && mouseY<topButton+ButtonHeight) {
      return true;
    }
    return false;
  }

  void display() {
    mouseCheck();
    image(main, 0, 0, width, height);
    if (normal) image(normalButton, leftButton, topButton, ButtonWidth, ButtonHeight);
    if (hover) image(hoverButton, leftButton, topButton, ButtonWidth, ButtonHeight);
  }
}
