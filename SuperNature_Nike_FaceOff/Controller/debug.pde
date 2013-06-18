boolean debug = false;
boolean using_sim = false;

void sim_start()
{
  for (int i=0;i<10;i++)
  {
    speed[i] = 0;
    miles[i] = 0;
  }
}

void sim_end()
{
}

int idx = 0;

void sim_draw()
{
  for (int i=0;i<10;i++) 
  {
    speed[i] = random(2, 4); 
  } 
  for (int i=0;i<10;i++)
    miles[i] += speed[i];
  println(speed);
  int i = (idx++)%9;
  the_str = i+" "+speed[i]+" "+(int)miles[i];
}

