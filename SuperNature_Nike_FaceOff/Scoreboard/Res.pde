PImage bg;

//intro
PImage intro_person_1, intro_person_2, intro_team;
PImage[] left_fly_intros = new PImage[2];
PImage[] right_fly_intros = new PImage[2];
PImage left_big_team, right_big_team, vs_fight_icon;

//count
PImage left_fly_count, right_fly_count;
PFont fontCountDown;
PImage[] six_number = new PImage[6];

//gaming
PImage left_gaming,right_gaming;

//rank
PImage banner_winner, banner_normal,rank_bg;

//winner
PImage winner_bg;

void load_images()
{
  bg = _loadImage("bg.png");
  intro_person_1 = _loadImage("intro_person_1.png");
  intro_person_2 = _loadImage("intro_person_2.png");
  intro_team = _loadImage("intro_team.png");
  left_fly_intros[0] = _loadImage("left_fly_intro.png");
  right_fly_intros[0] = _loadImage("right_fly_intro.png");
  left_fly_intros[1] = _loadImage("left_fly_intro_2.png");
  right_fly_intros[1] = _loadImage("right_fly_intro_2.png");  
  vs_fight_icon = _loadImage("vs_fight_icon.png");
  left_big_team = _loadImage("left_big_team.png");
  right_big_team = _loadImage("right_big_team.png");

  //countdown
  left_fly_count = _loadImage("left_fly_count.png");
  right_fly_count = _loadImage("right_fly_count.png");  
  for (int i=0;i<6;i++)
  {
    six_number[i] = _loadImage(i+".png");
  }
  
  //gaming
  left_gaming = _loadImage("left_gaming.png");
  right_gaming = _loadImage("right_gaming.png");  

  //rank
  banner_winner = _loadImage("banner_winner.png");
  banner_normal = _loadImage("banner_normal.png");
  rank_bg = _loadImage("rank_bg.png");
  
  //winner
  winner_bg = _loadImage("winner.png");
}

