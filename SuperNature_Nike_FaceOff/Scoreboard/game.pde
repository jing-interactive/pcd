int[] g_lx = new int[5];
int[] g_rx = new int[5];
int ltg_x = 0;
int rtg_x = 0;
float[] rel_speed_list = new float[10];
float[] _rel_speed_list = new float[10];

String to_km(float k)
{
  return nf(k*0.001, 1, 3) + "KM";
}
void game_setup()
{
  for (int i=0;i<5;i++)
  {
    g_lx[i] = left_gaming.width;
    g_rx[i] = right_gaming.width;
  }
  ltg_x = left_big_team.width;
  rtg_x = right_big_team.width;
  max_speed = 1;
  for (int i=0;i<10;i++)
  {
    speed_list[i] = 0;
    miles_list[i] = 0;
    rel_speed_list[i] = 0;
    _rel_speed_list[i] = 0;
  }
  millis_reset();
  status = game;
}

void game_draw()
{
  fill(green_main);
  int e = int(180-elapsed());
  int min = e/60;
  int sec = e%60;
  int mil = ms_elapsed() - (int)elapsed()*1000;
  mil = mil/10;
  println(mil);
  int x0 = team_mode ? 150 : 184;
  int y0 = team_mode ? 244 : 208;
  if (team_mode)
    textFont(TX_212);
  else
    textFont(TX_191);
  text(nf(min, 2)+":"+nf(sec, 2)+":"+nf(mil, 2), x0, y0);

  if (team_mode)
    game_team_draw();
  else
    game_person_draw();
}

void game_team_draw()
{
  //miles
  int left_team_total = 0;
  int right_team_total = 0;
  for (int i=0;i<5;i++)
  {
    left_team_total += miles_list[i];
    right_team_total += miles_list[5+i];
  }
  //speed
  int left_team_total2 = 0;
  int right_team_total2 = 0;
  for (int i=0;i<5;i++)
  {
    left_team_total2 += speed_list[i];
    right_team_total2 += speed_list[5+i];
  } 
  if (left_team_total2 > right_team_total2)
  {
    _rel_speed_list[0] = 1.0;
    _rel_speed_list[1] = 0.4;
  }
  else
  {
    _rel_speed_list[0] = 0.4;
    _rel_speed_list[1] = 1.0;
  }
  rel_speed_list[0] = lerp(rel_speed_list[0], _rel_speed_list[0], 0.05);
  rel_speed_list[1] = lerp(rel_speed_list[1], _rel_speed_list[1], 0.05);

  {//power bar
    fill(blue_main);
    int power = int(rel_speed_list[0]*6);
    for (int j=0;j<power;j++)
      rect(784*XScale-20, 918*YScale-22*j, 80, 14);

    fill(green_main);
    power = int(rel_speed_list[1]*6);
    for (int j=0;j<power;j++)
      rect(926*XScale, 918*YScale-22*j, 80, 14);
  }

  {//name & miles
    image(left_big_team, ltg_x-left_big_team.width, 463*YScale);
    image(right_big_team, width-rtg_x, 463*YScale);

    cnFont(42);
    fill(blue_name);
    text(name_list[0], 219, 390);
    fill(green_name); 
    text(name_list[1], 806, 390);

    enFont(90);
    fill(blue_main);
    text(to_km(left_team_total), 81, 601);
    fill(green_main);
    text(to_km(right_team_total), 646, 601);
  }
}

void game_person_draw()
{
  for (int i=0;i<10;i++)
  {
    rel_speed_list[i] = lerp(rel_speed_list[i], _rel_speed_list[i], 0.05);
  }
  for (int i=0;i<5;i++)
  {
    if (rel_speed_list[i] > rel_speed_list[5+i])
    {
      rel_speed_list[i] += 0.1;
      rel_speed_list[5+i] -= 0.1;
    }
    else {
      rel_speed_list[i] -= 0.1;
      rel_speed_list[5+i] += 0.1;
    }
    rel_speed_list[i] = constrain(rel_speed_list[i], 0.2, 1);
    rel_speed_list[5+i] = constrain(_rel_speed_list[5+i], 0.2, 1);
  }
  int y0 = int(385*YScale);
  int dy = int(128*YScale); 
  for (int i=0;i<5;i++)
  {
    image(left_gaming, g_lx[i]-left_gaming.width, y0+dy*i);
    image(right_gaming, width-g_rx[i], y0+dy*i);
  }
  int adx = 60, ady = 40;
  int bdx = adx + 140;

  {//power bar
    y0 = int(474*YScale);
    rectMode(CORNER);
    fill(blue_main);  
    for (int i=0;i<5;i++)
    {
      int power = int(rel_speed_list[i]*5);
      for (int j=0;j<power;j++)
      {
        rect(784*XScale, y0+dy*i-7*j, 60, 6);
      }
    }
    fill(green_main);
    for (int i=0;i<5;i++)
    {
      int power = int(rel_speed_list[i+1]*5);
      for (int j=0;j<power;j++)
      {
        rect(922*XScale, y0+dy*i-7*j, 60, 6);
      }
    }
  }
  {//name & miles
    fill(blue_name);
    cnFont(30);
    for (int i=0;i<5;i++)
      text(name_list[i], 159, 290+dy*i);
    fill(green_name);
    for (int i=0;i<5;i++)
      text(name_list[5+i], 722, 290+dy*i);

    enFont(35);
    fill(blue_name);
    for (int i=0;i<5;i++)
      text(to_km(miles_list[i]), 236, 290+dy*i);
    fill(green_name);
    for (int i=0;i<5;i++)
      text(to_km(miles_list[5+i]), 798, 290+dy*i);
  }
}

