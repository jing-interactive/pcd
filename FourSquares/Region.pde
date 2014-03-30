import processing.video.*;
import java.util.Map;

// Region has several Buttons
int gPinCounter = 0;

class Region
{
  class VertexData
  {
    VertexData(String filename)
    {
      for (String line : loadStrings("vertex/" + filename))
      {
        int commaIndex = line.indexOf(",");
        if (commaIndex != -1)
        {
          int assignIndex = line.indexOf("=");
          String key = line.substring(0, assignIndex);
          int x = int(line.substring(assignIndex + 2, commaIndex));
          int y = int(line.substring(commaIndex + 1, line.length() - 1));
          //                    println(key + ":" + x + ", " + y);
          mVertices.put(key, new PVector(x, y));
        }
      }
    }
    Map<String, PVector> mVertices = new HashMap<String, PVector>();
  }

  VertexData mVertexData;
  ArrayList<Button> mButtons = new ArrayList<Button>();
  boolean mIsActivated = false;

  // video
  ArrayList<Movie> mMovies = new ArrayList<Movie>();
  Movie mCurrentMovie;

  void addVideo(String filename)
  {
    mMovies.add(new Movie(self, filename));
  }

  Movie getRandomVideo()
  {
    return mMovies.get((int)random(mMovies.size()));
  }

  // audio
  ArrayList<AudioPlayer> mAudios = new ArrayList<AudioPlayer>();
  int mCurrentAudio = -1;
  float[] mGains = new float[100]; // HACK:

  void fadeOutAudio(int audioId)
  {
    Ani.to(this, kAudioFadeTime, "mGains[" + audioId + "]", -60);
    //    println("fadeOut: "+audioId);
  }

  void fadeOut()
  {
    for (Button button: mButtons)
    {
      button.fadeOut();
    }
  }

  void fadeIn()
  {
    for (Button button: mButtons)
    {
      button.fadeOut();
    }
  }

  void setColor(color clr)
  {
    for (Button button: mButtons)
    {
      button.setColor(clr);
    }
  }

  void addAudio(String filename)
  {
    mAudios.add(minim.loadFile(filename));
  }

  int getRandomAudio()
  {
    return (int)random(mAudios.size());
  }

  // HACK
  void updateCenter()
  {
    if (mCurrentMovie == null)
    {
      mCurrentMovie = getRandomVideo(); // TODO
      mCurrentMovie.loop();
    }

    if (mCurrentMovie.available())
    {
      mCurrentMovie.read();
    }

    for (Button button: mButtons)
    {
      button.update(mCurrentMovie);
      button.updateCenter();
    }
  }

  boolean mIsPressed;
  boolean mIsHit;

  int mAnimType = 0;

  //
  void update()
  {
    mIsPressed = false;
    mIsHit = false;

    if (mCurrentMovie != null && mCurrentMovie.available())
    {
      mCurrentMovie.read();
    }

    for (Button button: mButtons)
    {
      button.update(mCurrentMovie);
      button.updateArduino();
      if (button.isPressed) mIsPressed = true;
      if (button.isHit) mIsHit = true;
    }

    updateRegion();
    updateButton();

    if (mCurrentMovie != null || mIsPressed)
    {
      mIsActivated = true;
    }
    else
    {
      mIsActivated = false;
    }
  }

  void updateRegion()
  {
    if (mCurrentMovie != null && mCurrentMovie.time() >= mCurrentMovie.duration())
    {
      mCurrentMovie = null;
    }

    if ((mAnimType == 0 && mIsHit) ||
      (mAnimType == 1 && mIsPressed))
    {
      if (mCurrentMovie == null)
      {
        mCurrentMovie = getRandomVideo();
        mCurrentMovie.stop();
        mCurrentMovie.play();
      }
    }
  }

  void updateButton()
  {
    // zeroness
    if (mCurrentAudio != -1 && mAudios.get(mCurrentAudio).position() >= mAudios.get(mCurrentAudio).length())
    {
      mCurrentAudio = -1;
    }

    if (mIsHit)
    {
      if (mCurrentAudio != -1)
      {
        fadeOutAudio(mCurrentAudio);
      }
      int audio = getRandomAudio();
      if (audio == mCurrentAudio)
      {
        audio = (mCurrentAudio + 1) % mAudios.size();
      }
      mCurrentAudio = audio;
      // TODO
      mGains[mCurrentAudio] = 0;
      mAudios.get(mCurrentAudio).rewind();
      mAudios.get(mCurrentAudio).play();
    }

    int id = 0;
    for (AudioPlayer audio: mAudios)
    {
      audio.setGain(mGains[id]);
      id++;
    }
  }

  void draw2D(int x, int y)
  {
    for (Button button: mButtons)
    {
      button.draw2D(x, y);
    }

    if (mCurrentMovie != null)
    {
      text(mCurrentMovie.time(), x + 50, y);
    }
  }

  void draw1D(int x, int y)
  {
    for (Button button: mButtons)
    {
      x = button.draw1D(x, y);
    }
  }

  Region(String regionName)
  {
    println(regionName+":");
    mVertexData = new VertexData(regionName);

    Button aButton = null;
    for (String line : loadStrings("vertex/" + regionName+".order"))
    {
      if (line.length() == 0) continue;

      if (line.charAt(0 ) == ':')
      {
        if (aButton != null)
        {
          aButton.markEnd();
        }
        aButton = new Button(line.substring(1, 3), gPinCounter);
        gPinCounter++;
        //                println(aButton);
        mButtons.add(aButton);
      }
      else
      {
        String vertexId = line;
        PVector vertex = mVertexData.mVertices.get(vertexId);
        aButton.addVertex(vertex);
      }
    }
    aButton.markEnd();

    printArray(mButtons);
    print("\n");
  }
}

