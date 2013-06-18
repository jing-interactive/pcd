AniSequence intro_left_seq, intro_right_seq;
AniSequence intro_team_seq;

int lx_0, lx_1, lx_2, lx_3, lx_4;
int rx_0, rx_1, rx_2, rx_3, rx_4;

int team_x, team_y;
int[] lx = new int[5];
int[] rx = new int[5];

final int w2 = Width/2;
final int h2 = Height/2;


void intro_setup()
{
  lx_0 = lx_1 = lx_2 = lx_3 = lx_4 = 0; 
  rx_0 = rx_1 = rx_2 = rx_3 = rx_4 = 0;

  team_x = team_y = 0;
  millis_reset();
  status = intro;

  if (team_mode)
    intro_team_seq.start();          
  else
  {
    intro_left_seq.start();
    intro_right_seq.start();
  }
} 

void intro_team_draw() 
{ 
  rectMode(CORNER);
  image(left_big_team, team_x-left_big_team.width, 529*YScale);
  image(right_big_team, width-team_y, 529*YScale);

  cnFont(46);
  fill(blue_name);
  text(name_list[0], team_x-left_big_team.width+203, 434);
  fill(green_name);
  text(name_list[1], right_big_team.width-team_y+434+400, 434);
}

void intro_person_draw()
{ 
  int y0 = int(350*XScale);
  int dy = int(134*YScale);
  rectMode(CORNER);  

  lx[0] = lx_0;
  lx[1] = lx_1;
  lx[2] = lx_2;
  lx[3] = lx_3;
  lx[4] = lx_4;
  rx[0] = rx_0;
  rx[1] = rx_1;
  rx[2] = rx_2;
  rx[3] = rx_3;
  rx[4] = rx_4;
  int adx = 120;
  int ady = 42;  
  for (int i=0;i<5;i++)
  {
    image(left_fly_intros[i%2], lx[i]-left_fly_intros[i%2].width+10, y0+dy*i);
  } 
  cnFont(35);
  fill(blue_name);
  for (int i=0;i<5;i++)
  {
    text(name_list[i], lx[i]-left_fly_intros[i%2].width+266, y0+dy*i+ady);
  } 
  for (int i=0;i<5;i++)
  { 
    image(right_fly_intros[i%2], width-rx[i]-10, y0+dy*i);
  }
  fill(green_name);
  for (int i=0;i<5;i++)
  {
    text(name_list[5+i], right_fly_intros[i%2].width-rx[i]+273+500, y0+dy*i+ady);
  }
}

