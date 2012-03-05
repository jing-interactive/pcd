int[] g_lx = new int[5];
int[] g_rx = new int[5];
int ltg_x = 0;
int rtg_x = 0;

void game_setup()
{
  for (int i=0;i<5;i++)
  {
    g_lx[i] = left_gaming.width;
    g_rx[i] = right_gaming.width;
  }
  ltg_x = left_team_gaming.width;
  rtg_x = right_team_gaming.width;
}

void game_draw()
{
  fill(green_main);
  int e = int(180-elapsed());
  int min = e/60;
  int sec = e%60;
  int x0 = team_mode ? 290 : 350;
  int y0 = team_mode ? 138 : 105;
  text("00:"+nf(min, 2)+":"+nf(sec,2), x0*Scale, y0);

  if (team_mode)
    game_team_draw();
  else
    game_person_draw();
}
void game_team_draw()
{
  rectMode(CORNER);
  image(left_team_gaming, ltg_x-left_team_gaming.width, 473*Scale);
  image(right_team_gaming, width-rtg_x, 473*Scale);
}

void game_person_draw()
{
  int y0 = int(385*Scale);
  int dy = int(128*Scale);
  for (int i=0;i<5;i++)
  {
    image(left_gaming, g_lx[i]-left_gaming.width, y0+dy*i);
    image(right_gaming, width-g_rx[i], y0+dy*i);
  }
}

