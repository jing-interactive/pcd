void drawStory(String bg, String fg, String textile) {
  if (bg != null) {
    shader.set("bg", getImage(bg));
  }
  if (fg != null) {
    shader.set("fg", getImage(fg));
  }
  shader.set("realtime", kinectDevice.getRgbImage());
  if (textile != null) {
    shader.set("textile", getImage(textile));
  }
  shader.set("texFlags", fg != null, textile != null, true, bg != null);
  useShader();
  image(kinectDevice.getRgbImage());
  resetShader();
}

class PlayState extends State {
  void enter() {
  }

  void quit() {
  }

  void draw() {

    drawStory(CFG_Player_Only ? null : "2015/2015-BG.jpg", null, null);

    if (keyPressed && key == 'b') {
      saveFrame("####_2015.jpg");
      drawStory("1600/bg_ancient.jpg", "1600/fg_tree.png", "1600/textile.jpg");
      saveFrame("####_1600.jpg");
      drawStory("1900/1900-BG.jpg", null, "1900/1900-F.jpg");
      saveFrame("####_1900.jpg");
      drawStory("1980/1980-BG.jpg", null, "1980/1980-F.jpg");
      saveFrame("####_1980.jpg");
    }
  }
}