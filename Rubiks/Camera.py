def cameraUpdate():
    #Set up the camera - first is the camera position - use mouseX to rotate about the Y axis (X and Z will change)
    #Use mouseY to rotate about the X axis (Y and Z will change)
    cameraZ = height/2
    #For now let's do some simple transformations
    mx = (2*PI/width)*mouseX - PI #(Range from 0 to width
    cameraXnew = -sin(mx)*cameraZ
    cameraYnew = 0
    cameraZnew =  cos(mx)*cameraZ
    #Then mouseY rotation or about the X axis - (Y and Z will change) 
    my = (2*PI/height)*mouseY - PI #(range from 0 to height)
    cameraXfinal = cameraXnew
    cameraYfinal = -sin(my)*cameraZnew
    cameraZfinal = cos(my)*cameraZnew
    d = sqrt(cameraXfinal**2 + cameraYfinal**2 + cameraZfinal**2)
    ##Scene will always be in the center
    SceneX = width/2
    SceneY = height/2
    #print mx,my,cameraXfinal,cameraYfinal,cameraZfinal,d
    camera(cameraXfinal+width/2, cameraYfinal+height/2, cameraZfinal, SceneX, SceneY, 0, 0, 1, 0);
    
