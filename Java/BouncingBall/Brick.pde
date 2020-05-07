public class Brick
{
  public int Width;
  public int Height;
  public color Color;
  public int X;
  public int Y;

  public Brick(int wid, int hei)
  {
    Width = wid;
    Height = hei;
    Color = color(random(256), random(256), random(256));
  }

  public Brick(int wid, int hei, color col)
  {
    Width = wid;
    Height = hei;
    Color = col;
  }

  public void Draw(int x, int y)
  {
    X = x;
    Y = y;
    fill(Color);
    rect(x, y, Width, Height, 3, 3, 3, 3);
    fill(color(255));
  }
}
