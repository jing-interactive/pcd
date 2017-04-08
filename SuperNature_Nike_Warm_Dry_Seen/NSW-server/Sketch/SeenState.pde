color clrA = color(255, 255, 255);
color clrB = color(255, 255, 255);

class Rain {
    float x, y;
    float vy;
    boolean alive = false;

    void shoot() {
        alive = true;
        vy = random(CFG_SEEN_RAIN_VY_MIN, CFG_SEEN_RAIN_VY_MAX);
        y = -vy;
        Ani.to(this, random(CFG_SEEN_RAIN_DURATION_MIN, CFG_SEEN_RAIN_DURATION_MAX),
               0, "y", height, Ani.LINEAR);
    }

    void draw() {
        if (alive) {
            color clr = lerpColor(clrA, clrB, y / height);
            fill(clr & ((int)random(255) << 24 | 0xFFFFFF));
            final float k = 20;
            rect(x - k, y, k, vy);
        }
        if (y >= height) {
            alive = false;
        }
    }
};

Rain[] rains;

public class SeenState extends State {
    PImage palette;
    Movie mov;

    void enter() {
        palette = getImage("SeenPalette.png");
        mov = getMovie("seen.mp4");
        isIdle = false;

        if (rains == null) {
            rains = new Rain[88];
            for (int i = 0; i < rains.length; i++) {
                rains[i] = new Rain();
                rains[i].x = i * 5;
                rains[i].y = 0;
            }
        }
    }

    void quit() {
        stopMovie(mov);
    }

    void oscEvent(OscMessage msg) {
        if (msg.checkAddrPattern("/seen/v")) {
            int oscValue = msg.get(0).intValue();
            rains[oscValue].shoot();
        } else if (msg.checkAddrPattern("/idle")) {
            newState = new SeenIdleState();
        }
    }

    void mouseReleased() {
        rains[(int)random(rains.length)].shoot();
    }

    void draw() {
        // noStroke();
        noStroke();
        for (Rain o : rains) {
            o.draw();
        }
        fillScreen(color(0, renderAlpha * 0.13));
    }
}
