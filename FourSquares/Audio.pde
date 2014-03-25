import ddf.minim.*;

Minim minim;
AudioPlayer bgSnd;

void setupAudio()
{
  minim = new Minim(this);

  if (isPlayingBgMusic)
  {
    bgSnd = minim.loadFile("center/audio/ophelia.mp3");
    bgSnd.loop();
    bgSnd.play();
  }
}

