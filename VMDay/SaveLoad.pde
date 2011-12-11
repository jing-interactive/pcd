void save()
{
  if (thread_vm.msgs_.size() > 0)
  {
    Object[] arr = thread_vm.msgs_.values().toArray();
    String lines[] = new String[arr.length];

    for (int i=0;i<arr.length;i++)
    {
      Phrase p = (Phrase)arr[i];
      lines[i] = p.toString();
      println(lines[i]);
    }
    saveStrings("vm_phrase.txt", lines);
  }
}

void load()
{
  try
  {
    String lines[] = loadStrings("vm_phrase.txt");
    for (int i=0;i<lines.length;i++)
    {
      Phrase p = new Phrase(lines[i]);
      thread_vm.msgs_.put(p.id, p);
      thread_vm.dataChanged = true;
    }
  }
  catch (Exception e)
  {
  }
}

/*
void save()
 {
 if (g_profiles.size() > 0)
 {
 Object[] arr = g_profiles.values().toArray();
 String lines[] = new String[arr.length];
 
 for (int i=0;i<arr.length;i++)
 {
 Profile p = (Profile)arr[i];
 lines[i] = p.toString();
 println(lines[i]);
 }
 saveStrings("profiles.txt", lines);
 }
 }
 
 void load()
 {
 try
 {
 String lines[] = loadStrings("profiles.txt");
 for (int i=0;i<lines.length;i++)
 {
 Profile p = new Profile(lines[i]);
 g_profiles.put(p.name_, p);
 }
 }
 catch (Exception e)
 {
 }
 }
 */
