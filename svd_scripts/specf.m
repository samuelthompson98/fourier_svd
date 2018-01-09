% ==========================================================
% specf(x,flow,fhigh)

% cacluates specotrgam of specified shot and items
%
% Matthew Hole, Jan 2002
% All data of form 
% (coil,i,1)=time
% (coil,i,2)=data

[Nstruct, Ncoils, Nx] = size(x)

h=figure;

for i=1:Ncoils
  xdat(:,i) = x(i).signal(:,2);
end;

Nfft = size(x(1).signal,1);
fs   = 1/(x(i).signal(2,1)-x(i).signal(1,1));
f    = fs*(0:fix(Nfft/2))/Nfft;
time = x(1).signal(:,1);
X    = fft(xdat,Nfft);
ydat = ifft(X,Nfft);

size(X)
     size(ydat)
     size(xdat)

figure
i = 10;

h(1) = figure; hold on;
plot(time,xdat(:,i),'b');
plot(time,ydat(:,i),'r');

h(2) = figure; hold on;
Nf = length(f); 
plot(f, abs(X(1:Nf,i)));

% band pass filter frequency components
X1 = X;
flo_index = min(find(f>flow));
fhi_index = max(find(f<fhigh));

X1(1:flo_index,:)              = 0;
X1(fhi_index:Nfft-fhi_index,:) = 0;
X1(Nfft - flo_index:Nfft)      = 0;
y1dat = ifft(X1,Nfft);

% band pass filter frequency components
flow  = 2e+3;
fhigh = 3e+3;

X2 = X;
flo_index = min(find(f>flow));
fhi_index = max(find(f<fhigh));

X2(1:flo_index,:)              = 0;
X2(fhi_index:Nfft-fhi_index,:) = 0;
X2(Nfft - flo_index:Nfft)      = 0;
y2dat = ifft(X2,Nfft);

figure(h(1)); hold on;
plot(time,y2dat(:,i),'g');

figure(h(2)); hold on;
plot(f, abs(X2(1:Nf,i)),'g');


return;
