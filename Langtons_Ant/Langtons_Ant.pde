//Langton's Ant

int[][] antpile;
int[] direction = {1,0};
int gamesize1 = 750;
int gamesize2 = 500;
int lifefactor1 = 5; //Size of game must be lifesize*lifefactor
int lifefactor2 = 5;
int lifesize1 = gamesize1/lifefactor1;
int lifesize2 = gamesize2/lifefactor2;
int[] ant = {lifesize1/2,lifesize2/2};
int iteration = 0;

void setup()
{
  size(750,500);
  background(255);
  antpile = new int[lifesize1][lifesize2];
}


void draw()
{
  iteration++;
  //print(float(mouseY)/float(gamesize2)+"\n");
  int M = int(1000 - 1000*float(mouseY)/float(gamesize2));
  frameRate(M);
  background(255);
  spy(antpile,ant);
  fill(0,0,0);
  text("Iteration Number = "+iteration,lifesize1*0.2,lifesize2*0.5);
  text("Frame Rate = "+M,lifesize1*0.2,lifesize2*0.25);
  //While the ant moves forward the color of the tile changes color
  if (antpile[ant[0]][ant[1]] == 0)
  {
   antpile[ant[0]][ant[1]] = 1; 
  }
  else
  {
   antpile[ant[0]][ant[1]] = 0; 
  }
  //Move the ant forward
  ant = plus(ant,direction);
  //Check what the cell is and then turn the ant left or right
  int x;
  int y;
  if (antpile[ant[0]][ant[1]] == 0)
  {
   //Turn Ant left
   x = direction[1];
   y = -direction[0];
  }
  else
  {
   //Turn right
   x = -direction[1];
   y = direction[0];
  }
  direction[0] = x;
  direction[1] = y;
}

int[] plus(int[] first,int[] second)
{
 int[] sum = {0,0};
 for (int i = 0;i<2;i++)
  {
     sum[i] = first[i] + second[i];
  } 
  return sum;
}

void spy(int[][] life,int[] ant)
{
 for (int i = 0;i<lifesize1;i++)
  {
    for (int j = 0;j<lifesize2;j++)
    {
      if (life[i][j] == 1)
      {
        fill(0,255,255);
        rect(lifefactor1*i,lifefactor2*j,lifefactor1,lifefactor2);
      }
      if ((i == ant[0]) && (j == ant[1]))
      {
       fill(0,0,255);
       rect(lifefactor1*i,lifefactor2*j,lifefactor1,lifefactor2);
      }
    }
  }
}
