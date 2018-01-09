
clear all


tmin = 0e-3;
tmax = 100e-3;
dt   = 2e-6;
t = tmin:dt:tmax;
Nt= length(t);

% coil positions
theta   = 0;
phi     = 6/180*pi;

% reproduce example of Raju et al

beta1   = 1;
beta2   = 0.3;

f1      = beta1 + beta2;
n1      = 0;
PHI1    = rand * 2 * pi;
wnorm   = 100.9032423e+3 *2 * pi;
w1      = 0.12 * wnorm

f2      = beta1 + 0.5 * beta2;
n2      = 0;
PHI2    = rand * 2 * pi;
w2      = 2 * w1;

f3      = beta2;
n3      = 0;
PHI3    = rand * 2 * pi;
w3      = 3 * w1;

f4      = beta2/2;
n4      = 0;
PHI4    = rand * 2 * pi;
w4      = 4 * w1;

noise   = 0.20;

xmd.omt(1).data           = 1 ;
xmd.omt(1).phi            = 0.1047;
xmd.omt(1).signal(:,1)    = t.';
xmd.omt(1).signal(1:Nt,2) = 0.0;

for i=1:Nt

    xmd.omt(1).signal(i,2) =  f1 * sin( - n1* xmd.omt(1).phi  + w1*t(i) + PHI1) + ...
                              f2 * sin( - n2* xmd.omt(1).phi  + w2*t(i) + PHI2) + ...
                              f3 * sin( - n3* xmd.omt(1).phi  + w3*t(i) + PHI3) + ...
                              f4 * sin( - n4* xmd.omt(1).phi  + w4*t(i) + PHI4);
                          
    xmd.omt(1).signal(i,2) =  xmd.omt(1).signal(i,2) + 0.0* xmd.omt(1).signal(i,2)^2  + 2* (rand-0.5) * noise;                             
end

% MJH processing 15/06/07: remove mean
xmd.omt(1).signal(:,2) = xmd.omt(1).signal(:,2) - mean(xmd.omt(1).signal(:,2));
     
disp(['Normalization =================================']);
winl    = 512
% winl    = size(ymd.omt(1).signal,1)
norm    = spec_norm(winl)


disp(['Spectrum ======================================']);
XMD.omt = spec(xmd.omt, winl, norm);

it_min = min(find(XMD.omt(1).t>tmin));
it_max = max(find(XMD.omt(1).t<tmax));
Nf     = size(XMD.omt(1).f,2)
for i=1:Nf
    XMD.omt(1).Fmean(i) = mean(abs(XMD.omt(1).F(i,it_min:it_max)));
end;

figure
fs = 14;
lw = 1.5;
set(gca,'FontSize',fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;
fnorm = 1e+3
h1 = plot(XMD.omt(1).f/fnorm, XMD.omt(1).Fmean,'k', 'LineWidth',lw); hold on
set(gca,'YScale','log');
xlabel(['f [kHz]']);
axis([ 0 60 min(abs(XMD.omt(1).Fmean)) max(abs(XMD.omt(1).Fmean))]);


% replicate for negative frequency - taking complex conjugate
NXf       = length(XMD.omt.f);
NXt       = length(XMD.omt.t);

YMD.omt.f = -fliplr(XMD.omt.f);

YMD.omt.f(NXf+2: 2*NXf) = XMD.omt.f(2:NXf);
for i=1:NXt
    YMD.omt.F(1:NXf,i)       = flipud(XMD.omt.F(:,i))';
    YMD.omt.F(NXf+1:2*NXf,i) = XMD.omt.F(:,i);
end;    

YMD.omt.data = XMD.omt.data;
YMD.omt.phi  = XMD.omt.phi;
YMD.omt.t    = XMD.omt.t;
YMD.omt.dt   = XMD.omt.dt;
YMD.omt.df   = XMD.omt.df;

tnorm = 1e-3
fnorm = 1e+3
render_example(XMD.omt(1),tnorm, fnorm)

bispectral_bif(YMD)

return



