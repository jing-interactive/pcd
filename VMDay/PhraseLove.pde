
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

class Phrase 
{
  String text;
  String user;
  PImage small,big;
  String id;
  color clr;

  Phrase(String _id, String _txt, String _name, String icon_url)
  {
    id = _id;
    text = _txt;
    user = _name;
    clr = color(random(200), random(200), random(200));
    if (icon_url != null)
    {
      small = loadImage(icon_url, "jpg");
      PImage_resize(small, 0.6);
    }
  }

  void enter()
  {
  }

  void leave()
  {
  }

  void draw(float idx)
  {
    // pushMatrix();
    float x = -width*0.3+noise(idx+frameCount*0.001)*width;
    float y = idx*phrase_height+20;
    image(small, x, y);
    // translate(x,y);
    fill(clr);
    text(user+":", x+0, y+0);	
    fill(100, 100, 200);  
    text(text, x+50, y+20);
    // popMatrix();
  }
}

void draw_seperator()
{
  translate(0, height*0.43+15);
  strokeWeight(10);
  noFill();
  stroke(200, 0, 0, 50);
  float h = -52;
  image(line_png, spa+width/2, h);
}

