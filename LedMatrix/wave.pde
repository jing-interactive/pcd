void wave_setup()
{
//  mode = wave_mode;
  for (int z=0;z<Z;z++)
    radiuses[z] = 0;
}

float target_z = 5;
float curr_z = 0;

color randomColor(int x, int y, int z)
{ 
  int c = int(MAX_INT*noise(x*0.1+y*0.01+z*0.001));
  return c;
}

//float smooth[][] = new float[W][H];

void wave_mode()
{
  curr_z += 0.7;
  if (curr_z > Z-1 ) curr_z = -5;
  else if (curr_z < -6 ) curr_z = Z-1;
  //    target_z = random(Z);
  // curr_z = lerp(curr_z, target_z, 0.02);
  //    radiuses[0] = abs(4.3*sin(frameCount*0.05));
  // radiuses[(int)curr_z] = abs(4.3*sin(frameCount*0.05));

  //  for (int z=1;z<Z;z++)
  //  {
  //    radiuses[z] =  lerp(radiuses[z], radiuses[z-1], 0.9);
  //  }
  //  for (int z=0;z<Z;z++)
  //  {
  //    radiuses[z] *= 0.98;
  //  }
  PVector center = new PVector(W*0.45, H*0.45, curr_z);
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
        else
        {
          leds[idx].clr = color(255, 0, 100, 5);
        }
      }
    }

    if (false)
    {
      //blur
      for (int x=1;x<W-1;x++)
      {
        for (int y=1;y<H-1;y++)
        {
          int idx0 = index(x, y, z);
          int idx1 = index(x+1, y, z);
          int idx2 = index(x-1, y, z);
          int idx3 = index(x, y-1, z); 
          int idx4 = index(x, y+1, z);
          leds[idx0].clr = (leds[idx1].clr + leds[idx2].clr + leds[idx3].clr + leds[idx4].clr + leds[idx0].clr)/5;
        }
      }
    }
  } 
  ;
}

