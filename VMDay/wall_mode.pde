//微博墙的显示

void wall_setup()
{
  app_mode = wall_mode;
}

void wall_mode()
{  
  textAlign(LEFT);
  textFont(font_normal, 18);

  //绘制VM
  translate(0, height*0.2-15);
  if (thread_vm.isDataUpdated())
  {
    save();
    vm_list = thread_vm.getData();
    vm_index = 0;
    vm_update_millis = millis();
  }
  if (vm_list != null)
  {
    if (millis - vm_update_millis > 5000)
    {
      vm_index = (vm_index+5)%(vm_list.size());
      vm_update_millis = millis;
    } 
    for (int i=0;i<n_visible_vm;i++)
    {
      int idx = (vm_index+i)%vm_list.size();
      Phrase msg = vm_list.get(idx);
      msg.draw(i);
    }

    if (debug_main)
    {
      for (Object o: vm_list)
      {
        Phrase p = (Phrase)o;
        println(p.text);
      }
    }
  }

  //分割线
  phrase_v.draw(n_visible_vm+0.37);
  translate(0, height*0.43-50);
  draw_seperator();

  //绘制love
  if (thread_love.isDataUpdated())
  {
    love_index = 0;    
    love_list = thread_love.getData();
    love_update_millis = millis;
  }
  if (love_list != null)
  {
    if (millis - love_update_millis > 5000)
    {
      love_index = (love_index+5)%(love_list.size());
      love_update_millis = millis();
    }    
    for (int i=0;i<n_visible_love;i++)
    {
      int idx = (love_index+i)%love_list.size();
      Phrase msg = love_list.get(idx);
      msg.draw(i+0.1);
    }
  }
}
