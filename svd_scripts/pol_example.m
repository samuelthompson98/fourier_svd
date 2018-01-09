% function pol_example

% create poloidal phases across centre column 
clear all;

f0 = 500;
f1 = 2500;
fs = 100000;
dt = 1/fs;
tmax = 1000*1/f0; % 1000 periods
df = 1/tmax;
t  = (0:dt:tmax).';
Ncoils = 40;

n1 = 3;
n2 = 10;
for i=1:Ncoils
  x(i).data        = 1;
  x(i).phi         = 2*pi*(i-1)/Ncoils;
  x(i).signal(:,1) = t;
  x(i).signal(:,2) = sin(2*pi*f0*t + n1*x(i).phi) + 1.0*sin(2*pi*f1*t + n2*x(i).phi);
end;

% X  = specf(x,0,1e+4);
flow = 0; fhigh = 1e+3;
specf;

V  =tor_vcol(xdat,time, 0, f0);
V  =tor_vcol(real(y1dat), time, 0, f0);
V  =tor_vcol(real(y2dat), time, 0, f1);

return;

V  =tor_xcol(x,f0, tmax/2);
V1 =tor_xcol(y1,f0,tmax/2);
V2 =tor_xcol(y2,f1,tmax/2);

return;







X  = spec(x,0,fs/2);
render(X(1));
U  = tor_col(x,0,f0);

% manually filter over f0 and 2*f0 separately
% freq/. interval a function of windowing size
df  = 1e+3;
flo_index = min(find(X(1).f > f0-2*df))
fhi_index = max(find(X(1).f < f0+2*df))
NF = length(X(1).f);
X1 = X
NX = size(X1,1)
for i=1:NX
  X1(i).F(1:flo_index,:)  = 0;
  X1(i).F(fhi_index:NF,:) = 0;
end;

flo_index = min(find(X(1).f > 2*f0-2*df))
fhi_index = max(find(X(1).f < 2*f0+2*df))
X2 = X
for i=1:NX
  X2(i).F(1:flo_index,:)  = 0;
  X2(i).F(fhi_index:NF,:) = 0;
end;

% X1  = spec(x,f0-2*df,f0+2*df);
% X2  = spec(x,2*f0-2*df,2*f0+2*df);
render(X1(1))
render(X2(1))

% compute ifft for each time slice
y  = ispec(X)
y1 = ispec(X1)
y2 = ispec(X2)

rendert(y(1),tmax/2)
V  =tor_xcol(y,f0,tmax/2);
V1 =tor_xcol(y1,f0,tmax/2);
V2 =tor_xcol(y2,2*f0,tmax/2);

return;
