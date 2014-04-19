import de.looksgood.ani.*;

void setup()
{
  size(displayWidth, displayHeight, P2D);
  Ani.init(this);
  
  setupImages();
  setupCamera();
  setupShader();
  setupGUI();
  
  changeState(new ReadyCountdownState());
}

void draw()
{
  background(0);
  drawState();
}

