import ddf.minim.*;

Minim minim;
AudioInput in;
AudioPlayer shout, hit, got, high;

void minim_setup()
{
  minim = new Minim(this);
  //minim.debugOn();

  // get a line in from Minim, default bit depth is 16
  in = minim.getLineIn(Minim.MONO, 2);

  //files
  shout = minim.loadFile("shout.wav", 2048);
//  shout.setGain(15.0);
  hit = minim.loadFile("hit.wav", 2048);
  got = minim.loadFile("got.wav", 2048);
  high = minim.loadFile("high.wav", 2048);
//  hit.setGain(-15.0);
}

float mic_volume = 0;

void minim_play(AudioPlayer player)
{
  if (!player.isPlaying())
  {
    player.rewind();
    player.play();
  }
}

void minim_draw()
{
  mic_volume = abs(in.left.get(0));
  // println(mic_volume);
}

void stop()
{
  // always close Minim audio classes when you are done with them
  in.close();
  minim.stop();
//  player.close();

  super.stop();
}

