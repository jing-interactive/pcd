/*
 [][][][][][][][][][][][][][][]Snake5
 use W/S/A/D to control your snake
 vinjn.z@gmail.com
 */

float s = 6;//default moving speed of snake
float r = 14;//the size
ArrayList snake = new ArrayList();
PVector food = new PVector();
PVector vel = new PVector(s, 0);
PVector prev_food = null;
float FADE_MAX = 30.0;
int fade_count = (int)FADE_MAX;
boolean started = false;

AccelerometerManager accel;
float ax, ay, az;

final int spacing = 10;
int x1 = 0;
int y1 = 0;
int x2 = 400;
int y2 = 400;
void newFood()
{
  prev_food = food;
  food = new PVector(random(width), random(height));
}

void draw_food(PVector pos, float rad)
{
  fill(color(0, 122, 200));
  noStroke();
  rect(pos.x, pos.y, rad, rad);
  noFill();
  stroke(0);
  strokeWeight(1);
  rect(pos.x, pos.y, rad*1.3, rad*1.3);
}

PVector head = null;

void setup()
{
  //some boring setup
  //size(400, 400);
  orientation(PORTRAIT);
  accel = new AccelerometerManager(this);
  smooth();
  frameRate(30);
  rectMode(CENTER);
  ellipseMode(CENTER);

  snake.add(new PVector(width/2, height/2));//the first one is the HEAD
  snake.add(new PVector());//body 1
  snake.add(new PVector());//body 2
  newFood();
  head = (PVector)snake.get(0);
}

void mousePressed()
{
  float dx = mouseX - head.x;
  float dy = mouseY - head.y;
  float adx = abs(dx);
  float ady = abs(dy);
  if (vel.x == 0)
  {
    // if (adx > ady)
    {
      if (dx < 0)
        vel.set(-s, 0, 0);
      else if (dx > 0)
        vel.set(s, 0, 0);
    }
  }
  else if (vel.y == 0)
  {
    // if (adx < ady)
    {
      if (dy < 0)
        vel.set(0, -s, 0);
      else if (dy > 0)
        vel.set(0, s, 0);
    }
  }
}
void draw()
{
  background(200);
  if (!started)
  {
    started = true;
    return;
  }
  if (prev_food != null)
  {
    fade_count --;
    float fade_r = r*1.5f/FADE_MAX*fade_count;
    draw_food(prev_food, fade_r);
    if (fade_count < FADE_MAX*0.4)
    {
      prev_food = null;
      fade_count = (int)FADE_MAX;
    }
  }

  //[update & draw snake's head]
  //acc
  if (false)
  {
    if (vel.x == 0)
    {
      if (ax < -1.0)
        vel.set(s, 0, 0);
      else if (ax > 1.0)
        vel.set(-s, 0, 0);
    }
    else if (vel.y == 0)
    {
      if (ay < -1.0)
        vel.set(0, -s, 0);
      else if (ay > 1.0)
        vel.set(0, s, 0);
    }
  }
  head.add(vel);
  if (head.x > width) head.x -= width;
  else if (head.x < 0) head.x += width;
  if (head.y > height) head.y -= height;
  else if (head.y < 0) head.y += height;

  fill(color(200, 0, 0));
  stroke(0);
  strokeWeight(3);
  ellipse(head.x, head.y, r*1.5, r*1.5);

  //[update & draw snake's bodies]
  for (int i=snake.size()-1;i>0;i--)
  {
    PVector cur = (PVector)snake.get(i);
    fill(color(100));
    noStroke();
    ellipse(cur.x, cur.y, r, r);
    noFill();
    stroke(0);
    strokeWeight(1);
    ellipse(cur.x, cur.y, r*1.3, r*1.3);

    //make latter ones follow previous ones
    PVector prev = (PVector)snake.get(i-1);
    cur.x = prev.x;
    cur.y = prev.y;
  }
  if (head.dist(food) < r)//if near enough, EAT the food
  {
    snake.add(new PVector(head.x, head.y));//Yummy!!
    newFood();//giv me more food!!
  }
  else
  {//just draw the food
    draw_food(food, r);
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

