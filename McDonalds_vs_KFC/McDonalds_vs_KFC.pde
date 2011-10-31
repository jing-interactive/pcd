boolean debug = false;

TileMap blood, fire;
PImage bg, head_angry, head_normal, m_body;
PImage head_angry_x, head_normal_x;
ImageSequence blood_seq, fire_seq, uncle_m_run, uncle_m_super;
PImage m1, m2, m3;
PImage chick, chick_die, coke, pepsi, m_logo, kfc_logo;
ParticleSystem bullets, qiqi, qiqi_die, pepsis;
PImage[] body_icon = new PImage[3];
PImage[] head_icon = new PImage[3];

int Width = 800;
int Height = 600;

void PImageResize(PImage in, float k)
{
  in.resize(int(in.width*k), int(in.height*k) );
}

void PImageResize(PImage in, float kx, float ky)
{
  in.resize(int(in.width*kx), int(in.height*ky) );
}

void setup()
{
  blood = new TileMap("blood.png", 4, 2, 1, 1);
  fire = new TileMap("fire.png", 6, 3, 1.2, 1);
  bg = loadImage("bg.png");
  head_normal = loadImage("v_1.png");
  head_angry = loadImage("v_2.png");
  PImageResize(head_normal, 0.25);
  PImageResize(head_angry, 0.25);  
  m_body = loadImage("m_body.png");
  PImage bullet = loadImage("bullet.png");
  PImageResize(bullet, 0.1);
  chick = loadImage("chick_2.png");
  PImageResize(chick, 0.2);
  chick_die = loadImage("chick_die.png");
  PImageResize(chick_die, 0.2);
  m_logo = loadImage("m_logo.png");
  PImageResize(m_logo, 0.5);
  kfc_logo = loadImage("kfc.png");
  PImageResize(kfc_logo, 0.15);

  coke = loadImage("coke.png");
  PImageResize(coke, 0.5);
  pepsi = loadImage("pepsi.png");
  PImageResize(pepsi, 0.4);

  for (int i=0;i<3;i++)
  {
    head_icon[i] = loadImage("head_"+(i+1)+".png");
    PImageResize(head_icon[i], 0.8);
    body_icon[i] = loadImage("body_"+(i+1)+".png");
    PImageResize(body_icon[i], 0.8);
  }

  bullets = new ParticleSystem(bullet);
  qiqi = new ParticleSystem(chick);
  qiqi_die = new ParticleSystem(chick_die);
  pepsis = new ParticleSystem(pepsi);

  //seq
  blood_seq = new ImageSequence(0.15);
  for (int i=0;i<4;i++)
    blood_seq.add(blood.get(i, 1));
  fire_seq = new ImageSequence(0.20);
  for (int j=0;j<3;j++)
    for (int i=0;i<6;i+=3)
      fire_seq.add(fire.get(i, j));

  //uncle M
  m1 = loadImage("m_1.png"); 
  PImageResize(m1, 0.25);
  m3 = loadImage("m_3.png");
  PImageResize(m3, 0.25);
  uncle_m_run = new ImageSequence(0.10);
  uncle_m_run.run = true;
  uncle_m_run.add(m1);
  uncle_m_run.add(m3);
  //uncle m super
  m1 = loadImage("m_x_1.png"); 
  PImageResize(m1, 0.25);
  m3 = loadImage("m_x_3.png");
  PImageResize(m3, 0.25);
  uncle_m_super = new ImageSequence(0.10);
  uncle_m_super.run = true;
  uncle_m_super.add(m1);
  uncle_m_super.add(m3);

  minim_setup();
 // movie_setup();

  //PFont font = createFont("宋体",32);
  PFont font = loadFont("FZYTK--GBK1-0-32.vlw");
  textFont(font);
  ellipseMode(CENTER);
  //  rectMode(CENTER);
  noCursor();
  noFill();
  size(Width, Height);
}

