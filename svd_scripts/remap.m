function [y] = remap(x)

% MJH 07/06
% remap to remove rotations and reflections
% takes radian angles

Ncoils = size(x,2);

% arrange coils sequentially
x     = x*180/pi;
xsort = sort(x);

% form vector difference
xdiff         = diff(xsort);
xdiff(Ncoils) = xsort(1)+360 - xsort(Ncoils);

% find smallest difference angle 
[x3, index ] = sort(xdiff);

dmin = index(1);

% determine whether right or left circulate
% circulate = -1 <=> Left
% circulate = +1 <=> Right

if (dmin~=1)&(dmin~=Ncoils)
    if (xdiff(dmin-1)<xdiff(dmin+1)) 
        circulate = -1;
    elseif (xdiff(dmin-1)>=xdiff(dmin+1))         
        circulate = +1;
    end;
elseif dmin==1
    if (xdiff(Ncoils)<xdiff(2)) 
        circulate = -1;
    elseif (xdiff(Ncoils)>=xdiff(2))         
        circulate = +1;
    end;
elseif dmin==Ncoils
    if (xdiff(Ncoils-1)<xdiff(1)) 
        circulate = -1;
    elseif (xdiff(Ncoils-1)>=xdiff(1))         
        circulate = +1;
    end;
end;

k  = 1;
if circulate == 1
    for i=dmin : Ncoils
        y(k) =  xsort(i) - xsort(dmin);
        k = k+1;
    end;        
    for i= 1 : dmin -1
        y(k) =  xsort(i)+360 - xsort(dmin);
        k = k+1;
    end;        
else
    dmin            = dmin+1;
    if dmin<=Ncoils
        for i=dmin:-1:1
            y(k) =  xsort(i) - xsort(dmin);
            k = k+1;
        end;        
    elseif dmin>Ncoils
        xsort(Ncoils+1) = xsort(1)+360;
        for i=dmin:-1:2
            y(k) =  xsort(i) - xsort(dmin);
            k = k+1;
        end;        
    end;        
    for i=Ncoils : -1 : dmin+1
        y(k) =  (xsort(i)-360) - xsort(dmin);
        k = k+1;
    end; 
    y = abs(y);
end;    

y     = y*pi/180;


return;