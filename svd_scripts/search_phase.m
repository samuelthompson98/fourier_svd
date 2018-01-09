
clear all


tmin = 0e-3;
tmax = 30e-3;
dt   = 0.5e-6;
t = tmin:dt:tmax;
Nt= length(t);

% coil positions
theta   = 0;
phi     = 6/180*pi;

% fourier mode
n       = 8;
PHI     = 0;
wmin    = 287.1e+3 * 2*pi;
wmax    = 287.1e+3 * 2*pi;
% wmax    = 489.6e+3 * 2*pi;
dw      = (wmax - wmin)/(tmax - tmin);

% tearing modes
f1      = 0.2;
n1      = 1;
PHI1    = 0;
w1      = 16e+3 * 2*pi;

f2      = 0.2;
n2      = 2;
PHI2    = 0;
w2      = 33e+3 * 2*pi;

xmd.omt(1).data           = 1 ;
xmd.omt(1).phi            = 0.1047;
xmd.omt(1).signal(:,1)    = t.';
xmd.omt(1).signal(1:Nt,2) = 0.0;

xmd.omt(2).data           = 1 ;
xmd.omt(2).phi            = 5.3047;
xmd.omt(2).signal(:,1)    = t.';
xmd.omt(2).signal(1:Nt,2) = 0.0;

xmd.omt(3).data           = 1 ;
xmd.omt(3).phi            = 6.2308;
xmd.omt(3).signal(:,1)    = t.';
xmd.omt(3).signal(1:Nt,2) = 0.0;

for i=1:Nt

    % w(i) = wmin + i*dw;
    tphi = wmin * t(i) + dw/2 * (t(i)-tmin)^2;
    xmd.omt(1).signal(i,2) = cos( - n* xmd.omt(1).phi  + tphi + PHI) * ...
                            (1 + f1 * cos( - n1* xmd.omt(1).phi  + w1*t(i) + PHI1) + ...
                                 f2 * cos( - n2* xmd.omt(1).phi  + w2*t(i) + PHI2)) + ...
                                 f1 * cos( - n1* xmd.omt(1).phi  + w1*t(i) + PHI1) + ...
                                 f2 * cos( - n2* xmd.omt(1).phi  + w2*t(i) + PHI2); 
 
    xmd.omt(2).signal(i,2) = cos( - n* xmd.omt(2).phi  + tphi + PHI) * ...
                            (1 + f1 * cos( - n1* xmd.omt(2).phi  + w1*t(i) + PHI1) + ...
                                 f2 * cos( - n2* xmd.omt(2).phi  + w2*t(i) + PHI2)) + ...
                                 f1 * cos( - n1* xmd.omt(2).phi  + w1*t(i) + PHI1) + ...
                                 f2 * cos( - n2* xmd.omt(2).phi  + w2*t(i) + PHI2); 

    xmd.omt(3).signal(i,2) = cos( - n* xmd.omt(3).phi  + tphi + PHI) * ...
                            (1 + f1 * cos( - n1* xmd.omt(3).phi  + w1*t(i) + PHI1) + ...
                                 f2 * cos( - n2* xmd.omt(3).phi  + w2*t(i) + PHI2)) + ...
                                 f1 * cos( - n1* xmd.omt(3).phi  + w1*t(i) + PHI1) + ...
                                 f2 * cos( - n2* xmd.omt(3).phi  + w2*t(i) + PHI2); 
                           
end

     
disp(['Normalization =================================']);
winl    = 2048
% winl    = size(ymd.omt(1).signal,1)
norm    = spec_norm(winl)


disp(['Spectrum ======================================']);
XMD.omt = spec(xmd.omt, winl, norm);

tnorm = 1e-3
fnorm = 1e+3
render_example(XMD.omt(1),tnorm, fnorm)

flow   = 1e+3;
fhigh  = 1e+6;
Z1     = nmode(XMD.omt,1e-3,1,flow,  fhigh)
Z2     = nmode(XMD.omt,9e-3,1,flow,  fhigh)

Z1.shot= 0;
Z2.shot= 0;


% pltn_paper(Z);
% return

[h,Zwin]  = pltn_chirp(Z1);
[h,Zwin]  = pltn_chirp(Z2);


