class Particle
{
  Particle(float x, float y, float vx, float vy, int life) {
    _x = x;
    _y = y;
    _vx = vx;
    _vy= vy;
    _life = life;
  } 
  void draw()
  {
    _x += _vx;
    _y += _vy;
    if (_x > width || _x < 0 || _y > height || _y < 0)
      _life = -1;
  }
  float _x=0, _y=0;
  float _vx=0, _vy=0;
  int _life = 1;
}

class ParticleSystem
{
  ArrayList<Particle> list = new ArrayList<Particle>();
  PImage img = null;
  ParticleSystem(PImage image)
  {
    img = image;
  }
  void add(float x, float y, float vx, float vy, int life)
  {
    list.add(new Particle(x, y, vx, vy, life));
  }
  void draw()
  {
    for (int i = list.size()-1; i >= 0; i--) {
      Particle p = list.get(i);
      p.draw();
      if (p._life <= 0)
        list.remove(i);
      else
        image(img, p._x, p._y);
    }
  }
}

