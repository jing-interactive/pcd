import netP5.*;
import processing.net.*;

TcpClient c_score;
String controller_ip = "127.0.0.1";

Client c;

int frame = 0;

void setup()
{
  size(100, 100);
  try
  {
    String lines[] = loadStrings("controller.ip");
    controller_ip =  lines[0];
  }
  catch (Exception e)
  {
  }
  c = new Client(this, controller_ip, 4000);
  frameRate(1);
}

float[] speed = new float[10];
float[] miles = new float[10];

void Start()
{
  for (int i=0;i<10;i++)
  {
    speed[i] = 0;
    miles[i] = 0;
  }
}

void End()
{
}

void draw()
{
  for (int i=0;i<10;i++) 
  {
    speed[i] = random(4, 6);
    miles[i] += speed[i];
  }
  int i = (int)random(10);  
  String msg = i+" "+(int)speed[i]+" "+(int)miles[i];
  c.write(msg);
  println(msg); 

  if (c.available() > 0) {
    String input = c.readString();
    println(input);
    if (input.charAt(0) == 's')
      Start();
    else if (input.charAt(0) == 'e')
      End();
  }
}

