float dryValue = 0;

public class DryState extends State {
    PImage palette;

    void enter() {
        palette = getImage("DryPalette.png");
    }

    void quit() {
    }

    void oscEvent(OscMessage msg) {
        if (msg.checkAddrPattern("/dry/v")) {
            dryValue = msg.get(0).floatValue() - 0.5;
        } else if (msg.checkAddrPattern("/idle")) {
            newState = new DryIdleState();
        }
    }

    void draw() {
        // tint(CFG_DRY_R, CFG_DRY_G, CFG_DRY_B, CFG_DRY_A);

        textureMode(NORMAL);
        textureWrap(REPEAT);

        // noStroke();
        beginShape();
        texture(palette);
        vertex(0, 0, 0, dryValue + 0.5);
        vertex(width, 0, 1, dryValue + 0.5);
        vertex(width, height, 1, dryValue + 1);
        vertex(0, height, 0, dryValue + 1);
        endShape(CLOSE);
    }
}
