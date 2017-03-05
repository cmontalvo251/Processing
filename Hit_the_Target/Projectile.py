class Projectile:
    def __init__(self,WINDOWSIZE):
        self.X0 = 0.1*WINDOWSIZE
        self.Y0 = 0.1*WINDOWSIZE
        self.X = self.X0
        self.Y = self.Y0
        self.Z = 0.1*WINDOWSIZE
        self.Azimuth = -99
        self.Elevation = -99
        self.SizeOfSquare = WINDOWSIZE*0.01
    def getAzimuth(self):
        self.Azimuth = atan2(self.Y-self.Y0,self.X-self.X0)
    def show(self):
        self.drawbox()
        
    def drawbox(self):
        ##Ok first we translate to the center of this cube
        translate(self.X,self.Y,self.Z)
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
        translate(-self.X,-self.Y,-self.Z)