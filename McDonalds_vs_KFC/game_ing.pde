final float game_total_count = 2*60*30;// the game's length is one min

void game_ing()
{
  minim_draw();
  keyboard();

  imageMode(CORNER);
  image(bg, 0, 0, width, height);
  imageMode(CENTER);

  if (game_pause)
  {
    float x = noise(frameCount*0.005)*width*0.6;
    float y = noise(frameCount*0.005+2)*height;

    fill(0);
    text("休息一会儿吧", x, y);
    return;
  }

  generate_items();
  //head
  head_pos.x = mouseX;
  head_pos.y = mouseY;
  inv_pos.x = body_pos.x + 20;
  inv_pos.y = body_pos.y - 85;
  fire_pos.x = head_pos.x+70;
  fire_pos.y = head_pos.y-2;

  if (health > 50)
  {
    if (frameCount % 20 == 12)
      bullets.add(body_pos.x+95, body_pos.y - 60, random(10, 13), 0, 1);
  }

  do_collision();
  fire_seq.setPos(fire_pos.x, fire_pos.y);

  //mic
  if (health > 90 && mic_volume > 0.05)
  {
    if (super_mode)
    {
      for (Particle q:qiqi.list)
      {
        q._life = 0;
        qiqi_die.add(q._x, q._y, 0, 10, 1);
      }
      for (Particle p:pepsis.list)
      {
        PVector pp = new PVector(p._x, p._y);
        pp.sub(head_pos);
        pp.normalize();
        pp.mult(25);
        p._vx = pp.x;
        p._vy = pp.y;
      }
    }
    fire_seq.run = true;
    fire_seq.onetime = true;
  }

  //draw
  if (super_mode_counter -- < 0)
  {
    super_mode = false;
  }
  if (super_mode)
    uncle_m_super.draw(int(body_pos.x), int(body_pos.y));
  else
    uncle_m_run.draw(int(body_pos.x), int(body_pos.y));

  bullets.draw();
  qiqi.draw();
  qiqi_die.draw();

  if (fire_seq.run)
    image(head_angry, head_pos.x, head_pos.y);
  else
  {
    pushMatrix();
    translate(head_pos.x, head_pos.y);
    if (health < 100)
    { 
      rot_counter += 1;
      rotate(noise(rot_counter)*2-1);
      // rotate(random(2*PI));
    }
    image(head_normal, 0, 0);
    popMatrix();
  }
  fire_seq.draw();
  blood_seq.draw();
  pepsis.draw();
  if (coke_ready)
  {
    image(coke, coke_pos.x, coke_pos.y);
    if (coke_pos.x >width || coke_pos.x<0 || coke_pos.y > height||coke_pos.y<0)
    {
      coke_ready = false;
    }
  }

  draw_hud();
}

void draw_hud()
{  
  if (head_hp > 0)
    image(head_icon[head_hp-1], 70, height-40);
  if (body_hp > 0)
    image(body_icon[body_hp-1], 230, height-40);

  //println(game_progress); 
  noStroke();
  fill(122, 122);
  rect(10, 10, width/2, 30);
  fill(246, 0, 0, 255);
  rect(10, 10, (width/2-10)*game_progress, 30);
  image(m_logo, 10+(width/2-10)*game_progress, 25);
  image(kfc_logo, width/2, 27);
}

void do_collision()
{  
  //head vs inv
  float dist = head_pos.dist(inv_pos); 
  if (dist < 50) health = 100;
  else if (dist < 100) health -= 2;
  else health -= 4;
  
  boolean hit = false;

  //coke vs head
  if (coke_ready)
  {
    //eat
    if (health > 90 && head_pos.dist(coke_pos) < 50)
    {
      coke_ready = false;
      super_mode = true;
      super_mode_counter = 30*7;
    }
    //move coke
    coke_pos.x += noise(frameCount*0.01)*20-10;
    coke_pos.y += random(3, 4);
  }

  for (Particle b : bullets.list)
  {
    //bullets vs qiqi
    for (Particle q : qiqi.list)
    {
      if (b._life > 0 && q._life > 0)
      {
        if (sqrt((b._x-q._x)*(b._x-q._x) + (b._y-q._y)*(b._y-q._y)) < 50)
        {
          hit = true;
          b._life = 0;
          q._life --;
          q._x += 30;
          if (q._life <= 0)
          {
            qiqi_die.add(q._x, q._y, 0, 10, 1);
          }
        }
      }
    }
    //bullets vs pepsi
    for (Particle p : pepsis.list)
    {
      if (b._life > 0 && p._life > 0)
      {
        if (sqrt((b._x-p._x)*(b._x-p._x) + (b._y-p._y)*(b._y-p._y)) < 50)
        {
          hit = true;
          b._life = 0;
          p._vx = random(30, 40);
          p._vy = random(-10, 10);
        }
      }
    }
  }

  int[] dists = new int[6];
  dists[0] = 90;
  dists[1] = 50;
  dists[2] = 60;
  dists[3] = 30;
  dists[4] = 60;
  dists[5] = 45;
  PVector[] h_b_pos = new PVector[3];
  h_b_pos[0] = body_pos;
  h_b_pos[1] = head_pos;
  h_b_pos[2] = fire_pos;

  int n = fire_seq.run ? 3 : 2;
  for (int i=0;i<n;i++)
  {
    //vs qiqi
    for (Particle q : qiqi.list)
    {
      if (q._life > 0)
      {
        if (sqrt((q._x-h_b_pos[i].x)*(q._x-h_b_pos[i].x) + (q._y-h_b_pos[i].y)*(q._y-h_b_pos[i].y)) < dists[2*i+0])
        {
          if (i == 0)
            body_hp --;
          else if (i == 1)
            head_hp --;
          q._life = 0;
          q._x += 20;
          qiqi_die.add(q._x, q._y, 0, 10, 1);
        }
      }
    }
    //vs pepsi
    for (Particle p : pepsis.list)
    {
      if (p._life > 0)
      {
        if (sqrt((p._x-h_b_pos[i].x)*(p._x-h_b_pos[i].x) + (p._y-h_b_pos[i].y)*(p._y-h_b_pos[i].y)) < dists[2*i+1])
        {
          if (i == 0)
            body_hp --;
          else if (i == 1)
            head_hp --;
          p._vx = random(30, 40);
          p._vy = random(-10, 10);
        }
      }
    }
  }
  
  if (hit)
    minim_play();
}

void generate_items()
{
  int n_count = int(20+(1-game_progress)*40);
  if (frameCount % n_count == 0)
  {
    qiqi.add(width, random(20, height-20), -random(4, 6), 0, 4);
  }
  if (frameCount % n_count == n_count/2)
  {
    pepsis.add(width, random(20, height-20), -random(4, 6), 0, 1);
  }

  if (frameCount % (30*1.5) == 0)
  {
    if (!coke_ready &&!super_mode)
    {
      coke_ready = true;
      coke_pos.set(width/2, 0, 0);
    }
  }
}
