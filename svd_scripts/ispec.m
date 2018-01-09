% ==========================================================
function X=ispec(x)

% cacluates specotrgam of specified shot and items
%
% Matthew Hole, Jan 2002
% All data of form 
% (coil,i,1)=time
% (coil,i,2)=data

[Nstruct, Ncoils, Nx] = size(x);

h=figure;

for i=1:Ncoils
  if x(i).data
    disp([' Forming time series from spectrum of i = ',num2str(i)]);
    X(i) = get_time(x(i));
  else
    X(i).data = 0;
  end;
end;

return;

% ==========================================================
function [X]=get_time(x) 

[NF,Nt] = size(x.F);

X.data = 1;
if isfield(x,'phi')   X.phi  = x.phi;  end;

% perform ifft
% remove DC offset per time slice
x.F(1,:) = 0;
X.signal = ifft(x.F);

% window correction 
% win    = hann(nfft,'periodic');

df       = x.f(2,1)-x.f(1,1);
X.tF     = 1/df*(0:NF-1)/NF;
X.tevol  = x.t;
X.dtF    = 1/df;
X.dtevol = x.t(2)-x.t(1);

return;

