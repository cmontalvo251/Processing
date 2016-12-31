from Cube import *

#Create The Rubiks Cube Class
class Rubiks:
    #Constructor
    def __init__(self,s,d):
        #Attributes
        self.NumX = s
        self.SizeOfSquare = d
        #Once we have the size of the cube we need to make the individual
        #Cubes so we need a triple for loop around NumX
        self.Cubes = []
        #Position of cube is (idx*SizeOfSquare - sizeOfSquare
        for idx in range(0,self.NumX):
            x = idx*self.SizeOfSquare - ((self.NumX-1)/2.0)*self.SizeOfSquare
            #Reset the layers
            self.layer = []
            for jdx in range(0,self.NumX):
                y = jdx*self.SizeOfSquare - ((self.NumX-1)/2.0)*self.SizeOfSquare
                #Reset the columns
                self.col = []
                for kdx in range(0,self.NumX):
                    z = kdx*self.SizeOfSquare - ((self.NumX-1)/2.0)*self.SizeOfSquare
                    newCube = Cube(x,y,z,self.SizeOfSquare)
                    #Append each Cube to a Column
                    self.col.append(newCube)
                    #print x,y,z
                #Append Each Column to a Layer
                #print self.col
                self.layer.append(self.col)
            #Append each layer to the array of Cubes
            self.Cubes.append(self.layer)
        if self.NumX == 1:
            self.Cubes = [[[Cube(0,0,0,self.SizeOfSquare)]]]
        #print self.Cubes
            
    def show(self):
        #In this show routine we will create a triple for loop
        #and draw cubes in space thing is every cube in my opinion 
        #should have a class itself
        
        #First put the rubiks cube in the center of the screen
        translate(width/2,height/2,0)
        numDrawn = 0
        for idx in range(0,self.NumX):
            for jdx in range(0,self.NumX):
                for kdx in range(0,self.NumX):
                    #Optimize? - Figure out a better way to do this - What we actually need to do is in self.Cubes simple make a Cube sure because initialization is fine but during rendering say in the show 
                    #routine we simply check for self.inside == 1 and if it's 1 we don't draw it
                    #The criteria is if abs(x) < xmax and abs(y) < ymax and abs(z) < zmax we don't draw it so we set self.inside = 1
                    #But for the time being this will work
                    DONTDRAW = 0 
                    if abs(self.Cubes[idx][jdx][kdx].x) != (self.NumX-1)/2.0*self.SizeOfSquare:
                        DONTDRAW += 1
                    if abs(self.Cubes[idx][jdx][kdx].y) != (self.NumX-1)/2.0*self.SizeOfSquare:
                        DONTDRAW += 1
                    if abs(self.Cubes[idx][jdx][kdx].z) != (self.NumX-1)/2.0*self.SizeOfSquare:
                        DONTDRAW += 1
                    if DONTDRAW < 3:
                        self.Cubes[idx][jdx][kdx].show()
                        numDrawn += 1
        print numDrawn,self.NumX**3,self.NumX**3-numDrawn
        translate(-width/2,-height/2,0)