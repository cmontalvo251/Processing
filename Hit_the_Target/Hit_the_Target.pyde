#Imports
from Target import Target
from Projectile import Projectile
from Camera import Camera

#Globals
WINDOWSIZE = 500

#Create instance of projectile class
myproj = Projectile(WINDOWSIZE)
mytarget = Target(WINDOWSIZE,myproj.SizeOfSquare)
mycamera = Camera(WINDOWSIZE)

def setup():
    #Create Canvas
    size(500,500,P3D)
    rectMode(CENTER)
        
def draw():
    #Make Background black
    background(100)
    
    #Render Ground Plane
    fill(0,255,255) #Make the ground plane 
    translate(WINDOWSIZE/2,WINDOWSIZE/2,0)
    rect(0,0,500,500)
    translate(-WINDOWSIZE/2,-WINDOWSIZE/2,0)
    
    #Render Target Circle
    fill(255,0,0) #Target circle is red
    strokeWeight(2)
    stroke(100)
    ellipse(mytarget.X,mytarget.Y,mytarget.Size,mytarget.Size)
    stroke(0)
    strokeWeight(1)
    
    #Render a line so that the target will show up in side view
    stroke(100)
    line(mytarget.X, mytarget.Y, 0, mytarget.X, mytarget.Y,WINDOWSIZE/10);
    
    #Render the Cube
    myproj.show()
    
    #Render Camera
    mycamera.render()
    
    #Now we play the game engine
    
    if myproj.Azimuth == -99:
        ortho() #Set view as orthographic.
        mycamera.setView(0,0)
        mycamera.setTitle("Click a Point to Set Azimuth")
        if (mousePressed):
            myproj.X = mouseX
            myproj.Y = mouseY
            myproj.getAzimuth()
    elif myproj.Elevation == -99:
        #perspective()
        mycamera.setView(180,90.1) #need 90.1 otherwise you can't see the cube or the target
        mycamera.setTitle("Click a Point to Set Elevation Angle")
    else:
        perspective()
                        

    #else if projectile.getElevation == -99
    #we set the view window to side view
    #Set the title to "Click a point to set the elevation angle"
    
    #else 
    #if projectile.getAltitude < 0
    #we set the view window to interactive and we launch the cube
    #projectile.dynamics()
    #else
    #We check and see if we won.
    #Game_Over
    #get a Mouse press and if it's inside the window, reset Azimuth and Elevation
    #projectile.reset() 
    
#checks to see if our x and y coordinate of our projectile is in the target
#def Game_Over():
    #if hit:
        #setTitle("YOU WIN! - Click Anywhere to Restart")
    #else
    #setTitle("YOU LOSE - Click Anywhere to Restart!!")
    #