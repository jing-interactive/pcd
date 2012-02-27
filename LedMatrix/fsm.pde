final int sphere_solid = 1;
final int sphere_wireframe = 2;
final int cross_solid = 3;
final int cross_wireframe = 4;
final int diamond_solid = 5;
final int diamond_wireframe = 6;
final int spark = 7;
final int shooting = 8;//流星

int mode = shooting;

void fsm()
{
  if (keyPressed)
  {
    int k = key -'0';
    switch (k)
    {
    case sphere_solid:
    case sphere_wireframe:
    case cross_solid:
    case cross_wireframe:
    case diamond_solid:
    case diamond_wireframe:
      {
        mode = k;
        wave_setup();
        break;
      }
    case spark:
      {  
        spark_reset();
        break;
      }
    case shooting:
      {
        shooting_reset();
        break;
      }
    default:
      break;
    }
  }
  led_reset();

  kinect_draw();

  if (mode <spark)
  {
  //  millisLastKinectData = millis;
    wave();
  }
  else if (mode == spark)
  {
    spark();
  }
  else
  {
    shooting();
  }
}

final float ddd = 3;

float satisfy_me(PVector center, PVector pos)
{
  PVector delta = PVector.sub(pos, center);
  if (delta.z < 0)
    return -1;

  delta.z *= 0.3;
  boolean sat = false;//是否满足要求
  float k = -1;
  float dz = 4;
  float r = delta.mag();

  switch (mode)
  {
  case  sphere_solid:
    {
      sat = r < ddd;
    }
    break;
  case  sphere_wireframe:
    {     
      sat = r < ddd && r>ddd-1;
    }
    break;
  case  cross_solid:
    {
      dz = ddd/2;
      sat = delta.z <= dz && (abs(delta.x) <=1 || abs(delta.y) <=1);
    }
    break;
  case  cross_wireframe:
    {
      dz = ddd;
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

