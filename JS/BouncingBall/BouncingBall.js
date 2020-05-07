
var circleX, circleY;
var directionX, directionY, speed, circleRadius;
var bricks = [];
var brickWidth, brickHeight, brickCountInRow;
var platformX, platformY, platformWidth, platformHeight, platformSpeed;

var startTime;

var isGameStarted, isGameOver, isPlayerWon, isTimerFinished;

var mySound;

function preload()
{
  soundFormats('mp3');
  mySound = loadSound('assets/Rainbows');
}

function setup()
{
  resizeCanvas(602, 500);
}

function draw() 
{


  if (isTimerFinished && keyIsDown(RIGHT_ARROW) && platformX + platformWidth + 10 <= width - circleRadius / 2)
  {
    platformX += platformSpeed;
  } else if (isTimerFinished && keyIsDown(LEFT_ARROW) && platformX >= circleRadius / 2)
  {
    platformX -= platformSpeed;
  }

  background(150);

  if (!isGameStarted)
  {

    textSize(30);
    rect((width / 2) - (width / 5), (height / 2) - (height / 7), 200, 70, 10);
    fill('#59C961');
    text("Start", (width / 2) - (width / 10), (height / 2) - (height / 17));
    fill('#FFFFFF');

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
      fill('#FFFDDD');
    }
  } else
  {
    if (!mySound.isPlaying())
    {
      mySound.play();
    }

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
        fill('rgb(255, 0, 0)');
        text(3 - abs(startTime - second()), (width / 2) - (width / 10), (height / 2) - (height / 17));
        fill('#FFFFFF');
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


function mousePressed()
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

function InitialGame()
{
  bricks = [];
  isGameOver = false;
  isGameStarted = true;
  isPlayerWon = false;
  isTimerFinished = false;


  startTime = second();


  circleRadius = 20;

  brickWidth = 100;
  brickHeight = 25;
  brickCountInRow = 6;

  circleX = random(10, width - 10 - (circleRadius / 2)); 
  circleY = random(80, height / 2 - (circleRadius / 2));

  directionX = +1;
  directionY = +1;
  speed = 4;
  platformSpeed = 5;
  InitialBricks();
  InitialPlatform();
}

function DrawBricks()
{
  var brickNumberInRow;
  var x, y = 0;
  var brick;

  for (var i=0; i < bricks.length; i++)
  {
    brick = bricks[i];


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

function CheckCollision()
{
  var brick;
  var collied = false;

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

  for (var i = 0; i < bricks.length; i++)
  {
    brick = bricks[i];
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
      bricks[i] = null;
      return;
    }
  }
}

function InitialBricks()
{
  var bricksCount = floor(random(12, 19));

  for (var i = 0; i < bricksCount; i++)
  {
    bricks.push(new Brick(brickWidth, brickHeight));
  }

  var nullBricksCount = floor(random(bricksCount / 3));

  for (var _ = 0; _ < nullBricksCount; _++)
  {
    var i = floor(random(bricksCount));

    while ((i < 0 || i > bricks.length - 1) && bricks[i] == null)
    {
      i = floor(random(bricksCount+1));
    }

    bricks[i] = null;
  }
}

function InitialPlatform()
{
  platformHeight = 10;
  platformWidth = 100;

  platformY = height - 50;
  platformX = floor(random(width / 3, 2 * width / 3));
}

function DrawPaltform()
{
  rect(platformX, platformY, platformWidth, platformHeight, 7);
}


function GetBricksCount()
{
  var count = 0;

  for (var i = 0; i < bricks.length; i++)
  {
    if (bricks[i] != null) count++;
  }
  return count;
}
