function [Z]=nmode(X,tslice,nsimul,varargin)
%
% cacluates specotrgam of specified shot and items
%
% Matthew Hole, Jan 2002

% default frequency range - all
if size(varargin)==0
  flow  =min(X(2).f);
  fhigh =max(X(2).f);
else
% input item from variable input
  flow  =varargin{1};
  fhigh =varargin{2};
end;

% call mode code
str1=['calculating mode structure at t= ' ,num2str(tslice)];
str2=[' for ',num2str(flow),'< f < ',num2str(fhigh),' ...'];
disp([str1,str2]);

% calculate toroidal alias number
Nitem=size(X,2);
k=1;
for i=1:Nitem
  if X(i).data
    angle(k)=X(i).phi;
    k=k+1;
  end;
end;
% angle
% angle*180/pi
% Nc = alias(angle*180/pi);

%  MJH 17/07/2006 - hardwire Nc = 18
Nc = alias([0 180 270]);
% Nc = 36;
Nc = 5;
disp(['alias number is Nc = ',num2str(Nc)]);


for i=1:Nitem   X(i).Nc = Nc; end;
Z   = loopf(X,tslice,flow,fhigh,nsimul);
Z.t = tslice;
Z.Nc= Nc;

return;
