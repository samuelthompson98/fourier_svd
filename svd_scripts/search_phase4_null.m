
clear all

load 9429_XMD_NTM.mat NTM

tmin = 160e-3;
tmax = 190e-3;
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
w2      = 2 * NTM.f(1) *2 *pi;
w3      = 3 * NTM.f(1) *2 *pi;
w4      = 4 * NTM.f(1) *2 *pi;
w5      = 5 * NTM.f(1) *2 *pi;
w6      = 6 * NTM.f(1) *2 *pi;

Ncoils  = 30;
Area    = pi* (10.7e-3)^2;
% PHI1    = rand*2*pi;
% PHI2    = rand*2*pi;
% PHI3    = rand*2*pi;
% PHI4    = rand*2*pi;
% PHI5    = rand*2*pi;

PHI1    = rand*2*pi;
PHI2    = 2 * PHI1 + 2*pi/3;
PHI3    = 3 * PHI1 + 4*pi/3;
PHI4    = 4 * PHI1 + 6*pi/3;
PHI5    = 5 * PHI1 + 8*pi/3;
PHI6    = 6 * PHI1 + 10*pi/3;

% noise
noise.sigma = 0.0032
noise.mu    = 0.0;

xmd.omt(1).data           = 1 ;
xmd.omt(1).phi            = 0.1047;
xmd.omt(1).signal(:,1)    = t.';
xmd.omt(1).signal(1:Nt,2) = 0.0;

for i=1:Nt

    xmd.omt(1).signal(i,2) =  NTM.A(1)*2*pi*NTM.f(1)* Ncoils * Area * cos( w1*t(i) + PHI1) + ...
                              NTM.A(2)*2*pi*NTM.f(2)* Ncoils * Area * cos( w2*t(i) + PHI2) + ...
                              NTM.A(3)*2*pi*NTM.f(3)* Ncoils * Area * cos( w3*t(i) + PHI3) + ...
                              NTM.A(4)*2*pi*NTM.f(4)* Ncoils * Area * cos( w4*t(i) + PHI4) + ...
                              NTM.A(5)*2*pi*NTM.f(5)* Ncoils * Area * cos( w5*t(i) + PHI5) + ...
                              NTM.A(5)*2*pi*NTM.f(5)* Ncoils * Area * cos( w6*t(i) + PHI6) + seed_noise(rand, noise);
 end


% MJH processing 15/06/07: remove mean
xmd.omt(1).signal(:,2) = xmd.omt(1).signal(:,2) - mean(xmd.omt(1).signal(:,2));

disp(['Normalization =================================']);
winl    = 1024;
winl    = 2048;
% winl    = 4096;

% winl    = size(ymd.omt(1).signal,1)
norm    = spec_norm(winl)


disp(['Spectrum ======================================']);
XMD.omt = spec(xmd.omt, winl, norm);

tnorm = 1e-3
fnorm = 1e+3
render_example(XMD.omt(1),tnorm, fnorm)


tmin = 160e-3;
tmax = min([180e-3 (tmin + winl * 0.5e-6)]);
tmax = 180e-3;
it_min = min(find(XMD.omt(1).t>tmin));
it_max = min(find(XMD.omt(1).t>tmax));
Nf     = size(XMD.omt(1).f,2)
for i=1:Nf
    XMD.omt(1).Fmean(i) = mean(abs(XMD.omt(1).F(i,it_min:it_max)));
end;

XMD_fit = XMD;

load 9429_XMD_NTM.mat XMD 

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
axis([ 0 300 10^-9 10^-3]);
legend([h1 h2], {'fit','data'});

XMD = XMD_fit;


bispectral_data



return

f1  = NTM.f(1);
f2  = 2*f1;


ifk_max = max(find(bispec.fk(:,1)<1.5*f1));
ifl_max = max(find(bispec.fl(1,:)<1.5*f1));

[junk, ifk] = max(max(abs(bispec.Bn(1:ifk_max,1:ifl_max))));
% ifk = ifk+1;
ifl = 2*ifk;

f1  = bispec.fk(ifk,1);
f2  = 2*f1;

figure
fs = 14;
lw = 1.5;
set(gca,'FontSize',fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;

subplot(2,1,1); hold on;
set(gca,'FontSize',fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;

plot(bispec.fl(1,:), abs(bispec.Bn(ifk,:)),'b')
plot([f1 2*f1 3*f1 4*f1], [abs(bispec.Bn(ifk,ifk))  abs(bispec.Bn(ifk,2*ifk))  abs(bispec.Bn(ifk,3*ifk))  abs(bispec.Bn(ifk,4*ifk))] ,'b.', 'MarkerSize', 12)

plot(bispec.fk(:,1), abs(bispec.Bn(:,ifl)),'r')
plot([f2 2*f2], [abs(bispec.Bn(ifl,ifl))  abs(bispec.Bn(2*ifl,ifl))] ,'r.', 'MarkerSize', 12)

ylabel(['|B|']);

subplot(2,1,2); hold on;
set(gca,'FontSize',fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;
phl = angle(bispec.Bn(ifk,:))/pi * 180;
phk = angle(bispec.Bn(:,ifl))/pi * 180;
Nph = length(phl);
ph_jump = 180;
for i=1:Nph
    while phl(i)<-ph_jump         phl(i) = phl(i) + 2*ph_jump;    end
    while phl(i)>+ph_jump         phl(i) = phl(i) - 2*ph_jump;    end    
    while phk(i)<-ph_jump         phk(i) = phk(i) + 2*ph_jump;    end
    while phk(i)>+ph_jump         phk(i) = phk(i) - 2*ph_jump;    end    
end
plot(bispec.fl(1,:), phl,'b')
plot([f1 2*f1 3*f1 4*f1], [phl(ifk) phl(2*ifk) phl(3*ifk) phl(4*ifk)],'b.', 'MarkerSize', 12)

plot(bispec.fk(:,1), phk,'r')
plot([f2 2*f2], [phk(ifl) phk(2*ifl)],'r.', 'MarkerSize', 12)
% f1 = min(bispec.fl(1,:))
% f2 = max(bispec.fl(1,:))


xlabel(['f [Hz]']);
ylabel(['<B']);