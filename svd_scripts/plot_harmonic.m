
clear all


tmin = 220e-3;
tmax = 280e-3;
dt   = 0.5e-6;
t = tmin:dt:tmax;
Nt= length(t);

% coil positions
theta   = 0;
phi     = 6/180*pi;

% fourier mode
m       = 1;
n       = 8;
PHI     = 0;
wmin    = 287.1e+3 * 2*pi;
wmax    = 489.6e+3 * 2*pi;
dw      = (wmax - wmin)/(tmax - tmin);

% tearing modes
f1      = 0.2;
m1      = 2;
n1      = 1;
PHI1    = 0;
w1      = 16e+3 * 2*pi;

f2      = 0.2;
m2      = 2;
n2      = 2;
PHI2    = 0;
w2      = 33e+3 * 2*pi;

xmd.omt(1).data           =1 ;
xmd.omt(1).signal(:,1)    = t.';
xmd.omt(1).signal(1:Nt,2) = 0.0;
xmd.omt(1).phi            = 0.1047;

for i=1:Nt

    % w(i) = wmin + i*dw;
    tphi = wmin * t(i) + dw/2 * (t(i)-tmin)^2;
    xmd.omt(1).signal(i,2) = cos(m * theta - n* phi  + tphi + PHI) * ...
                            (1 + f1 * cos(m1 * theta - n1* phi  + w1*t(i) + PHI1) + ...
                                 f2 * cos(m2 * theta - n2* phi  + w2*t(i) + PHI1)) + ...
                                 f1 * cos(m1 * theta - n1* phi  + w1*t(i) + PHI1) + ...
                                 f2 * cos(m2 * theta - n2* phi  + w2*t(i) + PHI1); 
                             
end
         
     
disp(['Normalization =================================']);
winl    = 4096
norm    = spec_norm(winl)


disp(['Spectrum ======================================']);
XMD.omt = spec(xmd.omt, winl, norm);

tnorm = 1e-3
fnorm = 1e+3
render_example(XMD.omt(1),tnorm, fnorm)



