//抽奖环节

void award_mode()
{
  int millis = millis();

  textAlign(LEFT);
  textFont(font_normal, 18);
  translate(0, height*0.2-15);

  if (thread_vm.isDataUpdated())
  {
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
    phrase_v.draw(n_visible_vm+0.37);

    if (debug_main)
    {
      for (Object o: vm_list)
      {
        Phrase p = (Phrase)o;
        println(p.text);
      }
    }
  }
}

