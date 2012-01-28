final int cut_it = 0;
final int dark_room = 1;
final int get_it = 2;
final int suck_it = 3;
int way0_state = cut_it;
float jiba_x, jiba_y;
float jiba_deg;
int n_hits = 0;

void way0_setup()
{
  n_hits = 0;
  state = way0;
  bg = room;
  textAlign(LEFT);
}

final String[] missions = {
  "Step 1: Cut The Rope", "", "Step 2: Get It", "Step 3: S**k It"
};

void way0()
{  
  text(missions[way0_state], 50, 50);

  if (mousePressed)
  {
    cursor(CROSS);

    pushStyle();
    strokeWeight(2);
    stroke(255, 0, 0);
    line(mouseX, mouseY, pmouseX, pmouseY);
    popStyle();
  }
  else
  {
    cursor(ARROW);
  }
  switch (way0_state)
  {
  case  cut_it:
    {        
      jiba_x = 388;
      jiba_y = 505;
      jiba_deg = random(PI-0.3, PI+0.3);
      if (mousePressed && isMouseInside(383, 395, 395, 522))
      {
        n_hits++;
        minim_play(shout);
        way0_state = dark_room;
        setTimer();//<---
      }
    }
    break;
  case dark_room:
    {
      if ( getElapsed() < 2000)//black for 2 seconds
      {
        fill(0);
        rect(0, 0, width, height);
      }
      else
      {
        way0_state = get_it;
        setTimer();
      }
    }
    break;
  case  get_it:
    {
      jiba_x = noise(frameCount*0.02)*width;
      jiba_y = noise(frameCount*0.01+0.1)*height;
      jiba_deg = noise(frameCount*0.03+0.1)*PI*2;
      if (mousePressed && isMouseInside(jiba_x, jiba_y, 12) && getElapsed() > 500)
      {
        setTimer();
        minim_play(hit);
        n_hits++;

        ellipse(jiba_x, jiba_y, 50, 50);

        if (n_hits == 10)
        {
          minim_play(got);
          way0_state = suck_it;
          n_hits = 0;
        }
      }
    }
    break;
  case  suck_it:
    {
      float d = sqrt(sq(mouseX-pmouseX)+sq(mouseY-pmouseY));
      if (d > 100)
      {
        n_hits++;
        if (n_hits >= 100)
         win_setup();
      }
      d = min(d, 30)*0.1; 
      jiba_x = 435+d;
      jiba_y = 370+d;
      jiba_deg = -PI/4;
      //if mosue
    }
    break;
  }  

  if (cut_it == way0_state || get_it == way0_state)
  {
    text("# "+(10-n_hits), 100, 100);
    pushMatrix();
    translate(jiba_x, jiba_y);
    rotate(jiba_deg);
    image(jiba1, 0, 0);
    popMatrix();

    image(stand, 398, 430);
  }

  if (suck_it == way0_state)
  {
    //    text("# "+n_hits, 100, 100);
    float h = n_hits*0.01;
    pushStyle();
    noStroke();
    fill(255,0,0,55+h*200);
    rect(10, height-80, h*(width-40), 30);
    popStyle();
    
    pushMatrix();
    translate(jiba_x, jiba_y);
    rotate(jiba_deg);
    image(jiba1, 0, 0);
    popMatrix();

    image(stand_suck, 398, 430);
  }
}
