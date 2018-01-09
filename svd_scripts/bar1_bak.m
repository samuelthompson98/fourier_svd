
function [h] = bar1(x,y, dx, ymin, rgb)

Nx = length(x)
for i=1:Nx
    xbox = [x(i)-dx/2   x(i)-dx/2   x(i)+dx/2   x(i)+dx/2];
    ybox = [ymin        y(i)        y(i)        ymin];
    h = fill(xbox,ybox,rgb,'LineStyle','none','EdgeColor',rgb);
end;
return;
