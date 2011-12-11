boolean xmlLoading = true;

ArrayList<Phrase> vm_list = null;
ArrayList<Phrase> love_list = null;
int vm_index = 0;
int love_index = 0;
int vm_update_millis = millis();
int love_update_millis = millis();
final int update_for_msg = 5000;//update every 5 seconds
Phrase phrase_v;
final int n_visible_vm = 5;//for rendering
final int n_visible_love = 5;

PImage default_small, default_big;

void PImage_resize(PImage img, float s)
{
  PImage_resize(img, s, s);
}

void PImage_resize(PImage img, float sx, float sy)
{
  img.resize(int(img.width*sx), int(img.height*sy));
}

ArrayList<Love> pic_list = new ArrayList<Love>();//a lot of love!
PImage love_png;
PImage title_png;

PImage line_png;

PFont font_normal;
color bgCol = #fff1c3;

final int Width = 1024;
final int Height = 768;

FeedUpdater thread_love = new FeedUpdater("%E7%88%B1%E4%BD%A0");
FeedUpdater thread_vm = new FeedUpdater("VM%E5%A4%A7%E5%A9%9A");

void setup()
{
  love_png = loadImage("love.png");
  title_png = loadImage("title.png");
  line_png = loadImage("lines.png");

  default_small = loadImage("small.gif");
  default_big = loadImage("big.gif"); 

  load();

  thread_vm.start();
  thread_love.start();

  background(bgCol); 
  fill(0);
  imageMode(CENTER);
  size(Width, Height);
  text("Loading", width/2, height/2);

  font_normal = createFont("msyh", 32); 
  //  font_title = createFont("msyh", 32);

  //mid_map.put("3369607813924731", 0);//ignore the bitch -____-

  for (int i=0;i<n_love_png;i++)
    pic_list.add(new Love());

  phrase_v = new Phrase("19861209", "Melanie, I am collecting every love message in the air, just for you~", "vinjn", "http://tp3.sinaimg.cn/1455173150/50/1295153611/1");
}

final int spa = 12;
int millis = millis();

void draw()
{
  background(bgCol);
  image(title_png, width/2, title_png.height/2+10);
  millis = millis();

  strokeWeight(10);
  noFill();
  stroke(200, 0, 0, 50);
  rect(0, 0, width, height);
  strokeWeight(1);
  for (int i=0;i<pic_list.size();i++)
  {
    pic_list.get(i).draw();
  }

  FSM_draw();

  switch (app_mode)
  {
  case wall_mode:
    wall_mode();
    break;
  case award_mode:
    award_mode();
    break;
  default:
    wall_mode();
    break;
  }
}

