
clear all


tmin = 0e-3;
tmax = 40e-3;
dt   = 2e-6;
t = tmin:dt:tmax;
Nt= length(t);

% coil positions
theta   = 0;
phi     = 6/180*pi;

% tearing mode
f1      = 1;
n1      = 1;
PHI1    = 10/180*pi;
w1      = 15.9230840e+3 *2 *pi;

% CAE mode
f2      = 0.2;
n2      = -8;
PHI2    = 40/180*pi;
w2      = 294.2109438102394e+3 *2 *pi;

noise   = 0.04;

xmd.omt(1).data           = 1 ;
xmd.omt(1).phi            = 0.1047;
xmd.omt(1).signal(:,1)    = t.';
xmd.omt(1).signal(1:Nt,2) = 0.0;

for i=1:Nt

    xmd.omt(1).signal(i,2) =  f1 * cos( - n1* xmd.omt(1).phi  + w1*t(i) + PHI1);
                          
    xmd.omt(1).signal(i,2) =  xmd.omt(1).signal(i,2) + 0.6* xmd.omt(1).signal(i,2)^2  + 0.4* xmd.omt(1).signal(i,2)^3 + 2* (rand-0.5) * noise;                             
end


     
disp(['Normalization =================================']);
winl    = 512;
% winl    = size(ymd.omt(1).signal,1)
norm    = spec_norm(winl)


disp(['Spectrum ======================================']);
XMD.omt = spec(xmd.omt, winl, norm);

tnorm = 1e-3
fnorm = 1e+3
render_example(XMD.omt(1),tnorm, fnorm)


return



