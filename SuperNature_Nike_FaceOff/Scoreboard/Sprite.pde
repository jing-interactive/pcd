int index = 0;

class Sprite
{
  float x = random(spacing, Width-spacing);
  float y = random(spacing, Height-spacing);
  float vx = -random(5,10);
  float ix = 0;
  int id = index++;
  float vy = 0;
  int rotation = 0;
  int w = (int)random(80, Width*0.5);
  int h = (int)random(3, 10);
  color clr = color(random(68,200),200,0,random(200,250));

  void draw()
  {
    noStroke();
    ix = sin((frameCount+id*10)*0.03);
    ix = ix*ix*vx;
    x += ix;
    y += vy;
    if (x > width)
      x = 0;
    else if (x < -w )
      x = width;
    if (y > height)
      y = 0;
    else if (y < 0 )
      y = height;
    fill(clr);
    rect(x,y,w,h);  
  }
}

final int n_sprites = 30;
Sprite[] sprites = null;

void sprites_setup()
{
  sprites = new Sprite[n_sprites];
  for (int i=0;i<n_sprites;i++)
    sprites[i] = new Sprite();
}

void sprites_draw()
{
  for (int i=0;i<n_sprites;i++)
    sprites[i].draw();  
}
