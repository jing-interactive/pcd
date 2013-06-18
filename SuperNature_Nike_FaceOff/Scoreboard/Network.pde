import oscP5.*;
import netP5.*;
import processing.net.*;

String[] name_list = new String[10]; 

float[] speed_list = new float[10];
int[] miles_list = new int[10];
float max_speed = 0;

boolean start_msg_recieved = false;
boolean winner_msg_recieved = false;
String login_ip = "localhost";

OscP5 oscP5;
NetAddress myRemoteLocation;
TcpServer runner;
Server s;

void network_setup()
{
  oscP5 = new OscP5(this, 3333);
  try {
    String[] content = loadStrings("login.txt");
    login_ip = content[0];
  }
  catch (Exception e)
  {
  }
  println("login_ip:"+login_ip);
  myRemoteLocation = new NetAddress(login_ip, 3334);
  //  runner = new TcpServer(this, 4000);
  //  s = new Server(this, 4000);
}

void oscEvent(OscMessage msg) 
{
  String patt = msg.addrPattern();
  println(patt);
  println(msg.typetag());
  if (patt.equals("/msg"))
  {
    int id = msg.get(0).intValue();
    float speed = msg.get(1).floatValue();
    int miles = msg.get(2).intValue();
    speed_list[id] = speed;
    miles_list[id] = miles;
    if (speed > max_speed) max_speed = speed;
    _rel_speed_list[id] = speed_list[id]/(max_speed+1);
    return;
  }
   if (patt.equals("/restart"))
  {
    restart_msg_recieved = true;
  }
  else
  if (patt.equals("/start"))
  {
    start_msg_recieved = true;
  }
  else if (patt.equals("/winner"))
  {
    winner_msg_recieved = true;
  }
  else 
    if (patt.equals("/team") || patt.equals("/people"))
  {
    oscP5.send(msg, myRemoteLocation);
  }
  else
    if (patt.equals("/team_CN") || patt.equals("/people_CN"))
    {
      int n_list = 0; 
      if (patt.equals("/team_CN"))
      {
        people_info_recieved = false;
        team_info_recieved = true;
        team_mode = true; 
        n_list = 2;//for team_A_name && team_B_name
      }
      else
      {
        team_info_recieved = false;
        people_info_recieved = true;
        team_mode = false;       
        n_list = 10;
      }

      int next = 0;
      for (int i=0;i<n_list;i++)
      {         
        int strlen = msg.get(next).intValue();
        byte[] bts = new byte[strlen];
        for (int k=0;k<strlen;k++)
        {
          int c = msg.get(next+1+k).intValue();
          bts[k] = (byte)c;
        }
        next += (strlen+1);
        try {
          if (strlen > 0)
            name_list[i] = new String(bts, "GBK");
          else
            name_list[i] = "";//"参赛者#"+(m_counter++);//表示没有参赛者
          if (debug)
            println(name_list[i]);
        }
        catch(Exception e) {
          e.printStackTrace();
        }
      }
    }//end double if
}

int m_counter = 0;
