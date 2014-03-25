PApplet self;

String[] regionNames =
{
  "asphalt", //A1~A6
  "cobbled", //B1~B6
  "grass", //C1~C5
  "track", //D1~D5
  //    "centre", //E1
};

Region[] regions = new Region[regionNames.length];

void setupRegion()
{
  for (int i=0; i<regionNames.length; i++)
  {
    regions[i] = new Region(regionNames[i]);

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
    for (int i=0; i<filenames.length; i++)
    {
      regions[i].addAudio(folderName + "/audio/" + filenames[i]);
      if (!isLoadingAllAudio && i > filenames.length/2)
      {
        break;
      }
    }
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

  size(800, 600);
  noFill();

  setupAudio();
  setupGUI();
  setupArduino();
  setupRegion();
}

void draw()
{
  background(0);

  int idx=0;
  noFill();
  for (Region region: regions)
  {
    region.update();
    region.draw1D(10, 10+idx*10);
    region.draw2D(150 * idx, 200);

    idx++;
  }

  drawArduino();
}

