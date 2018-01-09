
clear all


tmin = 0e-3;
tmax = 100e-3;
dt   = 2e-6;
t = tmin:dt:tmax;
Nt= length(t);

% coil positions
theta   = 0;
phi     = 6/180*pi;

% tearing modes
f1      = 1;
n1      = 0;
PHI1    = 10/180*pi;
wnorm   = 100.9032423e+3 *2 * pi;
w1      = 0.1 * wnorm

f2      = 1;
n2      = 0;
PHI2    = 40/180*pi;
w2      = 0.3 * wnorm;

noise   = 0.04;

xmd.omt(1).data           = 1 ;
xmd.omt(1).phi            = 0.1047;
xmd.omt(1).signal(:,1)    = t.';
xmd.omt(1).signal(1:Nt,2) = 0.0;

for i=1:Nt

    xmd.omt(1).signal(i,2) =  f1 * sin( - n1* xmd.omt(1).phi  + w1*t(i) + PHI1) + ...
                              f2 * sin( - n2* xmd.omt(1).phi  + w2*t(i) + PHI2) + 2* (rand-0.5) * noise;;
                          
    % xmd.omt(1).signal(i,2) =  xmd.omt(1).signal(i,2) + 0.1* xmd.omt(1).signal(i,2)^2  + 2* (rand-0.5) * noise;                             
end


     
disp(['Normalization =================================']);
winl    = 512
% winl    = size(ymd.omt(1).signal,1)
norm    = spec_norm(winl)


disp(['Spectrum ======================================']);
XMD.omt = spec(xmd.omt, winl, norm);

tnorm = 1e-3
fnorm = 1e+3
render_example(XMD.omt(1),tnorm, fnorm)


return



