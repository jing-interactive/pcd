import oscP5.*;

OscP5 oscP5;//OSC对象

class vBlob
{
  float x, y, z;
}
vBlob[] blobs = new vBlob[2];
boolean kinect_data = false;
boolean isNewKinectData()
{
  boolean ret = kinect_data;
  kinect_data = false;
  //  println(ret);
  return ret;
}

void kinect_setup()
{
  oscP5 = new OscP5(this, 3333);//3333是CamServer的端口号，我提到过一次的
  for (int i=0;i<2;i++)
    blobs[i] = new vBlob();

  millisLastKinectData = millis();
}

void oscEvent(OscMessage msg)
{
  if (msg.checkAddrPattern("/start")) 
  {// 收到 /start 意味着一次更新的开始
    // blobList.clear();//将blobList清空，因为我们要把全新的数据塞进去了
  }
  else
  { 
    if (msg.checkAddrPattern("/contour"))
    {
      kinect_data = true;
      float cx = msg.get(2).floatValue();
      float cy = msg.get(3).floatValue();
      float w = width*msg.get(4).floatValue();
      float h = height*msg.get(5).floatValue();
      float z = msg.get(6).floatValue();
      blobs[0].x = cx;
      blobs[0].y = cy;
      blobs[0].z = z;
      //      println(cx+","+cy);
    }
  }
}

void kinect_draw()
{
  if (kinect_data)
  {
    kinect_data = false;
    //    mode = sphere_solid;
    millisLastKinectData = millis;
    target_z = map(blobs[0].z, 800, 3000, Z-1, 0);
    target_x = blobs[0].x;
    target_y = blobs[0].y;
    println(blobs[0].z+","+target_z);
    if (mode == spark)
      shooting_reset();
  }
  else
  {
    if (millis - millisLastKinectData > millisLostConnection)
      mode = spark;
  }
  curr_z = lerp(curr_z, target_z, 0.05);
  the_x = lerp(the_x, target_x, 0.05);
  the_y = lerp(the_y, target_y, 0.05);
}

