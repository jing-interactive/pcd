color randomColor(int x, int y, int z)
{ 
  int c = int(MAX_INT*noise(x*0.1+y*0.01+z*0.001));
  return c;
}

//float smooth[][] = new float[W][H];
float target_z = Z;
float curr_z = 0;
float the_x = 0.45;
float the_y = 0.45;
float target_x = 0.45;
float target_y = 0.45;

float millisLastKinectData = 0;//to turn to idle mode
final float millisLostConnection = 5000;//5 seconds without kinect data turn app to idle mode

void wave_setup()
{
  for (int z=0;z<Z;z++)
    radiuses[z] = 0;

  target_z = Z*2;
  curr_z = 0;
  the_x = 0.45;
  the_y = 0.45;
  target_x = 0.45;
  target_y = 0.45;
  millisLastKinectData = 0;
}

void wave()
{
  PVector center = new PVector(W*the_x, H*the_y, curr_z);
  PVector pos = new PVector(); 
  for (int z=0;z<Z;z++)
  {
    // int floor_radius = floor(radiuses[z])+1;
    for (int x=0;x<W;x++)
    {
      for (int y=0;y<H;y++)
      {
        pos.set(x, y, z);        
        //         int lo = floor(r);
        //        int hi = ceil(r);
        int idx = index(x, y, z);

        float k = satisfy_me(center, pos);
        if (k > 0)
        {
          leds[idx].clr = color(196, 88, 89, k);
        }
      }
    }
  }
}

void led_blur()
{
  //blur
  for (int z=0;z<Z;z++)
    for (int x=1;x<W-1;x++)
      for (int y=1;y<H-1;y++)
      {
        int idx0 = index(x, y, z);
        int idx1 = index(x+1, y, z);
        int idx2 = index(x-1, y, z);
        int idx3 = index(x, y-1, z); 
        int idx4 = index(x, y+1, z);
        int a0 = (leds[idx0].clr >> 24) & 0xFF;
        int a1 = (leds[idx1].clr >> 24) & 0xFF;
        int a2 = (leds[idx2].clr >> 24) & 0xFF;
        int a3 = (leds[idx3].clr >> 24) & 0xFF;
        int a4 = (leds[idx4].clr >> 24) & 0xFF;
        //        leds[idx0].clr = (leds[idx0].clr & 0x00FFFFFF) | ((a0+a1+a2+a3+a4)/5) << 24;
      }
}

