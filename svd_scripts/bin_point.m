function [Px] = bin_point(x, Px,varargin)
% bin point linearly
% NB: ALL bin points must be equi-spaced within machine precision (06/04/04).

% random check
check = 1;
if check==1  
  eps   = 1.0e-8;
  NP    = size(Px,1);
  index1= fix(rand*NP); index1 = max([ 2 index1]);
  index2= fix(rand*NP); index2 = max([ 2 index2]);
  % disp(['index1 = ',num2str(index1),', index2 = ',num2str(index2)]);
  dx    = Px(index1,1) - Px(index1-1,1);
  dx2   = Px(index2,1) - Px(index2-1,1);
   if abs(1-dx/dx2)>eps
       error(['Crash: bin_point called with non-uniformly spaced pdf bins']);
   end;
else 
    dx    = Px(2,1) - Px(1,1);
end;
    
% find bin index for each point
clear index;
% MJH 08/04/04 add all points less than least bin to lowest bin
% MJH 03/05/04 plus double bin pdf as bin is half size
index   = find(x(:,1)<= Px(1,1)+dx/2);
Px(1,2) = Px(1,2) + size(index,1);

for i=2:NP-1
  clear index;
  index = find((x(:,1) > Px(i,1)-dx/2) & (x(:,1)<= Px(i,1)+dx/2));
  Px(i,2) = Px(i,2) + size(index,1);   % add number of points
  
end;

clear index;
% MJH 08/04/04 add all points greater than top bin to top bin
% MJH 03/05/04 plus double bin pdf as bin is half size
index   = find(x(:,1) > Px(NP,1)-dx/2);
Px(NP,2) = Px(NP,2) + size(index,1);
return;
