color green_main = color(176, 255, 0);
color green_name = color(98, 116, 3);
color blue_main = color(0, 255, 255);
color blue_name = color(0, 66, 111);
color yellow = color(251, 255, 3);
color red = color(237, 121, 37);
color white = color(255, 255, 255);
final int spacing = 40;

void PImageResize(PImage in, float k)
{
  in.resize(int(in.width*k), int(in.height*k) );
}

void PImageResize(PImage in, float kx, float ky)
{
  in.resize(int(in.width*kx), int(in.height*ky) );
}

void draw_bg()
{
  background(green_main);
  fill(0);
  rect(spacing, spacing, Width-2*spacing, Height-2*spacing);
} 

int Width = 1024;
int Height = 683;

final int op = 0;
final int intro = 1;
final int countdown = 2;
final int game = 3;
final int rank = 4;
final int winner = 5;
int status = op;

float XScale = Width/1833.0;
float YScale = Height/1066.0;

PImage _loadImage(String name)
{
  PImage img = loadImage(name);
  PImageResize(img, XScale, YScale);
  return img;
}

//same scale
PImage _loadImage2(String name)
{
  PImage img = loadImage(name);
  PImageResize(img, XScale);
  return img;
}

PFont TX_191,TX_35,TX_212,TX_90,TX_66,TX_30,TX_43; 
PFont CN_30,CN_42,CN_60,CN_32,CN_46,CN_35;


void enFont(int sz)
{
  textAlign(LEFT);
  switch (sz)
  {
    case 191:
    textFont(TX_191);break;
    case 35:
    textFont(TX_35);break;
    case 212:
    textFont(TX_212);break;
    case 90:
    textFont(TX_90);break;
    case 66:
    textFont(TX_66);break;
    case 30:
    textFont(TX_30);break;
    case 43:
    textFont(TX_43);break;    
  }    
}

void cnFont(int sz)
{
  textAlign(CENTER);
  switch (sz)
  {
    case 30:
    textFont(CN_30);break;
    case 42:
    textFont(CN_42);break;
    case 60:
    textFont(CN_60);break;
    case 32:
    textFont(CN_32);break;
    case 46:
    textFont(CN_46);break;
    case 35:
    textFont(CN_35);break;
  }    
}

void setup()
{
  size(Width, Height, P2D);  

  TX_30 = createFont("TX Manifesto.ttf", 30);
  TX_35 = createFont("TX Manifesto.ttf", 35);
  TX_43 = createFont("TX Manifesto.ttf", 43);
  TX_66 = createFont("TX Manifesto.ttf", 66);
  TX_90 = createFont("TX Manifesto.ttf", 90);
  TX_191 = createFont("TX Manifesto.ttf", 191);
  TX_212 = createFont("TX Manifesto.ttf", 212);  
  
  CN_30 = createFont("FZCCHJW.TTF", 30);  
  CN_32 = createFont("FZCCHJW.TTF", 32);
  CN_35 = createFont("FZCCHJW.TTF", 35);
  CN_42 = createFont("FZCCHJW.TTF", 42);  
  CN_46 = createFont("FZCCHJW.TTF", 46);
  CN_60 = createFont("FZCCHJW.TTF", 60);

  load_images();
  //vfx
  millis_reset();
  sprites_setup();

  network_setup();
  anim_setup();

  debug_name_list_setup();
}

int millis = 0;
void millis_reset()
{
  millis = millis();
  anime_counter = 0;
  start_msg_recieved = false;
}
int ms_elapsed()//ms
{
  return millis()-millis;
}
float elapsed()//sec
{
  return ms_elapsed()*0.001;
}

int anime_counter = 0;

void op_setup()
{
  status = op;  
  millis_reset();
}

void keyPressed()
{
  if (!debug)
    return;

  if (key == 'i') intro_setup();
  else
    if (key == 't') {
      team_mode = !team_mode;
      op_setup();
    }
    else
      if (key == 'g') game_setup();
      else
        if (key == 'c') countdown_setup();
        else
          if (key == 'w') winner_setup();
          else if (key == 'r') rank_setup();
}

boolean team_info_recieved = false;
boolean people_info_recieved = false;
boolean restart_msg_recieved = false;

void draw()
{
  // if (frameCount % 30 == 0)
  //    println(frameRate);
  background(0);
  sprites_draw();
  float elapsed = elapsed();

  if (winner_msg_recieved)
  {
    winner_msg_recieved = false;
    winner_setup();
  }
  else
    if (restart_msg_recieved)
    {
      restart_msg_recieved = false;
      op_setup();
    }

  switch (status)
  {
  case op:
    {
      if (team_mode)
      {
        if (team_info_recieved)
        {
          team_info_recieved = false;
          intro_setup();
        }
        image(intro_person_1, 0, 0);
      }
      else
      {
        if (people_info_recieved)
        {
          people_info_recieved = false;
          intro_setup();
        }
        image(intro_person_1, 0, 0);
      }
    }
    break;
  case intro:
    {
      if (start_msg_recieved)//should wait for /start
      {
        start_msg_recieved = false;
        countdown_setup();
        imageMode(CORNER);
        image(bg, 0, 0);
      }
      else
      {
        if (team_mode)
        {
          intro_team_draw();
          image(intro_team, 0, 0);
        }
        else
        {
          intro_person_draw();
          image(intro_person_2, 0, 0);
        }
      }
    }
    break;
  case countdown:
    {
      if (elapsed >= 7)
      {
        game_setup();
      }
      else
      {
        countdown_draw();
      }
      imageMode(CORNER);
      image(bg, 0, 0);
    }
    break;
  case game:
    {
      if (elapsed <= 180)//3 minutes
      {
        game_draw();
      }
      else
      {
        rank_setup();
      }
      imageMode(CORNER);
      image(bg, 0, 0);
    }
    break;
  case rank:
    {
      if (elapsed <= 30)
      {
        rank_draw();
        imageMode(CORNER);
        image(rank_bg, 0, 0);
      }
      else
      {
        op_setup();
      }
    }
    break;
  case winner:
    {
      winner_draw();
      imageMode(CORNER);
      image(winner_bg, 0, 0);
    }
    break;
  default:
    break;
  }
}

