int index = 0;

class Sprite
{
  float x = random(spacing, Width-spacing);
  float y = random(spacing, Height-spacing);
  float vx = -random(10, 20);
  float ix = 0;
  int id = index++;
  float vy = 0;
  int rotation = 0;
  int w, h; 
  color clr_a, clr_b;
  boolean sin_mode = false;

  Sprite()
  {
    setup();
  }

  void setup()
  {
    if (random(5) > 3)
      sin_mode = true;
    else
      sin_mode = false;
    w = (int)random(80, Width*0.5);
    h = (int)random(5, 10);    
    if (random(1) > 0.5)
    {
      int r = 0, g=(int)random(68, 200), b=200;
      clr_a = color(r, g, b, 0);
      clr_b = color(r, g, b, 222);
      //  clr = color(0, random(68, 200), 200, random(200, 250));
    }
    else  
    {
      int b = 0, r=(int)random(100, 200), g=244;
      clr_a = color(r, g, b, 0);
      clr_b = color(r, g, b, 222);      
      //clr = color(random(68, 200), 200, 0, random(200, 250));
    }
  }

  void draw()
  {
    if (sin_mode)
    {
      ix = sin((frameCount+id*10)*0.03);
      ix = ix*ix*vx;
    }
    else
    {
      ix = vx;
    }
    x += ix;
    y += vy;
    if (x > width)
      x = 0;
    else if (x < -w )
    {
      setup();
      x = width;
    }
    if (y > height)
      y = 0;
    else if (y < 0 )
      y = height;

    strokeWeight(h);
    beginShape(LINES);
    stroke(clr_b);
    vertex(x, y);
    stroke(clr_a);
    vertex(x+w, y);    
    endShape();
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

