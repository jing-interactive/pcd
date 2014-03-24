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
    }
    regions[0].addMovie("movie/asphalt.mov");
    //    regions[0].addMovie("movie/asphalt_2.mov");

    regions[1].addMovie("movie/cobbled.mov");
    //    regions[1].addMovie("movie/cobbled2.mov");

    regions[2].addMovie("movie/grass.mov");
    //    regions[2].addMovie("movie/grass2.mov");

    regions[3].addMovie("movie/track.mov");
    //    regions[3].addMovie("movie/track_2.mov");
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

