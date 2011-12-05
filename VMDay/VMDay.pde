Preloader preloader;
boolean xmlLoading = true;
ArrayList vm_list = new ArrayList();//#VM大婚#
ArrayList love_list = new ArrayList();//#爱你#
Phrase phrase_v;
final int n_visible_vm = 5;//for rendering
final int n_visible_love = 5;
HashMap mid_map = new HashMap();//whether it is already inside

ArrayList<Love> pic_list = new ArrayList<Love>();//a lot of love!
PImage love_png;
PImage title_png;
PImage line_png;

int phrase_height = 35;
PFont font_normal;
color bgCol = #fff1c3;

final int Width = 1024;
final int Height = 768;

void setup()
{
  love_png = loadImage("love.png");
  title_png = loadImage("title.png");
  line_png = loadImage("lines.png"); 
  preloader = new Preloader();
  parseVMXML(); 
  parseLoveXML();

  background(bgCol); 
  fill(0);
  imageMode(CENTER);
  size(Width, Height);
  text("Loading", width/2, height/2);

  font_normal = createFont("msyh", 32); 
//  font_title = createFont("msyh", 32);

  mid_map.put("3369607813924731", 0);//ignore the bitch -____-

  for (int i=0;i<7;i++)
    pic_list.add(new Love());

  phrase_v = new Phrase("Melanie, I am collecting every love message in the air, just for you~", "vinjn");
  phrase_v.clr = color(0, 0, 0);
}

class Love
{
  float   love_x = random(100, width-100);
  float   love_y = random(100, height-100);
  float fade_counter = 0;
  float speed = random(0.5, 1.5);
  float deg = random(0, 3.14);

  void draw()
  {
    // pushMatrix();
    fade_counter = fade_counter+speed;
    if (fade_counter > 100 && abs(sin(fade_counter*0.03)) < 0.01)
    {
      fade_counter = 0;
      love_x = random(100, width-100);
      love_y = random(100, height-100);
      deg = random(0, 3.14);
    }
    tint(255, 10+abs(sin(fade_counter*0.03))*100);
    // translate(love_x,love_y);
    // rotate(deg);
    image(love_png, love_x, love_y);
    noTint();
    // popMatrix();
  }
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
  if (xmlLoading) 
  {
    preloader.animate();
  }
  else
  { 
    for (int i=0;i<pic_list.size();i++)
    {
      pic_list.get(i).draw();
    }  
    textAlign(LEFT);
    textFont(font_normal, 18);
    translate(0, height*0.2-15);
    for (int i=0;i<min(n_visible_vm, vm_list.size());i++)
    {
      Phrase msg = (Phrase) vm_list.get(i);
      msg.draw(i);
    }
    phrase_v.draw(n_visible_vm+0.37);

    pushMatrix();
    translate(0, height*0.43+15);
    strokeWeight(10);
    noFill();
    stroke(200, 0, 0, 50);
    float h = -52;
    image(line_png, spa+width/2, h);     
    for (int i=0;i<min(n_visible_love,love_list.size());i++)
    {
      Phrase msg = (Phrase) love_list.get(i);
      msg.draw(i);
    }
    popMatrix();
  }
}

boolean contains_mid(int mid)
{
  return mid_map.containsKey(mid);
}

void parseVMXML()
{
  parseXML("http://api.t.sina.com.cn/trends/statuses.xml?source=3709681010&trend_name=VM%E5%A4%A7%E5%A9%9A", vm_list);
}

void parseLoveXML()
{
  parseXML("http://api.t.sina.com.cn/trends/statuses.xml?source=3709681010&trend_name=爱你", love_list);
}

void parseXML(String input, ArrayList list)
{  
  list.clear();
  XMLElement xml = new XMLElement(this, input); 
  // println(xml);

  int n_xml = xml.getChildCount();
  for (int i = 0; i< n_xml; i++)
  {
    XMLElement phrase = xml.getChild(i); 
    String mid = phrase.getChild("id").getContent(); 
    println(mid);
    // println(contains_mid(mid));
    if (!mid.equals("3369607813924731"))
    {//check duplicates
      // mid_map.put(mid,0);
      //println(phrase);
      String txt = phrase.getChild("text").getContent(); 
      XMLElement user = phrase.getChild("user");
      String name = user.getChild("screen_name").getContent();
      //println(name);
      //String icon = user.getChild("profile_image_url").getContent();
      //PImage i = loadImage(icon);
      list.add(new Phrase(txt, name));
    }
  }
  xmlLoading = false;
}

class Phrase 
{
  String txt;
  String name; 
  int id;
  color clr;

  Phrase(String _txt, String _name)
  {
    txt = _txt;
    name = _name;
    clr = color(random(200), random(200), random(200));
  }

  void draw(float id)
  {
    // pushMatrix();
    float x = -width*0.3+noise(id+frameCount*0.001)*width;
    float y = id*phrase_height+20;
    // translate(x,y);
    fill(clr);
    text(name+":", x+0, y+0);	
    fill(100, 100, 200);  
    text(txt, x+50, y+20);
    // popMatrix();
  }
}

class Preloader
{
  int numSpokes = 8;  
  float rot = 360/numSpokes;
  float totalRot = 0;
  int interval = 15;
  int counter = 0;

  Preloader()
  {
    noStroke();
  }

  void animate()
  { 
    if (interval==counter)
    {
      counter=0;
      totalRot+=360/numSpokes;
    }
    else
    {
      counter++;
    }
    pushMatrix();

    translate(width/2, height/2);    
    rotate(radians(totalRot));
    for (int i = 0 ; i<numSpokes;  i++)
    {
      rotate(radians(360/numSpokes));
      fill(0, 0, 0, 10*i + 20);
      ellipse(-2, 10, 5, 5);
      //rect(-2, 7, 4, 10);
    }
    popMatrix();
  }
}

