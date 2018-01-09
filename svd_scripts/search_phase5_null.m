
clear all

load 9429_XMD_CAE.mat NTM CAE
NTM_CAE = NTM;

% use improved resolution NTM analysis for low frequency peaks
load 9429_XMD_NTM.mat NTM
NTM_NTM = NTM;

tmin = 220e-3;
tmax = 320e-3;
dt   = 0.5e-6;
t = tmin:dt:tmax;
Nt= length(t);

% coil positions
theta   = 0;
phi     = 6/180*pi;

for i=1:5
    NTM.PHI(i) = rand * 2 *pi;
    CAE.PHI(i) = rand * 2 *pi;
    % CAE.A(i)   = 0.0;
end;


Ncoils  = 30;
Area    = pi* (10.7e-3)^2;

% noise not handled properly, should be Gaussian distributed - not uniform distribution
noise.sigma = 0.0032
noise.sigma = 0.0015;
noise.mu    = 0.0;

xmd.omt(1).data           = 1 ;
xmd.omt(1).phi            = 0.1047;
xmd.omt(1).signal(:,1)    = t.';
xmd.omt(1).signal(1:Nt,2) = 0.0;

for i=1:Nt

    xmd.omt(1).signal(i,2) =  NTM.A(1)*2*pi*NTM.f(1)* Ncoils * Area * cos( 2*pi*NTM.f(1)*t(i) + NTM.PHI(1)) + ...
                              NTM.A(2)*2*pi*NTM.f(2)* Ncoils * Area * cos( 2*pi*NTM.f(2)*t(i) + NTM.PHI(2)) + ...
                              NTM.A(3)*2*pi*NTM.f(3)* Ncoils * Area * cos( 2*pi*NTM.f(3)*t(i) + NTM.PHI(3)) + ...
                              NTM.A(4)*2*pi*NTM.f(4)* Ncoils * Area * cos( 2*pi*NTM.f(4)*t(i) + NTM.PHI(4)) + ...
                              NTM.A(5)*2*pi*NTM.f(5)* Ncoils * Area * cos( 2*pi*NTM.f(5)*t(i) + NTM.PHI(5)) + ...
                              CAE.A(1)*2*pi*CAE.f(1)* Ncoils * Area * cos( 2*pi*CAE.f(1)*t(i) + CAE.PHI(1)) + ... 
                              CAE.A(2)*2*pi*CAE.f(2)* Ncoils * Area * cos( 2*pi*CAE.f(2)*t(i) + CAE.PHI(2)) + ...
                              CAE.A(3)*2*pi*CAE.f(3)* Ncoils * Area * cos( 2*pi*CAE.f(3)*t(i) + CAE.PHI(3)) + ...
                              CAE.A(4)*2*pi*CAE.f(4)* Ncoils * Area * cos( 2*pi*CAE.f(4)*t(i) + CAE.PHI(4)) +  seed_noise(rand, noise);

end


% MJH processing 15/06/07: remove mean
xmd.omt(1).signal(:,2) = xmd.omt(1).signal(:,2) - mean(xmd.omt(1).signal(:,2));

disp(['Normalization =================================']);
winl    = 2048;
% winl    = size(ymd.omt(1).signal,1)
norm    = spec_norm(winl)


disp(['Spectrum ======================================']);
XMD.omt = spec(xmd.omt, winl, norm);

tnorm = 1e-3
fnorm = 1e+3
render_example(XMD.omt(1),tnorm, fnorm)


tmin = 220e-3;
tmax = 320e-3;
it_min = min(find(XMD.omt(1).t>tmin));
it_max = max(find(XMD.omt(1).t<tmax));
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




