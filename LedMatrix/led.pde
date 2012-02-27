class Led
{
  color clr;
  boolean visible = true;
}

Led leds[] = new Led[TOTAL];
float[] radiuses = new float[Z];

int index(int x, int y, int z)
{
  return z*(W*H)+y*W+x;
}

int index(int x, int y)
{
  return y*W+x;
}

void led_reset()
{
  for (int i=0;i<TOTAL;i++)
    leds[i].clr = color(255, 0, 89, 5);
}

void led_setup()
{  
  for (int i=0;i<TOTAL;i++)
    leds[i] = new Led();
  int inv_array_x[] = new int[] {
    0, W-1
  };//第一列和最后一列
  int inv_array_y[][] = new int[][] {
    {
      1, 3, 5//奇数层不可见的索引
    }
    , {
      0, 2, 4//奇数层不可见的索引
    }
  };

  //设置不可见的项
  for (int z=0;z<Z;z++)
  {   
    int odd_idx = z%2;//奇数（2n)为0，偶数(2n+1)为1
    for (int x : inv_array_x)
    {
      for (int y: inv_array_y[odd_idx])
      {
        int idx = index(x, y, z);
        leds[idx].visible = false;
      }
    }
  }
}

void led_draw()
{
  for (int z=0;z<Z;z++)
  {
    for (int x=0;x<W;x++)
    {
      for (int y=0;y<H;y++)
      {
        int idx = index(x, y, z);
        if (leds[idx].visible)
        {
          pushMatrix();
          translate(x*KX, y*KY, z*KZ);
          fill(leds[idx].clr);
          box(S);
          popMatrix();
        }
      }
    }
  }
}

