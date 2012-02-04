final int sphere_solid = 1;
final int sphere_wireframe = 2;
final int cross_solid = 3;
final int cross_wireframe = 4;
final int diamond_solid = 5;
final int diamond_wireframe = 6;

int mode = sphere_solid;

void fsm()
{
  if (keyPressed)
  {
    int k = key -'0';
    if (k >=sphere_solid && k<=diamond_wireframe)
      mode = k;
  }

  wave_mode();
}

float satisfy_me(PVector center, PVector pos)
{
  PVector delta = PVector.sub(pos, center);
  if (delta.z < 0)
    return -1;
  
  delta.z /= 2;
  boolean sat = false;//是否满足要求
  float k = -1;
  float dz = 4;
  float r = delta.mag();

  switch (mode)
  {
  case  sphere_solid:
    {
      sat = r < 4;
    }
    break;
  case  sphere_wireframe:
    {     
      sat = r < 4 && r>3;
    }
    break;
  case  cross_solid:
    {
       dz = 2;
      sat = delta.z <= dz && (abs(delta.x) <=1 || abs(delta.y) <=1);
    }
    break;
  case  cross_wireframe:
    {
      dz = 4;
      sat =  delta.z <= dz && (abs(delta.x) <=1 || abs(delta.y) <=1);
    }
    break;
  case  diamond_solid:
    {
      dz = 2;
      int x = int(pos.x);
      int y = int(pos.y);
      sat = delta.z <= dz && (x == 0 || x == W-1 || x == 3 || x == 4 || y == 0 || y == H-1 || y == 3);
    }
    break;
  case  diamond_wireframe:
    {
      dz = 4;
      sat = delta.z <= dz && (int(pos.x) == 0 || int(pos.x) == W-1 ||int(pos.y) == 0 || int(pos.y) == H-1);
    }
    break;
  default:
    break;
  }
  if (sat)
    k = map(abs(delta.z), 0, dz, 0, 250);
  return k;
}

