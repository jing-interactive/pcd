float warmValue = 0;

private int mod(int x, int y) {
    int result = x % y;
    return result < 0 ? result + y : result;
}

private float mod(float x, int y) {
    while (x > y) {
        x -= y;
    }
    while (x < y) {
        x += y;
    }
    return x;
}

public class WarmState extends State {
    PImage palette;

    void enter() {
        palette = getImage("WarmPalette.png");
    }

    void quit() {
    }

    void oscEvent(OscMessage msg) {
        if (msg.checkAddrPattern("/warm/v")) {
            warmValue = -msg.get(0).floatValue();
            // warmValue = -mod(warmValue, 9);
            warmValue /= 8;
        } else if (msg.checkAddrPattern("/idle")) {
            newState = new WarmIdleState();
        }
    }

    float ww;

    void draw() {
        // tint(CFG_WARM_R, CFG_WARM_G, CFG_WARM_B, CFG_WARM_A);
        textureMode(NORMAL);
        textureWrap(REPEAT);

        ww =  lerp(ww, warmValue, 0.1);

        // noStroke();
        final float k = 0.5;
        beginShape();
        texture(palette);
        float w =  ww - 0.4;
        vertex(0, 0, w, 0);
        vertex(width, 0, w + k, 0);
        vertex(width, height, w + k, 1);
        vertex(0, height, w, 1);
        endShape(CLOSE);
    }
}
