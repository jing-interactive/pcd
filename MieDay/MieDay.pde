Mie mie;
World world;
int num = 10;
float mx[] = new float[num];
float my[] = new float[num]; 

final int intro = 0;
final int gaming = 1;
final int gameover = 2;
int status = intro;

int score = 0;
int hits = 0;
int total_height = 0;
PFont font;

AccelerometerManager accel;
float ax, ay, az;

void setup()
{
  accel = new AccelerometerManager(this);
  audio_init();
  orientation(PORTRAIT);
  size(screenWidth, screenHeight, P2D);
  frameRate(30);
  smooth();
  noStroke();

  font = loadFont("SnapITC-Regular-24.vlw");
  textFont(font, 24);

  world = new World();
  mie = new Mie();

  status = intro;
  Millis = millis();
}

int Millis = 0;

void draw()
{
  background(122);

  switch (status)
  {
  case intro:
    {
      text("B-Day gift 2010 for MieMie", 40, screenHeight/2-100);
      text("by vinjn", 40, screenHeight/2+100);
      if (millis() - Millis > 3000)
        status = gaming;
    }
    break;
  case gaming:
    {
      gaming();
    }
    break;
  }
}

void gaming()
{
  world.draw();

  mie.draw();

  fill(0, 0, 0);
  String s = "SCORE: "+score; 
  text(s, 10, height-30);

  if (true)
  {
    int which = frameCount % num;

    String tex;
    if (mie.vel.y > 0)
    {
      mx[which] = mie.pos.x+mie.w/2-18;
      my[which] = mie.pos.y+mie.h-26;
      tex = ">_<";
    }
    else
    {
      mx[which] = mie.pos.x+mie.w/2-18;
      my[which] = mie.pos.y+mie.h+26;
      tex = "*_*";
    }
    for (int i = 0; i < num; i++) {
      // which+1 is the smallest (the oldest in the array)
      int index = (which+1 + i) % num;
      fill(122+index*122/num, index*255/num, 255 );
      //  ellipse(mx[index], my[index]-camera_y, i/4, i/4);
      text(tex, mx[index], my[index]-camera_y);
    }
  }
}


public void resume() {
  if (accel != null) {
    accel.resume();
  }
}

public void pause() {
  if (accel != null) {
    accel.pause();
  }
}

public void shakeEvent(float force) {
  println("shake : " + force);
}

public void accelerationEvent(float x, float y, float z) {
  //  println("acceleration: " + x + ", " + y + ", " + z);
  ax = x;
  ay = y;
  az = z;
}

