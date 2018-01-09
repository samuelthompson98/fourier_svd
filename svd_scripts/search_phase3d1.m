
clear all


tmin = 0e-3;
tmax = 1e-3;
dt   = 2e-6;
t = tmin:dt:tmax;
Nt= length(t);

% coil positions
theta   = 0;
phi     = 6/180*pi;

% reproduce example of Raju et al
f1      = 1;
n1      = 0;
PHI1    = 10/180*pi;
wnorm   = 100.9032423e+3 *2 * pi;
w1      = 0.12 * wnorm

f2      = 1;
n2      = 0;
PHI2    = 45/180*pi;
w2      = 0.18 * wnorm;

f3      = 1;
n3      = 0;
PHI3    = 100/180*pi;
w3      = w1 + w2;

noise.sigma = 0.2;
noise.mu    = 0.0;

disp(['Normalization =================================']);
winl    = Nt;
norm    = spec_norm(winl)

Nsamples= 40;

xmd.omt(1).data           = 1 ;
xmd.omt(1).phi            = 0.1047;
xmd.omt(1).signal(:,1)    = t.';

Nkk = fix(Nt/Nsamples)
ioff= fix(Nkk/2)
% Nkk = Nkk - ioff;

for kk = 1:Nsamples

    PHI1    = rand*2*pi;
    PHI2    = rand*2*pi;
    PHI3    = PHI1 + PHI2;

    xmd.omt(1).signal(1:Nt,2) = 0.0;
    
    % for i=1:Nt
    for i=(kk-1)*Nkk+ioff: kk*Nkk+ioff

        xmd.omt(1).signal(i,2) =  f1 * sin( - n1* xmd.omt(1).phi  + w1*t(i) + PHI1) + ...
                                  f2 * sin( - n2* xmd.omt(1).phi  + w2*t(i) + PHI2) + ...
                                  f3 * sin( - n3* xmd.omt(1).phi  + w3*t(i) + PHI3);
                          
        xmd.omt(1).signal(i,2) =  xmd.omt(1).signal(i,2) + seed_noise(rand, noise);                             
    end

    % MJH processing 15/06/07: remove mean
    xmd.omt(1).signal(:,2) = xmd.omt(1).signal(:,2) - mean(xmd.omt(1).signal(:,2));

    disp(['Spectrum ======================================']);
    XMD_sample.omt = spec(xmd.omt, winl, norm);

    XMD.omt.F(:, kk) = XMD_sample.omt.F(:,1);
    XMD.omt.t(kk)    = tmax * (kk-1);
    XMD.omt.f        = XMD_sample.omt.f;
    XMD.omt.dt       = XMD_sample.omt.dt;
    XMD.omt.df       = XMD_sample.omt.df;
    XMD.omt.data     = XMD_sample.omt.data;
    XMD.omt.phi      = XMD_sample.omt.phi;

end % kk



it_min = min(find(XMD.omt(1).t>=tmin));
it_max = max(find(XMD.omt(1).t<=Nsamples * tmax));
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

if_min = min(find(YMD.omt.f > 12e+3))
if_max = min(find(YMD.omt.f > 18e+3))
if_pk = min(find(YMD.omt.f > 30e+3))
figure
time    = YMD.omt.t;
ph_diff = angle(YMD.omt.F(if_max,:)) + angle(YMD.omt.F(if_min,:)) - angle(YMD.omt.F(if_pk,:));
iph_neg = find(ph_diff <0);
ph_diff(iph_neg) = ph_diff(iph_neg) + 2*pi;

plot(time, ph_diff);

return



