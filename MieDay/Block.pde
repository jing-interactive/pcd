PImage tuntun;
PImage bell;
PImage cloud;

int world_bottom = 10000;
float camera_y = 0;//
float dead_bottom = 0;//

class Block
{
  PVector pos;//the left-top point of a rect
  float w,h; 
  boolean dying = false;

  Block(float x, float y, float w, float h)
  {
    pos = new PVector(x, y);
    this.w = w;
    this.h = h;
  }

  boolean finished()
  {
    return dying || pos.y > dead_bottom;
  }

  void draw()
  {
    if (pos.y > camera_y-w && pos.y < dead_bottom)
    {
      if (rectangle_collision(pos.x,pos.y, w, h,
      mie.pos.x, mie.pos.y, mie.w, mie.h))
      {
        hits ++;
        dying = true;
        mie.jump();
      }
      image(bell, pos.x, pos.y-camera_y);
    }
  }
}

class World
{
  ArrayList blocklist = new ArrayList();
  float safe_block_distance = 11;

  World()
  {
    
    tuntun = loadImage("tuntun.png"); 
    bell = loadImage("tuntun.png"); 
    cloud = loadImage("cloud.png"); 
   // tuntun = getImage("tuntun_png"); 
   // bell = getImage("bell_png"); 
   // cloud = getImage("cloud_png"); 
    
    reset();
  }

  void newblock()
  {
    //  blocklist.add(new Block(30,30, tuntun.width, tuntun.height));
  }

  void reset()
  {
    blocklist.clear();
    float k = world_bottom/100;
    for (int i=0;i<100;i++)
    {
      int n_times = (int)random(1,2.2);
      for (int n=0;n<n_times;n++)
      {
        float rx = random(width-30);
        float ry = k*i + random(-10,10);
        blocklist.add(
        new Block(rx, ry, tuntun.width*0.8, tuntun.height)
          );
      }
    }     
  }

  void draw()
  {
    int nBlocks = blocklist.size();
    for (int i = nBlocks-1; i >= 0; i--) 
    {
      Block block = (Block)blocklist.get(i);

      if (block.finished())
      {
        blocklist.remove(i);
        newblock();
      }
      block.draw();
    }
    image(cloud, 0, world_bottom+20-camera_y, width*1.5,cloud.height);
  }
}







