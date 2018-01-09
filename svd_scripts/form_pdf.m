function [X]= form_pdf(x)

x = x.';
NP= 10;
dx= (max(x)-min(x))/(NP-1);

temp =  min(x):dx:max(x);

X(:,1)    = temp.';
X(1:NP,2) = 0.0;

X = bin_point(x, X);
return;


% ======================================================================
function [Px] = bin_point(x, Px,varargin)
% bin point linearly
% NB: ALL bin points must be equi-spaced within machine precision (06/04/04).

clear index;
dx      = Px(2,1) - Px(1,1);
NP      = size(Px,1);

index   = find(x(:,1)<= Px(1,1)+dx/2);
Px(1,2) = Px(1,2) + size(index,1);

for i=2:NP-1
  clear index;
  index = find((x(:,1) > Px(i,1)-dx/2) & (x(:,1)<= Px(i,1)+dx/2));
  Px(i,2) = Px(i,2) + size(index,1);   % add number of points
  
end;

clear index;
index   = find(x(:,1) > Px(NP,1)-dx/2);
Px(NP,2) = Px(NP,2) + size(index,1);

return;

