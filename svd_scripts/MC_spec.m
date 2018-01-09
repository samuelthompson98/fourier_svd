% ==========================================================
function X=MC_spec(x,winl)

% calculates specotrgam of specified shot and items
%
% Matthew Hole, Jan 2002
% All data of form 
% (coil,i,1)=time
% (coil,i,2)=data

[Nstruct, Ncoils, Nx] = size(x);

% Hamming window normalization - should be independant of window length
% MJH 16/07/2006 - possibly requires adressing, maybe end point problem
norm = 3.8117;

for i=1:Ncoils
  if x(i).data
    xin(:,:)  = x(i).signal(:,:);
    X(i).data = 1;
    [X(i).F, X(i).f, X(i).t, X(i).dt, X(i).df] = getspec(xin,1, winl, norm);
  else
    X(i).data = 0;
  end;
end;

return;



