import processing.sound.*;

float circleX, circleY;
int directionX, directionY, speed, circleRadius;
ArrayList<Brick> bricks;
int brickWidth, brickHeight, brickCountInRow;
int platformX, platformY, platformWidth, platformHeight, platformSpeed;

int startTime;

boolean isGameStarted, isGameOver, isPlayerWon, isTimerFinished;

SoundFile sound;

void setup()
{
  size(602, 500);
  sound = new SoundFile(this, "Rainbows.mp3");
}

void draw() 
{


  background(150);

  if (!isGameStarted)
  {

    textSize(30);
    rect((width / 2) - (width / 5), (height / 2) - (height / 7), 200, 70, 10);
    fill(#59C961);
    text("Start", (width / 2) - (width / 10), (height / 2) - (height / 17));
    fill(#FFFFFF);

    if (isGameOver)
    {
      text("Game Over!", (width / 2) - (width / 6), (height / 2) - (height / 5));
    } 

    if (isPlayerWon)
    {
      text("You Won!", (width / 2) - (width / 6), (height / 2) - (height / 5));
    }

    if (mouseX <=  (width / 2) - (width / 5) + 200 && mouseX >= (width / 2) - (width / 5)
      && mouseY <=  (height / 2) - (height / 7) + 70 && mouseY >= (height / 2) - (height / 7))
    {
      fill(#FFFDDD);
    }
  } else
  {

    if (circleX >= (width - (circleRadius / 2)) || circleX <= (circleRadius / 2))
    {
      directionX = -directionX;
    }

    if (circleY <= (circleRadius / 2))
    {
      directionY = -directionY;
    }

    if (circleY >= (height - (circleRadius / 2)))
    {
      if (!isGameOver)
      {
        sound.stop();
        sound = new SoundFile(this, "GameOver.mp3");
        sound.play();
      }

      isGameOver = true;
      isGameStarted = false;
      isPlayerWon = false;
    } 

    if (!isGameOver && GetBricksCount() != 0)
    {
      circle(circleX, circleY, circleRadius);
      DrawPaltform();

      CheckCollision();

      if (abs(startTime - second()) < 3)
      {
        textSize(100);
        fill(color(255, 0, 0));
        text(3 - abs(startTime - second()), (width / 2) - (width / 10), (height / 2) - (height / 17));
        fill(#FFFFFF);
      } else {
        isTimerFinished = true;
        circleX += (directionX)* speed;
        circleY += (directionY)* speed;
      }

      DrawBricks();
    } else if (GetBricksCount() == 0)
    {
      isPlayerWon = true;
      isGameOver = false;
      isGameStarted = false;
    }
  }
}


void mousePressed()
{
  if (!isGameStarted)
  {
    if (mouseX <=  (width / 2) - (width / 5) + 200 && mouseX >= (width / 2) - (width / 5)
      && mouseY <=  (height / 2) - (height / 7) + 70 && mouseY >= (height / 2) - (height / 7))
    {
      InitialGame();
    }
  }
}

void InitialGame()
{
  bricks = new ArrayList<Brick>();
  if (sound != null && sound.isPlaying())
  {
    sound.stop();
    sound = new SoundFile(this, "Rainbows.mp3");
  }
  sound.play();
  sound.loop();

  isGameOver = false;
  isGameStarted = true;
  isPlayerWon = false;
  isTimerFinished = false;


  startTime = second();

  brickWidth = 100;
  brickHeight = 25;
  brickCountInRow = 6;


  circleRadius = 20;
  
  circleX = random(10, width - 10 - (circleRadius / 2)); 
  circleY = random(80, height / 2 - (circleRadius / 2));
  directionX = +1;
  directionY = +1;
  speed = 4;
  platformSpeed = 30;
  InitialBricks();
  InitialPlatform();
}

void DrawBricks()
{
  int brickNumberInRow;
  int x, y = 0;
  Brick brick;

  for (int i=0; i < bricks.size(); i++)
  {
    brick = bricks.get(i);


    brickNumberInRow = i % brickCountInRow;
    x = brickNumberInRow * brickWidth;

    if (i!=0 && brickNumberInRow == 0)
    {
      x = 0;
      y += brickHeight;
    }

    if (brick == null) continue;

    brick.Draw(x, y);
  }
}

void CheckCollision()
{
  Brick brick;
  boolean collied = false;

  if (circleX + (directionX * speed) > platformX && 
    circleX + (directionX * speed) < platformX + platformWidth && 
    circleY > platformY && 
    circleY < platformY + platformHeight) 
  {
    directionX *= -1;
    collied = true;
  }

  if (circleX  > platformX && 
    circleX < platformX + platformWidth && 
    circleY + (directionY * speed) > platformY && 
    circleY + (directionY * speed) < platformY + platformHeight) 
  {
    directionY *= -1;
    collied = true;
  }

  if (collied) return;

  for (int i = 0; i < bricks.size(); i++)
  {
    brick = bricks.get(i);
    if (brick == null) continue;

    if (circleX  + (directionX * speed) >= brick.X  + 10 && 
      circleX    + (directionX * speed) <= brick.X + brickWidth  + 10 && 
      circleY   >= brick.Y && 
      circleY  <= brick.Y + brickHeight)
    {
      directionX *= -1;
      collied = true;
    }

    if (circleX >= brick.X  + 10 && 
      circleX  <= brick.X + brickWidth + 10 && 
      circleY  + (directionY * speed) >= brick.Y && 
      circleY   + (directionY * speed) <= brick.Y + brick.Height)
    {
      directionY *= -1;
      collied = true;
    }


    if (collied)
    {
      bricks.set(i, null);
      return;
    }
  }
}

void InitialBricks()
{
  int bricksCount = floor(random(12, 19));

  for (int i = 0; i < bricksCount; i++)
  {
    bricks.add(new Brick(brickWidth, brickHeight));
  }

  int nullBricksCount = floor(random(bricksCount / 3));

  for (int _ = 0; _ < nullBricksCount; _++)
  {
    int i = floor(random(bricksCount));

    while ((i < 0 || i > bricks.size() - 1) && bricks.get(i) == null)
    {
      i = floor(random(bricksCount+1));
    }

    bricks.set(i, null);
  }
}

void InitialPlatform()
{
  platformHeight = 10;
  platformWidth = 100;

  platformY = height - 50;
  platformX = floor(random(width / 3, 2 * width / 3));
}

void DrawPaltform()
{
  rect(platformX, platformY, platformWidth, platformHeight, 7);
}


int GetBricksCount()
{
  int count = 0;

  for (int i = 0; i < bricks.size(); i++)
  {
    if (bricks.get(i) != null) count++;
  }
  return count;
}


void keyPressed()
{
  if (!isTimerFinished || key != CODED) return;
  
  if (keyCode == RIGHT && platformX + platformWidth + 10 <= width - circleRadius / 2)
  {
    platformX += platformSpeed;
  } else if (keyCode == LEFT && platformX >= circleRadius / 2)
  {
    platformX -= platformSpeed;
  }
}