float body_delta = 10;  
PVector body_pos = new PVector(50, Height/2);
PVector head_pos = new PVector();
PVector fire_pos = new PVector();
PVector inv_pos = new PVector();//看不见的头
PVector coke_pos = new PVector();

float rot_counter = 0;
int health = 100;
boolean coke_ready = false;
boolean super_mode = false; 
int super_mode_counter = 0;
int head_hp = 3;
int body_hp = 3;

final int game_begin = 0;
final int game_op_movie = 1;
final int game_help = 2;
final int game_ing = 3;
final int game_over = 4;
final int game_ed_movie = 5;
int game_status = game_begin;
int status_counter = 0;
float game_progress = 0;
boolean game_pause = false;

boolean mouseReleased = false;
void mouseReleased()
{
  mouseReleased = true;
}

boolean keyReleased = false;
void keyReleased()
{
  if (key == 'p' || key == 'P')
    game_pause = !game_pause; 
  keyReleased = true;
}

void keyboard()
{
  if (keyPressed)
  {
    if (key == 'w') {
      body_pos.y -= body_delta;
      if (body_pos.y < 0) body_pos.y = 0;
    }
    else  if (key == 's') {
      body_pos.y += body_delta;
      if (body_pos.y > height) body_pos.y = height;
    }
    if (key == 'a') {
      body_pos.x -= body_delta;
      if (body_pos.x < 0) body_pos.x = 0;
    }
    else if (key == 'd') {
      body_pos.x += body_delta;
      if (body_pos.x > width) body_pos.x = width;
    }
  }
}

void draw()
{
  switch (game_status)
  {
  case game_begin:
    {
      status_counter = frameCount;
      game_status = game_op_movie;
      imageMode(CORNER);
    }
    break;
  case game_op_movie:
    {
      game_status = game_help;
    }
    break;
  case game_help:
    {
      game_help();
      if (frameCount - status_counter > 30*2)
      {
        text("Press any key...", width/2, height-100);
        if (keyPressed || mousePressed)
        {
          mouseReleased = false;
          keyReleased = false;
          status_counter = frameCount;
          head_hp = body_hp = 3;
          game_status = game_ing;
          bullets.list.clear();
          pepsis.list.clear();
          game_pause = false;
        }
      }
    }
    break;
  case game_ing:
    {
      if (head_hp <= 0 || body_hp <= 0)
      {
        status_counter = frameCount;
        game_status = game_over;
      }
      else
      {
        game_progress = (frameCount - status_counter)/game_total_count;
        if (game_progress >= 1)
        {
          imageMode(CORNER);
          game_status = game_ed_movie;
        }
        else
          game_ing();
      }
    }
    break;
  case game_over:
    {
      if (frameCount - status_counter > 30*4)
      {
        status_counter = frameCount;
        game_status = game_help;
      }
      else
        game_over();
    }
    break;
  case game_ed_movie:
    {
       game_status = game_help;
    }
    break;
  default:
    break;
  }
}

void game_help()
{
  imageMode(CORNER);
  image(bg, 0, 0, width, height);

  fill(0);
  int x = 20;
  int y = 0;
  int dy = 60;
  text("Tips:", x, y+=dy);
  text("  Uncle M's body and head is separated", x, y+=dy);
  text("  W/S/A/D -> body, mouse -> head, P -> pause", x, y+=dy);
  text("  Shout to microphone to fire", x, y+=dy);
  text("  Cococola gives super power", x, y+=dy);
  text("Go fight!!! Uncle M!!!", x, y+=dy);
}

void game_over()
{
  imageMode(CORNER);
  image(bg, 0, 0, width, height);
  String error_msg = "";
  if (head_hp <= 0)
    error_msg = "Uncle M's head is broken!";
  else
    error_msg = "You have no body!";
  float x = noise(frameCount*0.005)*width*0.6;
  float y = noise(frameCount*0.005+2)*height;

  fill(0);
  text(error_msg, x, y);
}

