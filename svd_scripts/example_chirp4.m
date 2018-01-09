

% function example_chirp4
% make sample chirp
% MJH 29 Oct 2006
% trial TFD's signal package ------------

% startup

clear all

global deltaf

deltaf = 50e+3/1.0e-3;

fs   = 1e+6
dt   = 1/fs;
f0(1)= 1e+5;
f0(2)= 1.3e+5
f0(3)= 0.7e+5
a(1) = 1;
a(2) = 0.8;
a(3) = 0.8;

phdiff(1)= 1.0;
phdiff(2)= 0.0;
phdiff(3)= 0.0;

noise(1) = 0;
noise(2) = 0;
noise(3) = 0;

Nt   = 10e+3;
Nt   = 200
tmin = 0;
tmax = Nt * dt;

for i=1:Nt
    t(i)   = tmin + (i-1)*dt;
    x(i,1) = t(i);
    x(i,2) = real(a(1) * exp(1i*2*pi*fchirp(f0(1), t(i)-tmin)*t(i)) * 2*(0.5-noise(1)*rand) + ...
                  a(2) * exp(1i*2*pi*fchirp(f0(2), t(i)-tmin)*t(i)) * 2*(0.5-noise(2)*rand) + ...
                  a(3) * exp(1i*2*pi*fchirp(f0(3), t(i)-tmin)*t(i)) * 2*(0.5-noise(3)*rand));
    y(i,1) = t(i);
    y(i,2) = real(a(1) * exp(1i*2*pi*fchirp(f0(1), t(i)-tmin)*t(i) + 1i * phdiff(1)) * 2*(0.5-noise(1)*rand) + ...
                  a(2) * exp(1i*2*pi*fchirp(f0(2), t(i)-tmin)*t(i) + 1i * phdiff(2)) * 2*(0.5-noise(2)*rand) + ...
                  a(3) * exp(1i*2*pi*fchirp(f0(3), t(i)-tmin)*t(i) + 1i * phdiff(3)) * 2*(0.5-noise(3)*rand));
end;


tnorm = 1e-3
fnorm = 1e+3
%  figure(1);
%  plot(x(:,1), x(:,2));

%fftspec = 0
%
%if fftspec

win = blackman(Nt,'periodic');
d = 1000;
i0= Nt/2;
for i=1:Nt
  win(i) =  exp(-(i-i0)^2/d);
  x(i,2) = x(i,2) * win(i);
  y(i,2) = y(i,2) * win(i);
end;

disp(['Calling getspec...']);
[Xs.F, Xs.f, Xs.t, Xs.dt, Xs.df] = getspec(x,1,50); 

% MJH 29/10/06 - Xc and Yc are Xc(1:Nt, 1:Nf)
% [Xc.F, Xc.t, Xc.f] =  wigner1(x(:,2), fs)
[Xc.F, Xc.t, Xc.f] = choi_williams1(x(:,2), fs, 1000000)

render_example(Xs,tnorm, fnorm)

figure
ptfddb(abs(Xc.F), 20, Xc.t, Xc.f, 12)

return;

% locate major frequency components and plot phase differences
tval   = 100e-6;
if0(1) = min(find(Xc.f>=110e+3));
if0(2) = min(find(Xc.f>=140e+3));
if0(3) = min(find(Xc.f>=80e+3));

% harmonics at frequencies 
Xc.f(if0(1))
Xc.f(if0(2))
Xc.f(if0(3))

nt   = size(Xc.t, 1);
nwin = 256; 

figure
plot(Xc.t, Xc.F(if0(1),:))

% remove phase ramp for choi_williams and wigner distributions
for i=1:nt
    phdiff(i,1) = angle(Xc.F(if0(1),i)/Yc.F(if0(1),i)) - 2*pi*(f0(1)-f0(1))*Xc.t(i);
    phdiff(i,2) = angle(Xc.F(if0(2),i)/Yc.F(if0(2),i)) - 2*pi*(f0(2)-f0(2))*Xc.t(i);
    phdiff(i,3) = angle(Xc.F(if0(3),i)/Yc.F(if0(3),i)) - 2*pi*(f0(3)-f0(3))*Xc.t(i);
end;

figure; hold on;
plot(Xc.t, unwrap(phdiff(:,1)/pi*180),'r-')
plot(Xc.t, unwrap(phdiff(:,2)/pi*180),'b-')
plot(Xc.t, unwrap(phdiff(:,3)/pi*180),'g-')



return
