PApplet self;

String[] regionNames =
{
  "asphalt", //A1~A6
  "cobbled", //B1~B6
  "grass", //C1~C5
  "track", //D1~D5
  "centre", //E1
};

color[] regionColors =
{
  color(255, 235, 0), 
  color(0, 210, 255), 
  color(185, 255, 10), 
  color(255, 0, 90), 
  color(0, 0, 0),
};

int[] animTypes =
{
  0, 
  0, 
  0, 
  0, 
  0
};

int[] yPos =
{
  60,
  4,
  30,
  0,
  50
};

Region[] regions = new Region[regionNames.length];
Region center;

void setupRegion()
{
  for (int i=0; i<regionNames.length; i++)
  {
    regions[i] = new Region(regionNames[i]);
    regions[i].setColor(regionColors[i]);
    regions[i].mAnimType = animTypes[i];
    
      String folderName = sketchPath + "/data/" + regionNames[i];
    // video
    for (String filename: listFileNames(folderName + "/video/"))
    {
      regions[i].addVideo(folderName + "/video/" + filename);
      if (!isLoadingAllVideo)
      {
        // just load the first video
        break;
      }
    }

    // audio
    String[] filenames = listFileNames(folderName + "/audio/");
    for (int k=0; k<filenames.length; k++)
    {
      regions[i].addAudio(folderName + "/audio/" + filenames[k]);
      if (!isLoadingAllAudio && k > filenames.length/2)
      {
        break;
      }
    }
  }

  center = regions[regions.length - 1];
  for (Movie movie: center.mMovies)
  {
    movie.loop();
  }
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

void setup()
{
  self = this;

  size(displayWidth, displayHeight);
  noFill();

  Ani.init(this);

  setupAudio();
  setupGUI();
  setupArduino();
  setupRegion();
}

boolean isRegionActivated = false;
boolean isCenterAlive = false;

void draw()
{
  background(0);

  noFill();
  int idx = 0;
  isRegionActivated = false;
  for (idx=0; idx<regions.length - 1; idx++)
  {
    Region region = regions[idx];
    region.update();
    isRegionActivated = isRegionActivated || region.mIsActivated;
    region.draw1D(0, yPos[idx]);
    region.draw2D(150 * idx, 200);
    text(regionNames[idx], 150 * idx + 50, 180);
  }

  drawCenter();
}

float centerAlpha = 0.0f;
void drawCenter()
{
  if (isCenterAlive && isRegionActivated)
  {
    Ani.to(this, kCenterFadeTime, "centerAlpha", 0);
    isCenterAlive = false;
    println("interaction");
  }
  else if (!isCenterAlive && !isRegionActivated)
  {
    Ani.to(this, kCenterFadeTime, "centerAlpha", 1.0);
    isCenterAlive = true;
    println("idle");
  }

  int idx = regionNames.length - 1;

  center.updateCenter();

  text(regionNames[idx], 150 * idx + 50, 180);
  center.draw1D(0, yPos[idx]);
  center.draw2D(150 * idx, 200);
}

