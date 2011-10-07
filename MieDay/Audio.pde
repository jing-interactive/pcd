import android.media.SoundPool;
import android.media.AudioManager;

SoundPool soundPool;
//AssetManager assetManager;
int snd_hit;

void audio_init()
{
  soundPool = new SoundPool(1, AudioManager.STREAM_MUSIC, 0);
  //  assetManager = this.getAssets();
  try {
    snd_hit = soundPool.load(this.getAssets().openFd("hit_tuntun.wav"), 1);
  }
  catch (IOException e) {
    e.printStackTrace();
  }
}

void audio_play()
{
    soundPool.play(snd_hit, 0.2, 0.2, 0, 0, 1);
}

void soundsRelease()
{
  soundPool.release();
}

