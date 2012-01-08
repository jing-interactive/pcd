rule_def_list rules;

void setup()
{
  size(480, 854, A3D);
  noStroke();

  rule_def rule1 = new rule_def();
  //        rule r1 w 20 {
  //            { s 0.9 rz 5 h 5 rx 5 x 1 }  r1
  //            { s 1 0.2 0.5 } box
  //        }
  rule1.weight = 20;
  rule1.geom_type = rule_def.e_box;
  rule1.geom_size = 3.0f;
  rule1.t1 = new PVector(5, 0, 0);
  rule1.r1 = new PVector(3, 3, 3);
  rule1.s1 = new PVector(1, 0.95, 0.95);
  rule1.s2 = new PVector(1, 0.5, 0.2);

  rule_def rule2 = new rule_def();
  //        rule r1 w 20 {
  //            {  s 0.99 rz -5 h 5 rx -5 x 1 }   r1
  //            { s 1 0.2 0.5 } box
  //        }
  rule2.weight = 20;
  rule2.geom_type = rule_def.e_box;
  rule2.geom_size = 3.0f;
  rule2.t1 = new PVector(5, 0, 0);
  rule2.r1 = new PVector(-3, 3, -3);
  rule2.s1 = new PVector(1, 0.99, 0.99);
  rule2.s2 = new PVector(1, 0.2, 0.5);

  rule_def rule3 = new rule_def();
  rule3.weight = 24;
  //        rule r1  {
  //        }

  rules = new rule_def_list(5);
  rules.add(rule1);
  rules.add(rule2);
  rules.add(rule3);
}

int counter = 0;
int inc = 1;
float cam_x=0;

void draw()
{
  background(122);

  cam_x+=0.02;
  //  camera(100*cos(cam_x),0,100*sin(cam_x),0,0,0,0,1,0); 
  translate(width/2, height/2, 0);
  scale(7);
  rotateX(0.08*(frameCount));
  rotateY(0.04*(frameCount));

  if (counter++ > 15)
  {
    rules.max_depth += inc;
    if (rules.max_depth > 15 && inc > 0)
      inc = -1;
    else     if (rules.max_depth < 5 && inc < 0)
      inc = +1;   
    counter = 0;
  }

  //10 * { ry 36 sat 0.9 } 30 * { ry 10 } 1 * { h 30 b 0.8 sat 0.8 a 0.3  } r1
  PVector pos0 = new PVector();
  PVector rot0 = new PVector();
  PVector scale0 = new PVector(1, 1, 1);

  for (int i=0;i<20;i++)
  {
    rot0.y += 18;
    rot0.z = 0;
    for (int j=0; j< 20; j++)
    {
      rot0.z += 18;
      by_rule(i, j, 0, rules, pos0, rot0, scale0);
    }
  }
}

class rule_def
{
  final static int e_box = 0;
  final static int e_sphere = 1;
  final static int e_none = 2; 
  int weight;//for random choose
  float geom_size;
  int geom_type;
  PVector r1, s1, t1;//for recursive
  PVector r2, s2, t2;//for take action
  rule_def()
  {
    weight = 1;
    geom_size = 5.0f;
    geom_type = e_none;
  }
}

class rule_def_list
{
  ArrayList rules = new ArrayList();
  int weight_sum;
  int max_depth;

  rule_def_list(int max_dep)
  {
    weight_sum = 0;
    max_depth = max_dep;
  }

  void add(rule_def rule)
  {
    rules.add(rule);
    int n = rules.size();
    weight_sum = 0;
    for (int i=0;i<n;i++)
      weight_sum += get(i).weight;
  }

  rule_def get(int idx)
  {
    return (rule_def)rules.get(idx);
  }

  rule_def getNextRule(int m, int n, int o)
  {
    int nRules = rules.size();
    int k = int((weight_sum)*noise(m, n, o));

    int sum = 0;
    for (int i=0;i<nRules;i++)
    {
      sum += get(i).weight;
      if (sum >= k)
      {
        //  println(i);
        return get(i);
      }
    }
    return null;
  }
}

void by_rule(int i, int j, int depth, rule_def_list rules, 
PVector trans, PVector rot, PVector scale)
{
  //        { s 0.9 rz 5 h 5 rx 5 x 1 }  r1
  //        { s 1 0.2 0.5 } box

  rule_def rule = rules.getNextRule(i, j, depth);
  if (rule == null)
    return;

  pushMatrix();

  if (rule.geom_type == rule.e_box)
  {
    rotateX(rot.x);
    rotateY(rot.y);
    rotate(rot.z);
    scale(scale.x, scale.y, scale.z);
    translate(trans.x, trans.y, trans.z);
    int gray = int(255*noise(i, j));

    float k = depth/(rules.max_depth + 0.01f);

    if (k < 0.4 && noise(i, k) > 0.6)
    {
      fill(0, 0, gray, 200);
      box(5.5, 1.5, 1.5);
    }
    else
      if (k < 0.85)
      {
        fill(gray, 200);
        box(5, 0.7, 1.4);
      }
      else
      {
        fill(gray, 30, 30, 255);
        box(5, 1.4, 0.7);
      }
    if (depth < rules.max_depth)
    {
      depth++;
      PVector t = rule.t1;
      PVector r = rule.r1;
      PVector s = new PVector();
      s.set(rule.s1.x, rule.s1.y, rule.s1.z);

      by_rule(i, j, depth, rules, t, r, s);
    }
  }

  popMatrix();
}

