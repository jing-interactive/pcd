import android.media.SoundPool;
import android.media.AudioManager;

SoundPool soundPool;
//AssetManager assetManager;
int snd_hit, snd_ahhh;

void audio_init()
{
  soundPool = new SoundPool(2, AudioManager.STREAM_MUSIC, 0);
  //  assetManager = this.getAssets();
  try {
    snd_hit = soundPool.load(this.getAssets().openFd("hit_tuntun.wav"), 1);
    snd_ahhh = soundPool.load(this.getAssets().openFd("ahhh.3gpp"), 1);
  }
  catch (IOException e) {
    e.printStackTrace();
  }
}

void audio_play(int id, boolean flag)
{
  switch (id)
  {
  case 0:
    if (!flag)
      soundPool.stop(snd_hit);
    else
      soundPool.play(snd_hit, 0.2, 0.2, 0, 0, 1);
    break;
  case 1:
    if (!flag)
      soundPool.stop(snd_ahhh);
    else
      soundPool.play(snd_ahhh, 0.5, 0.5, 0, 0, 1);
    break;
  }
}

void soundsRelease()
{
  soundPool.release();
}

