ArrayList<PImage> backImages = new ArrayList<PImage>();
ArrayList<Boolean> isBackWordBlack = new ArrayList<Boolean>();
PImage intro;
PImage tag, tag_middle;
PImage word_black;
PImage word_white;

void setupImages()
{
  println("loading images");
  String bgFolder = sketchPath + "/data/bg/";
  String[] bgFiles = listFileNames(bgFolder);
  int idx = 0;
  for (String file: bgFiles)
  {
    if (++idx > 4 && !LOAD_ALL_BG) break;
    backImages.add(loadImage(bgFolder + file));
    isBackWordBlack.add(file.length() > 2 ? true : false);
  }

  intro = loadImage("intro.png");
  tag = loadImage("tag.png");
  tag_middle = loadImage("tag_middle.png");
  word_black = loadImage("word_black.png");
  word_white = loadImage("word_white.png");

  // HACK
  greenBg = backImages.get((int)random(backImages.size()));
}

// This function returns all the files in a directory as an array of Strings  
String[] listFileNames(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    return names;
  } 
  else {
    // If it's not a directory
    return null;
  }
}

