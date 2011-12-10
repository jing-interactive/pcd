//抽奖环节
int award_millis = 0;
Phrase the_phrase = null;//
int global_millis = 0;
boolean has_winner = false;//

void award_setup()
{
  global_millis = millis();
  award_millis = millis();
  app_mode = award_mode;
  the_phrase = null;
  has_winner = false;
}

void award_mode()
{
  textAlign(CENTER);
  textFont(font_normal, 18);

  if (!has_winner)
  {
    float s = sin((millis - global_millis)*0.01);
    float elapse = abs(s)*500;
    println(elapse);

    if (millis - award_millis > 100)
    {
      award_millis = millis;
      if (vm_list != null)
      {
        int idx = (int)random(vm_list.size());
        the_phrase = vm_list.get(idx);
      }
    }
  }
  if (the_phrase != null)
  {
    if (!has_winner && millis - global_millis > 7000)
    {
      has_winner = true;
    }    
    pushMatrix();
    translate(width/2, height*0.55);
    scale(2);
    image(the_phrase.profile_.big_, 0, 0);
    translate(0, height*0.15);
    if (has_winner)
    {
      fill(random(255), random(255), random(255));
      scale(1.5);
    }
    else
    {
      fill(the_phrase.profile_.clr_);
    }
    text(the_phrase.profile_.name_, 0, 0);
    popMatrix();
  }
}

