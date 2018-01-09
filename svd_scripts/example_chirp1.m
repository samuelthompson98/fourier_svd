

% function example_chirp
% make sample chirp

clear all

global deltaf

deltaf = 50e+3/1.0e-3;

dt   = 1e-6;
f0(1)= 1e+5;
f0(2)= 1.3e+5
f0(3)= 0.7e+5
a(1) = 1;
a(2) = 0.8;
a(3) = 0.8;

noise(1) = 0.0;
noise(2) = 0.0;
noise(3) = 0.0;

Nt   = 10e+3;
Nt   = 2000
tmin = 0;
tmax = Nt * dt;

for i=1:Nt
    t(i)   = tmin + (i-1)*dt;
    x(i,1) = t(i);
    x(i,2) = real(a(1) * exp(1i*2*pi*fchirp(f0(1), t(i)-tmin)*t(i)) * 2*(0.5-noise(1)*rand) + ...
                  a(2) * exp(1i*2*pi*fchirp(f0(2), t(i)-tmin)*t(i)) * 2*(0.5-noise(2)*rand) + ...
                  a(3) * exp(1i*2*pi*fchirp(f0(3), t(i)-tmin)*t(i)) * 2*(0.5-noise(3)*rand));
end;

fchirp(f0(1), t(1))
fchirp(f0(1), t(Nt))

tnorm = 1e-3
fnorm = 1e+3
%  figure(1);
%  plot(x(:,1), x(:,2));

%fftspec = 0
%
%if fftspec

disp(['Calling getspec...']);
[Xs.F, Xs.f, Xs.t, Xs.dt, Xs.df] = getspec(x,1, 128); 
render_example(Xs,tnorm, fnorm)
  

[Xs.F, Xs.f, Xs.t, Xs.dt, Xs.df] = getspec(x,1, 256); 
render_example(Xs,tnorm, fnorm)

    
disp(['Calling fgetspec...']);
[Xf.F, Xf.f, Xf.t, Xf.dt, Xf.df] = fgetspec(x,1, 64);
render_example(Xf,tnorm, fnorm)

% locate major frequency components and plot phase differences
if0(1) = min(find(Xf.f>=f0(1)))-0
if0(2) = min(find(Xf.f>=f0(2)))-0
if0(3) = min(find(Xf.f>=f0(3)))-0

% harmonics at frequencies 
Xf.f(if0(1))
Xf.f(if0(2))
Xf.f(if0(3))

nt   = size(Xf.t, 1);
nwin = 256; 

for i=1:nt
    phdiff(i,1) = angle(Xf.F(if0(2),i)/Xf.F(if0(1),i)) - 2*pi*(f0(2)-f0(1))*Xf.t(i);
    phdiff(i,2) = angle(Xf.F(if0(3),i)/Xf.F(if0(1),i)) - 2*pi*(f0(3)-f0(1))*Xf.t(i);
end;

figure; hold on;
plot(Xf.t, unwrap(phdiff(:,1)/pi*180),'r-')
plot(Xf.t, unwrap(phdiff(:,2)/pi*180),'b-')


% return

