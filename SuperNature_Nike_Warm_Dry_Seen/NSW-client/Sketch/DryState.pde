
public class DryState extends State {

    void enter() {
        movHelp = getMovie("DryHelp.mp4");

        palette = getImage("DryPalette.png");

        sendOsc("/state", "dry");
    }

    void quit() {
        stopMovie(movHelp);
    }

    void draw() {
        // background(22);
        // scrollV = lerp(scrollV, mouseDragged.y, CFG_DRY_DAMPING);
        scrollV = -mouseDragged.y / height;
        // if (!mouseReleased) {
        //     sendOsc("/dry/v", scroll);
        // }

        textureMode(NORMAL);
        textureWrap(REPEAT);

        applyAlpha(interactionAlpha);
        noStroke();
        beginShape();
        texture(palette);
        vertex(outerX[0], outerY[0], 0.1, scroll + scrollV + 0.5);
        vertex(outerX[1], outerY[1], 0.1, scroll + scrollV + 0.5);
        vertex(outerX[2], outerY[2], 0.1, scroll + scrollV + 1);
        endShape();

        stroke(200, 200, 200, interactionAlpha);
        for (int t = 0; t < 3; t++) {
            float x0 = outerX[t];
            float y0 = outerY[t];
            float x1 = outerX[(t + 1) % 3];
            float y1 = outerY[(t + 1) % 3];
            float x2 = outerX[(t + 2) % 3];
            float y2 = outerY[(t + 2) % 3];
            for (int i = 0; i < LEVELS; i++) {
                float ratio = (i + 1) / (float)LEVELS;
                line(lerp(x0, x1, ratio), lerp(y0, y1, ratio),
                     lerp(x0, x2, ratio), lerp(y0, y2, ratio));
            }
        }
        interactiveCommon(getImage("word_0002_be-dry.png"), movHelp, getImage("_0002_dry-tips.png"),
            getImage("_0003_dry.png"),
            getImage("_0002_Layer-2.png"));
    }

    void mouseDragged() {
        sendOsc("/dry/v", scroll + scrollV);
    }

    void mouseReleased() {
        scroll += scrollV;
    }

    Movie movHelp;

    PImage palette;

    float scroll;
    float scrollV;

    final int LEVELS = 7;
    final float CELL_SIZE_W = (outerX[1] - outerX[0]) / LEVELS;
    final float CELL_SIZE_H = (outerY[2] - outerY[0]) / LEVELS;
}
