from Rubiks import *
from Camera import *

#Declare the Rubiks Cube - Object the number in the parentheses
#is the size of the cube and the size of the square
mycube = Rubiks(4,10)

def setup():
    #Create Canvas
    size(500,500,P3D)
    
def draw():
    ortho()
    
    #Make background black - there are no black squares on a rubiks cube
    background(100)
    
    #Draw Rubiks Cube - Probably Need a class for this
    stroke(0)
    strokeWeight(2)
    mycube.show()
    
    cameraUpdate()    
    