//parameters
final int phrase_height = 45;
final int n_love_png = 5;

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
  String id;//id of this phrase
  String text;
  Profile profile_;//who sent it

  Phrase(String _id, String _txt, String name, String icon_url)
  {
    id = _id;
    //just part of text
    int idx = _txt.indexOf("//", 60);
    if (idx != -1)
      text = _txt.substring(0, idx); 
    else
      text = _txt;
    if (textWidth(text) > width*0.8)
    {
      //      println(text.length() + ":"+text);
    }

    if (g_profiles.containsKey(name) )
    {
      profile_ = g_profiles.get(name);
      profile_.post_ ++;
    }
    else
    {
      profile_ = new Profile(name, icon_url);
      g_profiles.put(name, profile_);
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
    float x = noise(idx+frameCount*0.001)*width/4;
    float y = idx*phrase_height+20;
    image(profile_.small_, x-10, y+7);
    // translate(x,y);
    fill(profile_.clr_);
    text(profile_.name_+":", x+10, y+0);	
    fill(20, 20, 20,240);  
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

