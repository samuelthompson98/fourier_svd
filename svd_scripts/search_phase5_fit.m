
clear all

load 9429_XMD_CAE.mat NTM CAE
load 9429_XMD_NTM.mat NTM

tmin = 220e-3;
tmax = 222e-3;
dt   = 0.5e-6;
t = tmin:dt:tmax;
Nt= length(t);

% coil positions
theta   = 0;
phi     = 6/180*pi;

% tearing mode
f1      = 1;
n1      = 1;
PHI1    = 10/180*pi;
w1      = NTM.f(1) *2 *pi;

% CAE mode
f2      = CAE.A(1)/NTM.A(1);
n2      = 8;
PHI2    = 50/180*pi;
w2      = CAE.f(1) *2 *pi;

beta(1) = NTM.A(1);
beta(2) = NTM.A(2);
beta(3) = NTM.A(3);
beta(4) = NTM.A(4);
beta(5) = NTM.A(5);

Ncoils  = 30;
Area    = pi* (10.7e-3)^2;
beta(5) = 16 * NTM.A(5)*2*pi*NTM.f(5)* Ncoils * Area;
beta(4) = 8 * NTM.A(4)*2*pi*NTM.f(4)* Ncoils * Area;
beta(3) = 4 * NTM.A(3)*2*pi*NTM.f(3)* Ncoils * Area - 5/4 * beta(5);
beta(2) = 2 * NTM.A(2)*2*pi*NTM.f(2)* Ncoils * Area - 8/8 * beta(4);
beta(1) = 1 * NTM.A(1)*2*pi*NTM.f(1)* Ncoils * Area - 12/16 * beta(3) - 10/16 * beta(5);

f2 = CAE.A(1)*2*pi*CAE.f(1)* Ncoils * Area / beta(1);

% noise not handled properly, should be Gaussian distributed - not uniform distribution
noise.sigma = 0.0032
noise.sigma = 0.0001;
noise.mu    = 0.0;

xmd.omt(1).data           = 1 ;
xmd.omt(1).phi            = 0.1047;
xmd.omt(1).signal(:,1)    = t.';
xmd.omt(1).signal(1:Nt,2) = 0.0;

for i=1:Nt

    xmd.omt(1).signal(i,2) =  f1 * cos( - n1* xmd.omt(1).phi  + w1*t(i) + PHI1) + ...
                              f2 * cos( - n2* xmd.omt(1).phi  + w2*t(i) + PHI2);
                          
    xmd.omt(1).signal(i,2) =  beta(1)* xmd.omt(1).signal(i,2) + ...
                              beta(2)* xmd.omt(1).signal(i,2)^2 + ...
                              beta(3)* xmd.omt(1).signal(i,2)^3 + ...
                              beta(4)* xmd.omt(1).signal(i,2)^4 + ...
                              beta(5)* xmd.omt(1).signal(i,2)^5 + seed_noise(rand, noise);
                          
                          %2*(rand-0.5) * noise;                             
end


% MJH processing 15/06/07: remove mean
xmd.omt(1).signal(:,2) = xmd.omt(1).signal(:,2) - mean(xmd.omt(1).signal(:,2));

disp(['Normalization =================================']);
winl    = 2048;
winl    = 4096;
winl    = 512;

% winl    = size(ymd.omt(1).signal,1)
norm    = spec_norm(winl)


disp(['Spectrum ======================================']);
XMD.omt = spec(xmd.omt, winl, norm);

tnorm = 1e-3
fnorm = 1e+3
render_example(XMD.omt(1),tnorm, fnorm)


tmin = 220e-3;
tmax = 250e-3;
it_min = min(find(XMD.omt(1).t>tmin));
it_max = min(find(XMD.omt(1).t>tmax));
Nf     = size(XMD.omt(1).f,2)
for i=1:Nf
    XMD.omt(1).Fmean(i) = mean(abs(XMD.omt(1).F(i,it_min:it_max)));
end;

XMD_fit = XMD;

load 9429_XMD_CAE.mat XMD 

XMD_data = XMD;


figure
fs = 14;
lw = 1.5;
set(gca,'FontSize',fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;
fnorm = 1e+3
h1 = plot(XMD_fit.omt(1).f/fnorm, XMD_fit.omt(1).Fmean,'k', 'LineWidth',lw); hold on
h2 = plot(XMD_data.omt(1).f/fnorm, XMD_data.omt(1).Fmean,'b', 'LineWidth',lw);
set(gca,'YScale','log');
xlabel(['f [kHz]']);
ylabel(['\delta B [T Hz^{-1}]']);
axis([ 0 500 10^-9 10^-3]);
legend([h1 h2], {'fit','data'});

XMD = XMD_fit;




