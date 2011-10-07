PVector gravity = new PVector(0, 0.98);

class Mie
{
  ArrayList jumplist = new ArrayList();
  ArrayList falllist = new ArrayList();  
  ArrayList duduList = new ArrayList();  
  ArrayList currentList = duduList;
  int counter = 0;
  int counter2 = 0;
  float spd_x = 5;
  float spd_y = -16;
  PVector pos = new PVector();
  PVector vel = new PVector();

  float w, h;

  boolean dangerous = false;//in the beginning, it's safe to fall

  Mie()
  {
    PImage jump = loadImage("jump.png");
    PImage fall = loadImage("fall.png");
    PImage inter = loadImage("inter.png");
    PImage dudu = loadImage("dudu.png");   
    /*
    PImage jump = getImage(jump_png);
     PImage fall = getImage(fall_png);
     PImage inter = getImage(inter_png);
     PImage dudu = getImage(dudu_png);
     */

    w = jump.width*0.85;
    h = jump.height*0.85;
    jumplist.add(jump);
    jumplist.add(inter); 

    falllist.add(fall);
    falllist.add(fall);

    duduList.add(dudu);
    duduList.add(inter);

    pos.set(width/2, world_bottom, 0);
    camera_y = pos.y - height/2;
    dead_bottom = pos.y + height;
  }

  void jump()
  {
    vel.y = spd_y;
  }

  void reset()
  {
    dangerous = false;
    total_height = 0;
    score = 0;     
    hits = 0;
  }

  void draw()
  {
    float acc_x = map(acc_values[0], 3, -3, 0, screenWidth);
    pos.x += (acc_x - pos.x)*0.15;

    float d = world_bottom - pos.y;
    if (score < d)
    {
      score = (int)d;
      total_height = score;
    }

    vel.add(gravity);
    pos.add(vel);

    if (pos.y > world_bottom)
    {
      jump();
      if (dangerous)
      {
        world.reset();
        reset();
      }
    }

    if (!dangerous && hits > 0/*pos.y < world_bottom - height*/)
    {
      dangerous = true;
    }

    if (vel.y < 0)
      currentList = jumplist;
    else
      currentList = falllist;

    if (pos.x> width)
      pos.x = -w;
    if (pos.x + w < 0)
      pos.x = width;

    camera_y = pos.y - height/2;
    dead_bottom = pos.y + height;    

    PImage img = (PImage)currentList.get(counter);
    image(img, pos.x, height/2);
    counter2++;
    if (counter2 > 8)
    {
      counter2 = 0;
      counter++;
      if (counter > currentList.size()-1)
        counter = 0;
    }
  }
}
