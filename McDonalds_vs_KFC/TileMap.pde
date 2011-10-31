class TileMap
{
  PImage[][] tiles = null;
  int _X, _Y;//tile's count of x/y
  int _dx, _dy;//tile 's width/height
  TileMap(String filename, int X, int Y, float scaleX, float scaleY)
  {
    _X = X;
    _Y = Y;
    PImage mother = loadImage(filename);
    PImageResize(mother, scaleX, scaleY);
    _dx = mother.width/X;
    _dy = mother.height/Y;

    tiles = new PImage[_X][_Y];
    for (int y=0;y<_Y;y++) 
      for (int x=0;x<_X;x++) 
      {
        tiles[x][y] = mother.get(x*_dx, y*_dy, _dx, _dy);
      }
  }
  PImage get(int x, int y) {
    return tiles[x][y];
  }
}

