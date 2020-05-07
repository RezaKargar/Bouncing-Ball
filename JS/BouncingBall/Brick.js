class Brick
{


  constructor( wid, hei, col)
  {
    this.Width = wid;
    this.Height = hei;
    if (col === undefined)
    {
      this.Color = color(random(256), random(256), random(256));
    } else {
      this.Color = col;
    }
  }

  Draw(x, y)
  {
    this.X = x;
    this.Y = y;
    fill(this.Color);
    rect(x, y, this.Width, this.Height, 3, 3, 3, 3);
    fill(color(255));
  }
}
