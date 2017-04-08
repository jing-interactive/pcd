private int mod(int x, int y) {
    int result = x % y;
    return result < 0 ? result + y : result;
}

public class WarmState extends State {

    void enter() {
        movHelp = getMovie("WarmHelp.mp4");

        sendOsc("/state", "warm");
    }

    void quit() {
        stopMovie(movHelp);
    }

    void draw() {
        noStroke();

        for (int i = 0; i < 5; i++) {
            float ratio = i / (5 - 1.0);
            int id = mod(i + (int)(paletteIndex + dot), palette.length);
            fill(palette[id] & ((int)interactionAlpha << 24 | 0xFFFFFF));
            beginShape();
            for (int j = 0; j < 3; j++) {
                float x = lerp(outerX[j], innerX[j], ratio);
                float y = lerp(outerY[j], innerY[j], ratio);
                vertex(x, y);
            }
            endShape(CLOSE);
        }

        interactiveCommon(getImage("word_0000_be-warm.png"), movHelp, getImage("_0001_warm-tips.png"),
            getImage("_0001_warm.png"),
            getImage("_0000_Layer-3.png"));
    }

    float dot = 0;
    float startRadius;
    final float k = 25;
    void mousePressed() {
        startRadius = PVector.dist(triangleCenter, mousePos);
    }

    void mouseDragged() {
        float endRadius = PVector.dist(triangleCenter, mousePos);
        dot = (endRadius - startRadius) / (width / k) + 0.0;
        sendOsc("/warm/v", paletteIndex + dot);
    }

    void mouseReleased() {
        float endRadius = PVector.dist(triangleCenter, mousePos);
        dot = (endRadius - startRadius) / (width / k) + 0.0;
        println("dot: " + dot);
        sendOsc("/warm/v", paletteIndex + dot);

        paletteIndex += dot;
        startRadius = 0;
        dot = 0;
    }

    float paletteIndex = 0;
    color palette[] = {
        color(254, 172, 11), // (outerX, outerY)
        color(254, 159, 0),
        color(254, 116, 11),
        color(254, 72, 10),
        color(254, 0, 31), // (innerX, innerY)
        color(254, 72, 10),
        color(254, 116, 11),
        color(254, 159, 0),
    };


    Movie movHelp;
}
