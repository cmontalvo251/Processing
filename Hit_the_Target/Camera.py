class Camera:
    def __init__(self,WINDOWSIZE):
        self.Size = WINDOWSIZE*0.05
        self.Y = WINDOWSIZE
        self.WINDOWSIZE = WINDOWSIZE
        self.Az = 0
        self.El = 0
        
    #Sets a title of the window
    ###Need to fix this so it renders at 0,0 in sideview. Probably
    #just need to have X,Y coordinates of test update when Az and El change
    def setTitle(self,title_text):
        textSize(self.Size)
        fill(0,0,0)
        #rotateZ(PI/2)
        rotateX(-PI/2)
        translate(0,self.WINDOWSIZE*0.4,0)
        text(title_text,0,0)
        translate(0,-self.WINDOWSIZE*0.4,0)
        rotateX(PI/2)
        #rotateZ(-PI/2)
               
    def setView(self,Az,El):
        self.Az = Az*PI/180.0
        self.El = El*PI/180.0
        
    def render(self):
        #Set up the camera - first is the camera position - use mouseX to rotate about the Y axis (X and Z will change)
        #Use mouseY to rotate about the X axis (Y and Z will change)
        cameraZ = height
        #For now let's do some simple transformations
        #mx = (2*PI/width)*mouseX - PI #(Range from 0 to width
        mx = self.Az
        cameraXnew = -sin(mx)*cameraZ
        cameraYnew = 0
        cameraZnew =  cos(mx)*cameraZ
        #Then mouseY rotation or about the X axis - (Y and Z will change) 
        #my = (2*PI/height)*mouseY - PI #(range from 0 to height)
        my = self.El
        cameraXfinal = cameraXnew
        cameraYfinal = -sin(my)*cameraZnew
        cameraZfinal = cos(my)*cameraZnew
        d = sqrt(cameraXfinal**2 + cameraYfinal**2 + cameraZfinal**2)
        ##Scene will always be in the center
        SceneX = width/2
        SceneY = height/2
        #print mx,my,cameraXfinal,cameraYfinal,cameraZfinal,d
        camera(cameraXfinal+width/2, cameraYfinal+height/2, cameraZfinal, SceneX, SceneY, 0, 0, 1, 0);
    
    
    
    
    