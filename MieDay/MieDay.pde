Mie mie;
World world;
int num = 10;
float mx[] = new float[num];
float my[] = new float[num]; 

int score = 0;
int hits = 0;
int total_height = 0;
PFont font;

void setup()
{
  acc_setup();
  size(screenWidth,screenHeight, P2D);
  frameRate(30);
  smooth();
  noStroke();

  font = loadFont("SnapITC-Regular-24.vlw");
  textFont(font, 24);

  world = new World();
  mie = new Mie();
}

void draw()
{
  background(122);

  world.draw();
  
  mie.draw();

  fill(0,0,0);
  String s = "SCORE: "+score; 
  text(s,10,height-30);

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
      fill(122+index*122/num,index*255/num,255 );
      //  ellipse(mx[index], my[index]-camera_y, i/4, i/4);
      text(tex,mx[index], my[index]-camera_y);
    }  
  }
}


