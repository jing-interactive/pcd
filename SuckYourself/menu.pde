void menu_setup()
{
  state = menu;
  bg = menu0;
  noCursor();
}

void menu()
{
  pushMatrix();
  translate(mouseX, mouseY);
  rotate(-frameCount*0.05);
  image(our, 0, 0);
  popMatrix();
  
  bg = menu0;
    
  if (mouseX > 607 && mouseX < 680)
  {
    if (mouseY > 267 && mouseY < 374)
    {
        bg = menu1;
    }
    else 
      if (mouseY > 418 && mouseY < 525)
    {
      bg = menu2;
    }
  }
 
  if (mousePressed == true)
  {
    if (bg == menu1)
      way0_setup();   
    else if (bg == menu2)
      way1_setup();
  }
}

