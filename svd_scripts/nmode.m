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

i_tslice = min(find(X(1).t>= tslice));
tslice   = X(1).t(i_tslice);

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

%  MJH 17/07/2006 - hardwire Nc = 20
Nc = 20;
%  MJH 16/05/2013 - hardwire Nc = 19 temporarily
% Nc = 19;
% Nc = 40;
disp(['alias number is Nc = ',num2str(Nc)]);

for i=1:Nitem   X(i).Nc = Nc; end;
Z   = loopf(X,tslice,flow,fhigh,nsimul);
Z.t = tslice;
Z.Nc= Nc;

return;
