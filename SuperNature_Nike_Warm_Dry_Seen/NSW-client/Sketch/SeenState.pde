// TODO: idMap is blurry.. [done] HACKED by P2D mode..

PVector[] triangles;
int[] idMappings = {
    66,
    67, 65,
    68, 43, 64,
    69, 44, 42, 63,
    69, 28, 27, 26, 62,
    70, 45, 13, 12, 41, 61,
    71, 46, 29, 3, 25, 30, 60,
    72, 30, 14, 4, 2, 11, 39, 60,
    73, 47, 15, 5, 0, 1, 10, 22, 59,
    73, 31, 16, 6, 7, 8, 9, 23, 38, 58,
    74, 48, 32, 33, 17, 18, 19, 25, 21, 37, 57,
    75, 49, 50, 51, 34, 52, 35, 53, 36, 54, 55, 56,
    76, 77, 78, 79, 80, 81, 82, 82, 83, 84, 85, 86, 87,
};
PImage idMap; // (triId, ledId, 0)

color triBtnDarkClr = color(22);

public class SeenState extends State {
    void enter() {
        movHelp = getMovie("Seenhelp2.mp4");
        palette = getImage("SeenPalette.png");

        sendOsc("/state", "seen");

        if (triangles == null) {
            triangles = new PVector[TRIANGLE_COUNT];
            int tri = 0;
            for (int i = 0; i < LEVELS; i++) {
                // bottom-up
                float x0 = outerX[2] - CELL_SIZE_W / 2 * (i + 1);
                float y0 = outerY[2] - CELL_SIZE_H * (i + 1);
                for (int j = 0; j < i + 1; j++) {
                    // left-right
                    triangles[tri++] = new PVector(x0 + CELL_SIZE_W * j, y0);
                }
            }

            PGraphics pg = createGraphics(width, height, P2D);
            pg.beginDraw();
            pg.background(255);
            pg.noStroke();

            int id = 0;
            for (PVector o : triangles) {
                pg.beginShape();
                pg.fill(color(id, idMappings[id], 0));
                pg.vertex(o.x, o.y);
                pg.vertex(o.x + CELL_SIZE_W, o.y);
                pg.vertex(o.x + CELL_SIZE_W / 2, o.y + CELL_SIZE_H);
                pg.endShape();
                id++;
            }

            pg.endDraw();
            idMap = pg.get();
            // idMap.save("mapping.bmp");
        }

        for (PVector o : triangles) {
            o.z = 1;
        }
    }

    void quit() {
        stopMovie(movHelp);
    }

    final float kBtnR = 0.07;

    void draw() {
        noStroke();
        float k = palette.height / (outerY[2] - outerY[0]);
        for (PVector o : triangles) {
            color clr = palette.get(0, int((o.y - outerY[0] - 0.01) * k));//color(22);
            float a = 0.0;
            if (o.z == 1) {
                a = 1;
            } else if (o.z < kBtnR) {
                a = 1 - o.z / kBtnR;
            } else if (o.z > 1 - kBtnR) {
                a = (o.z - (1 - kBtnR)) / kBtnR;
            }
            clr = lerpColor(triBtnDarkClr, clr, a);
            beginShape();
            fill(clr & ((int)interactionAlpha << 24 | 0xFFFFFF));
            vertex(o.x, o.y);
            vertex(o.x + CELL_SIZE_W, o.y);
            vertex(o.x + CELL_SIZE_W / 2, o.y + CELL_SIZE_H);
            endShape();
        }

        interactiveCommon(getImage("word_0001_be-seen.png"), 
            movHelp, 
            getImage("_0000_seen-tips.png"),
            getImage("_0005_seen.png"),
            getImage("_0004_Layer-1.png"));
    }

    void mousePressed() {
        mouseReleased();
    }

    void mouseDragged() {
        mouseReleased();
    }

    void mouseReleased() {
        color clr = idMap.get(mouseX, mouseY);
        int triId = (int)red(clr);
        int ledId = (int)green(clr);
        if (ledId < TRIANGLE_COUNT) {
            println("ledId: " + ledId);
            println("triId: " + triId);
            PVector triangle = triangles[triId];
            if (triangle.z == 1) {
                triangle.z = 0;
                sendOsc("/seen/v", ledId);
                sendOsc("/seen/v", ledId); // HACK
                // Ani.to(triangle, SEEN_TRIANGLE_FADE_SECONDS, "z", 1);
                Ani.to(triangle, SEEN_TRIANGLE_FADE_SECONDS + random(0, 0.2), 0, "z", 1, Ani.LINEAR);
            }
        }
    }

    Movie movHelp;
    PImage palette;

    final int LEVELS = 13;
    final int TRIANGLE_COUNT = 91;
    final int LED_COL_COUNT = 88;
    final float CELL_SIZE_W = (outerX[1] - outerX[0]) / LEVELS;
    final float CELL_SIZE_H = (outerY[2] - outerY[0]) / LEVELS;
}
