#Create a Cube Class
class Cube:
    #Constructor
    def __init__(self,x,y,z,SizeOfSquare):
        #Attributes
        self.x = x
        self.y = y
        self.z = z
        self.SizeOfSquare = SizeOfSquare
    def show(self):
        #print self.x,self.y,self.z
        #For now let's just put an ellipse in here
        #print self.x,self.y,self.z
        rectMode(CENTER);
        self.drawbox()
        
    def drawbox(self):
        ##Ok first we translate to the center of this cube
        translate(self.x,self.y,self.z)
        #Now we need to make the left side which is blue but we'll worry about colors later
        
        #LEFT SIDE
        fill(0,0,255) #blue
        translate(-self.SizeOfSquare/2,0,0)
        rotateY(PI/2)
        rect(0,0,self.SizeOfSquare,self.SizeOfSquare);
        rotateY(-PI/2)
        translate(self.SizeOfSquare/2,0,0)
        
        #RIGHT SIDE
        fill(0,255,0) #green
        translate(self.SizeOfSquare/2,0,0)
        rotateY(-PI/2)
        rect(0,0,self.SizeOfSquare,self.SizeOfSquare);
        rotateY(PI/2)
        translate(-self.SizeOfSquare/2,0,0)
        
        #TOP SIDE
        fill(255) #white
        translate(0,-self.SizeOfSquare/2,0)
        rotateX(PI/2)
        rect(0,0,self.SizeOfSquare,self.SizeOfSquare);
        rotateX(-PI/2)
        translate(0,self.SizeOfSquare/2,0)
        
        #BOTTOM SIDE
        fill(255,255,0) #yellow
        translate(0,self.SizeOfSquare/2,0)
        rotateX(PI/2)
        rect(0,0,self.SizeOfSquare,self.SizeOfSquare);
        rotateX(-PI/2)
        translate(0,-self.SizeOfSquare/2,0)
        
        #FRONT SIDE
        fill(255,0,0) #red
        translate(0,0,self.SizeOfSquare/2)
        rect(0,0,self.SizeOfSquare,self.SizeOfSquare);
        translate(0,0,-self.SizeOfSquare/2)
        
        #BACK SIDE
        fill(255,150,0) #orange
        translate(0,0,-self.SizeOfSquare/2)
        rect(0,0,self.SizeOfSquare,self.SizeOfSquare);
        translate(0,0,self.SizeOfSquare/2)
        
        #Then translate back to normal
        translate(-self.x,-self.y,-self.z)