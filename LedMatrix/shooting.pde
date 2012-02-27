class Line
{
  float z=0;//[0, Z)
  float speed = 0.7;
  float decay = 0.8;
  boolean visible = true;
  boolean come = true;//come and back
  void setup()
  {
    z = 0;
    come = true;
    speed = random(0.7, 1);
    decay = random(0.65, 0.8);
    visible = random(10) > 0 ? true : false;
  }
  void update()
  {
    if (come)
    {
      z += speed/2;
      if (z > target_z)//TODO:
        come = false;
    }
    else
    {
      z -= speed;
      if (z <= 0)//TODO:
      {
        setup();
      }
    }
  }
}

Line[] lines = new Line[W*H];

void shooting_setup()
{
  for (int i=0;i<W*H;i++)
  {
    lines[i] = new Line();
    lines[i].setup();
  }
}

void shooting_reset()
{
  mode = shooting;
  for (int i=0;i<W*H;i++)
    lines[i].setup();
}

void shooting()
{
  led_reset();
  int x_start = (int)map(the_x, 0, 1, 1, W-2);
  for (int x=0;x<W;x++)
  {
    for (int y=0;y<H;y++)
    {
      int idx = index(x, y);
      if (x >= x_start-1 && x <x_start+2)
        lines[idx].visible = true;
      else
        lines[idx].visible = false;

      lines[idx].update();
      if (!lines[idx].visible)
        continue;

      if (lines[idx].come)
      {
        float alpha = 255;
        for (int z=floor(lines[idx].z);z >0;z--)
        {
          alpha *= lines[idx].decay;
          if (alpha > 10)
          {
            int id = index(x, y, z);
            if (leds[id].visible)
            {
              leds[id].clr = color(196, 88, 89, alpha);
            }
          }
          else
          {
            break;
          }
        }
      }
      else//back
      {
        float alpha = 255;
        for (int z=floor(lines[idx].z);z <Z;z++)
        {
          alpha *= lines[idx].decay;
          if (alpha > 10)
          {
            int id = index(x, y, z);
            if (leds[id].visible)
            {
              leds[id].clr = color(196, 88, 89, alpha);
            }
          }   
          else
          {
            break;
          }
        }
      }
    }
  }
}

