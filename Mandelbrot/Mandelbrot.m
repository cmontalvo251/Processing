purge

xsize = 600;
ysize = 600;

C = zeros(xsize,ysize);
Z = C;
ITERMAT = C;
iter = 0;
for idx = 1:xsize
    a = -3.0 + 6.0*(idx-1)/(xsize-1);
    for jdx = 1:ysize
        b = -3.0 + 6.0*(jdx-1)/(ysize-1);
        C(jdx,idx) = a + b*1i;
        Z(jdx,idx) = 0;
    end
end

while 1
    spy(ITERMAT)
    iter = iter + 1;
    Z = Z.^2 + C;
    ITERMAT(abs(Z)>2.0) = iter;
    drawnow
end