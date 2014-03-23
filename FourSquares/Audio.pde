import ddf.minim.*;

Minim minim;
AudioPlayer bgSnd;
AudioSample bellSnd;
AudioSample explosionSnd;

void setupAudio()
{
    minim = new Minim(this);
    bgSnd = minim.loadFile("ophelia.mp3");
    bgSnd.play();

    bellSnd = minim.loadSample("bell.wav");
    explosionSnd = minim.loadSample("explosion.wav");
}

