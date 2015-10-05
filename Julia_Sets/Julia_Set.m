
purge

xsize = 600;
ysize = 600;

C = -0.4+0.6*1i;
Z = zeros(xsize,ysize);
ITERMAT = zeros(xsize,ysize);
iter = 0;
for idx = 1:xsize
    a = -3.0 + 6.0*(idx-1)/(xsize-1);
    for jdx = 1:ysize
        b = -3.0 + 6.0*(jdx-1)/(ysize-1);
        Z(jdx,idx) = a+b*1i;
    end
end

while 1
    mesh(ITERMAT)
    view(0,90)
    iter = iter + 1;
    Z = Z.^2 + C;
    ITERMAT(abs(Z)>2.0) = iter;
    drawnow
end