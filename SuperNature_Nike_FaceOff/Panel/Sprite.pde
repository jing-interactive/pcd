final int n_sprites = 35; 
final int n_blobs = 3;

int index = 0;
final int spacing = 15;
final int[] milestones = {
  200, 400, 800, 1000, 1200, 1400,
}; 

class Sprite
{
  float x;
  float y = random(spacing, Height-spacing);
  float vx, _vx = 0;
  float ix = 0;
  int id = index++;
  float vy = 0;
  int rotation = 0;
  float h0 = random(3, 12);
  float h_k, _h_k;
  float w0 = random(2, 4);
  float w_k, _w_k;
  color clr_a, clr_b;

  PGraphics pg;

  Sprite(boolean isLeft, int start_x, int end_x)
  {
    if (isLeft)
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
    x = random(start_x, end_x);
  }

  void update(int spd, int m)
  {
    if (spd < 2) spd = 2;
    float k = spd/10.0f;
    k *= k;
    _vx = k*100;
    _h_k = spd*14;
    _w_k = k*spacing*0.8;
  }

  void go_zero()
  {
    vx = _vx = 0;
    w_k = _w_k = 0;
    h_k = _h_k = 0;
  }

  void draw()
  {
    //    h_k = lerp(h_k, _h_k, 0.1);
    //   vx = lerp(vx, _vx, 0.1);
    //  w_k = lerp(w_k, _w_k, 0.1);
    vx = max(vx, 1);
    // h_k = max(h_k, 3);
    float w = w0* w_k;
    float idx = (frameCount+id*10)*0.05;
    ix = sin(idx);    
    ix = ix*ix;
    if (ix < 0.1) ix *= 2;
    ix *=vx;
    // x += ix;
    y -= ix;
    if (y < 0)
    {
      y = height+h_k*2;
      h_k = _h_k;
      w_k = _w_k;
      vx = _vx;
    }
    strokeWeight(w);
    beginShape(LINES);
    stroke(clr_a);
    vertex(x, y-h_k*0.25);
    stroke(clr_b);
    vertex(x, y-h_k*0.95);    
    endShape();

    strokeWeight(w*0.75);
    beginShape(LINES);
    stroke(clr_a);
    vertex(x, y);
    stroke(clr_b);
    vertex(x, y-h_k+2);    
    endShape();   

    strokeWeight(w/4);
    beginShape(LINES);
    stroke(clr_a);
    vertex(x, y); 
    stroke(clr_b);
    vertex(x, y-h_k+4);  
    endShape();
  }
}

class OnePanel
{
  color clr;

  int speed = 0;
  int miles = 0;
  int idx;
  Sprite[] sprites = new Sprite[n_sprites];
  int vfx_millis;
  boolean vfx_mode = false;

  PGraphics pg1;
  int[][] vy, vx; 
  float[] blogPx = new float[n_blobs];
  float[] blogPy = new float[n_blobs];

  String vfx_text="";

  OnePanel(int id)
  {
    idx = id;
    boolean isLeft = idx < 5;
    for (int i=0;i<n_sprites;i++)
      sprites[i] = new Sprite(isLeft, OneW*idx+spacing, OneW*(idx+1)-spacing);
    pg1 = createGraphics(60, 30, P2D);
    pg1.textFont(font);
    if (isLeft)
    {
      int r = 0, g=(int)random(68, 200), b=200;
      clr = color(r, g, b, 200);
    }
    else  
    {
      int b = 0, r=(int)random(68, 200), g=200;
      clr = color(r, g, b, 200);
    }

    vy = new int[n_blobs][OneH/4];
    vx = new int[n_blobs][OneW/4];

    for (int i=0;i<n_blobs;i++)
    {
      blogPx[i] = OneW/8;
      blogPy[i] = OneH/8;
    }
  }

  void reset()
  {
    speed = 0;
    miles = 0;
  }

  void launch_vfx(int vid)
  {
    println(idx+"达到了"+milestones[vid]);
    vfx_mode = true;
    vfx_millis = millis();
    vfx_text = milestones[vid]+"M";
  }

  void update(int spd, int m)
  {
    for (int i=0;i<4;i++)
    {
      if (m < milestones[i]) 
        break;
      if (miles < milestones[i])
      {
        launch_vfx(i);
        break;
      }
    }
    for (int i=0;i<n_sprites;i++)
      sprites[i].update(spd, m); 
    speed = spd;
    miles = m;
  }

  void pg2_update()
  {
    for (int i=0; i<n_blobs; ++i) 
    {
      for (int x = 0; x < OneW/4; x++) {
        vx[i][x] = int(sq(blogPx[i]-x));
      }
      for (int y = 0; y < OneH/4; y++) {
        vy[i][y] = int(sq(blogPy[i]-y));
      }
    }
    for (int y = 0; y < OneH/4; y++) {
      for (int x = 0; x < OneW/4; x++) {
        int m = 1;
        for (int i = 0; i < n_blobs; i++) {
          // Increase this number to make your blobs bigger
          m += 6000/(vy[i][y] + vx[i][x]+1);
        }
     //   tex1.pixels[OneW/4*idx+x+y*pg2.width] = color(0, m, m/2,100);
      }
    }
  }
  void draw()
  {
    if (vfx_mode)
    {
      if (millis - vfx_millis > 3000)
      {
        vfx_mode = false;
      }
      else
      {
        pg1.beginDraw();
        pg1.background(0, 122);
        pg1.fill(255, 255, 255, 255);
        pg1.text(vfx_text, 0, 20);
        pg1.endDraw();
        image(pg1, 15+OneW*idx, 160, pg1.width*2, pg1.height*2);
      }
    }
    //draw lines
    for (int i=0;i<n_sprites;i++)
    {
      if (debug)
      {
        strokeWeight(1);
        stroke(255);
        noFill();
        rectMode(CORNER);
        rect(OneW*i, 0, OneW, OneH);
      }
      sprites[i].draw();
    }
  }
}

