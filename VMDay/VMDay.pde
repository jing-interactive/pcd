boolean xmlLoading = true;

Object[] vm_list = null;
Object[] love_list = null;

Phrase phrase_v;
final int n_visible_vm = 5;//for rendering
final int n_visible_love = 5;

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

int phrase_height = 35;
PFont font_normal;
color bgCol = #fff1c3;

final int Width = 1024;
final int Height = 768;

FeedUpdater thread_love = new FeedUpdater("爱你");
FeedUpdater thread_vm = new FeedUpdater("VM%E5%A4%A7%E5%A9%9A");

void setup()
{
  love_png = loadImage("love.png");
  title_png = loadImage("title.png");
  line_png = loadImage("lines.png");

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

  for (int i=0;i<7;i++)
    pic_list.add(new Love());

  phrase_v = new Phrase("xxxx", "Melanie, I am collecting every love message in the air, just for you~", "vinjn", "http://tp3.sinaimg.cn/1455173150/50/1295153611/1");
  phrase_v.clr = color(0, 0, 0);
}

final int spa = 12;

void draw()
{
  background(bgCol);
  image(title_png, width/2, title_png.height/2+10);

  strokeWeight(10);
  noFill();
  stroke(200, 0, 0, 50);
  rect(0, 0, width, height);
  strokeWeight(1);

  for (int i=0;i<pic_list.size();i++)
  {
    pic_list.get(i).draw();
  }
  textAlign(LEFT);
  textFont(font_normal, 18);
  translate(0, height*0.2-15);

  if (thread_vm.isDataUpdated())
  {
    vm_list = thread_vm.getData();
  }
  if (vm_list != null)
  {
    for (int i=0;i<min(n_visible_vm, vm_list.length);i++)
    {
      Phrase msg = (Phrase)vm_list[i];
      msg.draw(i);
    }
    phrase_v.draw(n_visible_vm+0.37);

    if (debug_main)
    {
      for (Object o: vm_list)
      {
        Phrase p = (Phrase)o;
        println(p.text);
      }
    }
  }

  draw_seperator();

  if (thread_love.isDataUpdated())
  {
    love_list = thread_love.getData();
  }
  if (love_list != null)
  {
    for (int i=0;i<min(n_visible_love, love_list.length);i++)
    {
      Phrase msg = (Phrase)love_list[i];
      msg.draw(i);
    }
  }
}

