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
    size(400, 400);

    for (int i=0; i<regionNames.length; i++)
    {
        regions[i] = new Region(regionNames[i]);
    }

    mov = new Movie(this, "track_test.mp4");
    mov.play();
    mov.loop();

    noStroke();
}

void draw()
{
    background(0);
    if (mov.available() == true)
    {
        mov.read();
        mov.loadPixels();
        for (Button button: regions[3].mButtons)
        {
            for (PVector vertex: button.mVertices)
            {
                vertex.z = mov.get((int)vertex.x, (int)vertex.y);
            }
        }
    }

    image(mov, 200, 0);
    for (Button button: regions[3].mButtons)
    {
        button.draw();
    }
}

