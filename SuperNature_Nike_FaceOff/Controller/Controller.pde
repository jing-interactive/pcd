import controlP5.*;
//接收Runner的数据，并转发给Scoreboard和Panel
//向Runner发控制信号
import oscP5.*;
import netP5.*;
import processing.net.*;

Server s;
String panel_ip = "127.0.0.1";
String scoreboard_ip = "127.0.0.1";

String info="";
ControlP5 controlP5;

OscP5 to_sb, to_panel;

void setup()
{
  size(400, 400);
  controlP5 = new ControlP5(this);  
  s = new Server(this, 4000);
  try
  {
    String lines[] = loadStrings("panel.ip");
    panel_ip =  lines[0];
    to_panel = new OscP5(this,panel_ip,7777);    
  }
  catch (Exception e) {
  }  
  try
  {
    String lines[] = loadStrings("scoreboard.ip");
    scoreboard_ip =  lines[0];
    to_sb = new OscP5(this,panel_ip,7777);  
  }
  catch (Exception e) {
  }  

  //controlP5
  controlP5.addBang("begin", 50, 50, 100, 50);
  controlP5.addBang("end", 50, 150, 100, 50);
  
  //osc
  oscP5 = new OscP5(this,"239.0.0.1",7777);
}

void serverEvent(Server someServer, Client someClient)
{
  println("We have a new client: " + someClient.ip());
}

void begin()
{
  if (s != null)
    s.write('s');
  info = "Start";
}

void end()
{
  if (s != null)
    s.write('e');
  info = "End";
}

void draw()
{  
  background(122);
  fill(0);
  text(info, width-100,height-100);
  if (keyPressed)
  {
  }
  Client c = s.available();
  if (c != null)
  {
    String str = c.readString();
    println(str);
    //osc event to do    
    /*
      if (str != null)
     {
     int[] nums = int(split(str, ' ')); 
     }*/
  }
}

