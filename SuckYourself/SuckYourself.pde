final int W = 800;
final int H = 600;

void setup()
{
  size(W, H,P2D);
  image_setup();
  imageMode(CENTER);
  menu_setup();
}

int millis = 0;
int lastMillis = 0;
void setTimer()
{
  lastMillis = millis();
}
int getElasped()
{
  return millis() - lastMillis;
}

void draw()
{ 
  background(155);
  image(bg,width/2,height/2);
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

