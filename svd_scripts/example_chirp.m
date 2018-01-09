

% function example_chirp
% make sample chirp

clear all

global deltaf

deltaf = 50e+3/1.0e-3;

dt   = 1e-6;
f0(1)= 1e+5;
f0(2)= 1.1e+5
f0(3)= 0.9e+5
a(1) = 1;
a(2) = 1;
a(3) = 1;

Nt   = 10e+3;
Nt   = 2000
tmin = 0;
tmax = Nt * dt;

for i=1:Nt
    t(i)   = tmin + (i-1)*dt;
    x(i,1) = t(i);
    x(i,2) = real(a(1) * exp(1i*2*pi*fchirp(f0(1), t(i)-tmin)*t(i)) + ...
                  a(2) * exp(1i*2*pi*fchirp(f0(2), t(i)-tmin)*t(i)) + ...
                  a(3) * exp(1i*2*pi*fchirp(f0(3), t(i)-tmin)*t(i)));
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
  
  %else
    
disp(['Calling fgetspec...']);
[Xf.F, Xf.f, Xf.t, Xf.dt, Xf.df] = fgetspec(x,1, 2*256);
render_example(Xf,tnorm, fnorm)
  %end;

% return


