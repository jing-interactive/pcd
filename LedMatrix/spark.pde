class Spark
{
  float life, speed;
  int idx;
  void setup()
  {
    idx = (int)random(TOTAL);
    life = random(2);
    speed = random(0.04, 0.1);
  }
  void draw()
  {
    life += speed;
    float k = sin(life);
    if (k < 0)
      setup();
    else
    {
      k = map(k, 0, 1, 0, 250);
      leds[idx].clr = color(196, 88, 89, k);
    }
  }
}

final int n_sparks = 30;
Spark[] sparks = new Spark[n_sparks];

void spark_setup()
{
  for (int i=0;i<n_sparks;i++)
  {
    sparks[i] = new Spark();
    sparks[i].setup();
  }
}

void spark()
{
  for (Spark s:sparks)
    s.draw();
}
