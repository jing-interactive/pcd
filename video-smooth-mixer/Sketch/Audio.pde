import ddf.minim.*;

Minim minim;

void setupAudio()
{
  minim = new Minim(this);
}

void playAudio(String filename)
{
  AudioPlayer player = minim.loadFile(filename);
  player.play();
}