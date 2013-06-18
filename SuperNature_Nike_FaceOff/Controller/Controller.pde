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
OscP5 oscP5;
NetAddress to_sb, to_panel;

Client sim;//simulator
Client c;

String ips[] = new String[10]; 

void sendStartCommand(int i)
{
  //  c = new Client(this, "192.168.1.100", 80); // Connect to server on port 80
  //  c.write("GET /?cmd=1 HTTP/1.1\n\n"); // Use the HTTP "GET" command to ask for a Web page
  loadStrings("http://"+ips[i]+"/?cmd=1");
}

void sendClearCommand(int i)
{
  //  c = new Client(this, "192.168.1.100", 80); // Connect to server on port 80
  //  c.write("GET /?cmd=2 HTTP/1.1\n\n"); // Use the HTTP "GET" command to ask for a Web page
  loadStrings("http://"+ips[i]+"/?cmd=2");
}

String sendQueryCommand(int i)
{
  //  c = new Client(this, "192.168.1.100", 80); // Connect to server on port 80
  //  c.write("GET /?cmd=3 HTTP/1.1\n\n"); // Use the HTTP "GET" command to ask for a Web page
  String[] ret = loadStrings("http://"+ips[i]+"/?cmd=3");
  if (ret != null)
    return ret[0];
  else return "";
}

void setup()
{
  size(400, 400);
  controlP5 = new ControlP5(this);

  oscP5 = new OscP5(this, 8888);

  try
  {
    String lines[] = loadStrings("panel.txt");
    panel_ip =  lines[0];
    println(panel_ip);
  }
  catch (Exception e) {
  }  
  try
  {
    String lines[] = loadStrings("scoreboard.txt");
    scoreboard_ip =  lines[0];
    println(scoreboard_ip);
  }
  catch (Exception e) {
  }
  //osc
  to_panel = new NetAddress(panel_ip, 3334);
  to_sb = new NetAddress(scoreboard_ip, 3333);

  if (using_sim)
  {
    //    sim = new Client(this, "localhost", 4001);
  }
  else
  {
    //    c = new Client(this, "192.168.1.100", 80); // Connect to server on port 80
    //    c.write("GET /?cmd=1 HTTP/1.1\n\n"); // Use the HTTP "GET" command to ask for a Web page
    for (int i=0;i<10;i++) 
    {
      ips[i] = "192.168.1."+(100+i);
      println(ips[i]);
    }
    //   for (int i=0;i<10;i++)
    //    sendClearCommand(i);
  }
  //controlP5
  controlP5.addBang("begin", 50, 50, 100, 50);
  controlP5.addBang("reset", 50, 150, 100, 50);
  controlP5.addBang("winner", 50, 250, 100, 50);
  // 
  frameRate(30);
}

void serverEvent(Server someServer, Client someClient)
{
  println("We have a new client: " + someClient.ip());
}

void begin()
{
  for (int i=0;i<10;i++)
  {
    miles[i] = 0;
    prev_miles[i] = 0;
    time[i] = 0;
    speed[i]=0;
  }
  info = "Start";
  //flush
  if (using_sim)
    sim_start();
  else
  {
    for (int i=0;i<10;i++)
    {
      sendStartCommand(i);
    }
  }
  OscMessage m = new OscMessage("/start"); 
  oscP5.send(m, to_sb);
  oscP5.send(m, to_panel);
}

void winner()
{
  info = "Winner";

  OscMessage m = new OscMessage("/winner"); 
  oscP5.send(m, to_sb);
}

void reset()
{
  for (int i=0;i<10;i++)
  {
    miles[i] = 0;
    prev_miles[i] = 0;
    time[i] = 0;
    speed[i] = 0;
  }
  info = "reset";
  if (using_sim)
    sim_end();
  else
  {
    for (int i=0;i<10;i++)
    {
      sendClearCommand(i);
    }
  }
  OscMessage m = new OscMessage("/reset"); 
  oscP5.send(m, to_sb);
  oscP5.send(m, to_panel);
}

float[] speed = new float[10];
float[] miles = new float[10];
float[] time = new float[10];
float[] prev_miles = new float[10];

String the_str;

OscMessage m_to_send = null;
void draw()
{  
  background(122);
  fill(0);
  text(info, 200, height-100);  
  for (int i=0;i<10;i++)
  {    
      text("#"+i+"   "+speed[i]+"M/S    "+miles[i]+"M", 200, 30*i);
  }

  if (frameCount % 3 == 0)
  {
    int idx = (frameCount/3)%10;
    //if (idx == 0 || idx ==3)idx = 1;
    println(idx);
    if (using_sim)
      sim_draw();
    else
    {
      //String msg = loadStrings("http://192.168.1.100/?cmd=3")[0];
      String msg = sendQueryCommand(idx);
      println(msg); 
      int[] data = int(splitTokens(msg, ":T=D,\n")); 
      if (data.length != 2 && data.length !=3)
        return;
      int t = 0;
      if (data.length == 2)
      {
        t = data[0];
        miles[idx] = data[1];
      } 
      else
      {
        t = data[1];
        miles[idx] = data[2];
      }
      if (t > time[idx] + 3)
      {//5 seconds
        speed[idx] = (miles[idx] - prev_miles[idx])/3.0;
        prev_miles[idx] = miles[idx];     
        time[idx] = t;
        //        println(speed[0]+"M/S    "+miles[0]+"M");
        //text(speed[0]+"M/S    "+miles[0]+"M", 30, height-50);
      }

      m_to_send = new OscMessage("/msg");
      m_to_send.add(idx);
      m_to_send.add(speed[idx]);
      m_to_send.add((int)miles[idx]);
    }
  }

  if (debug)
    println(the_str);
  //osc event to do   
  if (the_str != null)
  {
    float[] nums = float(split(the_str, ' ')); 
    m_to_send = new OscMessage("/msg");
    if (debug)
      println(nums);
    m_to_send.add((int)nums[0]);
    m_to_send.add(nums[1]);
    m_to_send.add((int)nums[2]); 
    the_str = null;
  }

  if (m_to_send != null)
  { 
    oscP5.send(m_to_send, to_sb);
    oscP5.send(m_to_send, to_panel);
    m_to_send = null;
  }
}

