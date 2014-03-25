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
  AudioPlayer mCurrentAudio, mPrevAudio;

  void addAudio(String filename)
  {
    mAudios.add(minim.loadFile(filename));
  }

  AudioPlayer getRandomAudio()
  {
    return mAudios.get((int)random(mAudios.size()));
  }

  //
  void update()
  {
    if (mCurrentMovie != null && mCurrentMovie.available())
    {
      mCurrentMovie.read();
      //            mCurrentMovie.loadPixels();
    }

    boolean isRegionPressed = false;

    for (Button button: mButtons)
    {
      button.update(mCurrentMovie);
      isRegionPressed = isRegionPressed || button.isPressed;
    }

    updateRegion(isRegionPressed);
    updateButton(isRegionPressed);
  }

  void updateRegion(boolean isPressed)
  {
    if (isPressed)
    {
      if (mCurrentMovie == null || mCurrentMovie.time() >= mCurrentMovie.duration())
      {
        mCurrentMovie = getRandomVideo();
        mCurrentMovie.stop();
        mCurrentMovie.play();
      }
    }

    if (mCurrentMovie != null && mCurrentMovie.time() >= mCurrentMovie.duration())
    {
      mCurrentMovie = null;
    }
  }

  void updateButton(boolean isPressed)
  {
    if (isPressed)
    {
      if (mPrevAudio != null)
      {
        mPrevAudio = null;
      }
      if (mCurrentAudio == null)
      {
        mCurrentAudio = getRandomAudio();
        mCurrentAudio.rewind();
        mCurrentAudio.play();
      }
    }

    if (mCurrentAudio != null && mCurrentAudio.position() >= mCurrentAudio.length())
    {
      mCurrentAudio = null;
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
      text(mCurrentMovie.time(), x, y);
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
  ArrayList<Button> mButtons = new ArrayList<Button>();
}

