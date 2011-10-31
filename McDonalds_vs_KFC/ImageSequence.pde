class ImageSequence
{
  int _x = 0;
  int _y = 0;
  boolean run = false;
  boolean onetime = false;
  ImageSequence(float speed) {
    spd = speed;
  }
  void set(boolean b) {
    run = b;
  }
  ArrayList<PImage> list = new ArrayList<PImage>();
  void add(PImage img) { 
    list.add(img);
  }

  void setPos(int x, int y) {
    _x = x;
    _y = y;
  }
  void setPos(float x, float y) {
    _x = int(x);
    _y = int(y);
  }

  float counter = 0;
  float spd = 0;
  void draw(int x, int y)
  {
    setPos(x, y);
    draw();
  }
  void draw()
  {
    if (run)
    {
      imageMode(CENTER);
      int n_list = list.size();
      counter += spd;
      if (counter > n_list)
      {
        counter = 0;
        if (onetime)
        {
          run = false;
          return;
        }
      }
      image(list.get(int(counter)), _x, _y);
    }
  }
}

