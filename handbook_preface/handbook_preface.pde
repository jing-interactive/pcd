class Circle
{
    PVector pos;
    float radius;
    color clr = color(40, 115, 180, 100);
}
ArrayList<Circle> circles = new ArrayList<Circle>();
PGraphics pg;

void generateAll()
{
    circles.clear();

    // small ones
    for (int i = 0; i < 500; i++)
    {
        Circle cc = new Circle();
        cc.pos = new PVector(random(pg.width), random(pg.height));
        cc.radius = random(100, 150);
        circles.add(cc);
    }

    // big ones
    for (int i = 0; i < 20; i++)
    {
        Circle cc = new Circle();
        cc.pos = new PVector(random(pg.width), random(pg.height));
        cc.radius = random(200, 1300);
        circles.add(cc);
    }
}

void render()
{
    generateAll();

    println("render.begin");

    pg.beginDraw();
    pg.background(255);

    int nCircles = circles.size();

    // lines
    pg.stroke(0, 40, 80, 250);    
    pg.strokeWeight(2);

    pg.noFill();
    for (int i=0; i<nCircles; i++)
    {
        PVector posi = circles.get(i).pos;
        float radiusi = circles.get(i).radius;
        for (int j=i+1; j<nCircles; j++)
        {
            if (posi.dist(circles.get(j).pos) < (radiusi + circles.get(j).radius)/2)
            {
                pg.line(posi.x, posi.y, circles.get(j).pos.x, circles.get(j).pos.y);
            }
        }
    }

    //        pg.stroke(18, 69, 117, 0);

    // center circles
    final float kDotRadius = 4;
    pg.fill(255);
    for (Circle cc : circles)
    {
        pg.ellipse(cc.pos.x, cc.pos.y, kDotRadius, kDotRadius);
    }

    // filled circles
    pg.noStroke();
    for (Circle cc : circles)
    {
        pg.fill(cc.clr);
        pg.ellipse(cc.pos.x, cc.pos.y, cc.radius, cc.radius);
    }

    //    pg.filter(BLUR, 2);
    pg.endDraw();
    println("render.end");
}

void setup()
{
    println("start");
    randomSeed(second());

    size(400, 400);
    pg = createGraphics(3000, 3000);
    pg.ellipseMode(RADIUS);

    for (int i=0;i<10;i++)
    {
        render();
        pg.save("preface-"+i+".bmp");
    }

    println("saved");
    exit();
}

