import ddf.minim.*;

Minim minim;
AudioPlayer bgSnd;

void setupAudio()
{
  minim = new Minim(this);

  if (isPlayingBgMusic)
  {
    bgSnd = minim.loadFile("centre/audio/Super Nature.mp3");
    bgSnd.loop();
    bgSnd.play();
  }
}

