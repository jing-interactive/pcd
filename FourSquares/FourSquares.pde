import java.util.Map;
import processing.video.*;

String[] regionNames =
{
    "cobbled", //A1~A6
    "asphalt", //B1~B6
    "grass", //C1~C5
    "track", //D1~D5
    "centre", //E1
};

Movie mov;

Region[] regions = new Region[regionNames.length];

void setup()
{
    size(displayWidth, displayHeight);
    
    setupAudio();
    setupGUI();

    for (int i=0; i<regionNames.length; i++)
    {
        regions[i] = new Region(regionNames[i]);
    }

    mov = new Movie(this, "track_test.mp4");
    mov.play();
    mov.loop();
}

void keyPressed()
{
    bellSnd.trigger();
}

void draw()
{
    background(0);
    if (mov.available() == true)
    {
        mov.read();
        mov.loadPixels();
        regions[3].update(mov);
    }

    image(mov, 200, 0);

    regions[3].draw1D(0, 200);

    noStroke();
    regions[3].draw2D(0, 0);
}

