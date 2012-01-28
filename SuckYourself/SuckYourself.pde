final int W = 800;
final int H = 600;

void setup()
{
  size(W, H, P2D);
  image_setup();
  minim_setup();

  imageMode(CENTER);
  PFont font = loadFont("MicrosoftTaiLe-Bold-32.vlw");
  textFont(font);
  
  menu_setup();
}

void draw()
{ 
  println(mouseX+","+mouseY);
  background(155);
  if (bg != null)
    image(bg, width/2, height/2);
    
  millis = millis();
  switch (state)
  {
  case menu:
    {
      menu();
    }
    break;
  case way0:
    {
      way0();
    }
    break;
  case way1:
    {
      way1();
    }
    break;
  case win:
    {
      win();
    }
    break;
  case lose:
    {
      lose();
    }
    break;
  default:
    break;
  }
}


int millis = 0;
int lastMillis = 0;

void setTimer()
{
  lastMillis = millis();
}

int getElapsed()
{
  return millis() - lastMillis;
}

boolean isPointInside(float px, float py, float x1, float y1, float x2, float y2)
{
  return px > x1 && px<x2 && py > y1 && py < y2;
}

boolean isMouseInside(float x1, float y1, float x2, float y2)
{
  return isPointInside(mouseX, mouseY, x1, y1, x2, y2);
}

boolean isMouseInside(float x1, float y1, float r)
{
  return dist( mouseX, mouseY, x1, y1) < r;
}

