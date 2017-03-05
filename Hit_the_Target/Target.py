from random import randint

class Target:
    def __init__(self,WINDOWSIZE,Size):
        self.Size = Size*10
        self.X = randint(WINDOWSIZE/2,WINDOWSIZE-self.Size)
        self.Y = randint(WINDOWSIZE/2,WINDOWSIZE-self.Size)
    