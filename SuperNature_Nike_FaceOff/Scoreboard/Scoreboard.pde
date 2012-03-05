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

int Width = 916;
int Height = 533;

PFont C1, C2;
PFont E1;

final int intro_1 = 0;
final int intro_2 = 1;
final int countdown = 2;
final int game = 3;
final int rank = 4;
final int winner = 5;
int status = intro_1;

float Scale = 0.5;

PImage _loadImage(String name)
{
  PImage img = loadImage(name);
  PImageResize(img, Scale);
  return img;
}
void setup()
{
  size(Width, Height);  

  // C1 = createFont("FZDHTJW.TTF", 40);
  PFont C1 = createFont("Arial", 100);
  textFont(C1);
  load_images();
  //vfx
  millis_reset();
  sprites_setup();

  network_setup();
  anim_setup();
}

void keyReleased()
{
}

int millis = 0;
void millis_reset()
{
  millis = millis();
  anime_counter = 0;
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

void keyPressed()
{
  status = intro_1;
  millis_reset();
  
  team_mode = !team_mode;
}

void draw()
{
  background(0);
  sprites_draw();
  float elapsed = elapsed();

  switch (status)
  {
  case intro_1:
    {
      if (team_mode)
      {
        if (elapsed >= 1)
        {
          intro_team_seq.start();
          status = intro_2; 
          millis_reset();
          intro_setup();
        }
        image(intro_team, 0, 0);
      }
      else
      {
        if (elapsed >= 3)
        {
          status = intro_2;
          millis_reset();
          intro_setup();
          intro_left_seq.start();
          intro_right_seq.start();
        }
        image(intro_person_1, 0, 0);
      }
    }
    break;
  case intro_2:
    {
      if (elapsed >= 5)//should wait for /start
      {          
        status = countdown;
        countdown_setup();
        countdown_seq.start();
        millis_reset();
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
        status = game;
        game_setup();
        //countdown_seq.start();
        millis_reset();
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
        status = rank;
        //ranking_setup();
        //ranking_seq.start();
        millis_reset();
      }
      imageMode(CORNER);
      image(bg, 0, 0);
    }
    break;
  default:
    break;
  }
}
