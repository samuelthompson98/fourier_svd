
% function make_sample_M2a

n1 = 5;
n2 = 1;
n3 = 3;
n4 = -2;
n5 = -4;

f1 = 300e+3;
f2 = f1;
f3 = f1;
f4 = f1;
f5 = f1;
fs = 1e+6;
DT = 10e-3;
t  = 0:1/fs:DT-1/fs;

Nth = 11;

s=RandStream('mt19937ar');
reset(s);
theta = rand(s, [1 Nth])*2*pi; 

psi1    = 0.3*pi;
psi2    = 0.5*pi;
psi3    = 0.8*pi;
psi4    = 0.1*pi;
psi5    = 0.9*pi;

A1 = 1.0;
A2 = 0.5;
A3 = 0.1;
A4 = 0.7;
A5 = 0.05;

% noise not handled properly, should be Gaussian distributed - not uniform distribution
noise.sigma = 0.01;
noise.mu    = 0.0;

phi = [0 30 45 60 90 120]/pi;
phi = theta;

for i=1:length(phi)
    xmd.omt(i).data           = 1 ;
    xmd.omt(i).phi            = phi(i);
    xmd.omt(i).signal(:,1)    = t.';
    xmd.omt(i).signal(:,2)    =  A1 * cos( 2*pi*f1 .* t + n1 * xmd.omt(i).phi + psi1 ) + ...
                                 A2 * cos( 2*pi*f2 .* t + n2 * xmd.omt(i).phi + psi2 ) + ...
                                 A3 * cos( 2*pi*f3 .* t + n3 * xmd.omt(i).phi + psi3 ) + ...
                                 A4 * cos( 2*pi*f4 .* t + n4 * xmd.omt(i).phi + psi4 ) + ...
                                 A5 * cos( 2*pi*f5 .* t + n5 * xmd.omt(i).phi + psi5 ) +  seed_noise(rand(length(t)),noise).';
end


% MJH processing 15/06/07: remove mean
% xmd.omt(1).signal(:,2) = xmd.omt(1).signal(:,2) - mean(xmd.omt(1).signal(:,2));

disp(['Normalization =================================']);
winl    = 2048;
% winl    = size(ymd.omt(1).signal,1)
norm    = spec_norm(winl)


disp(['Spectrum ======================================']);
XMD.omt = spec(xmd.omt, winl, norm);

tnorm = 1e-3
fnorm = 1e+3
render_example(XMD.omt(1),tnorm, fnorm)

save XMD_M5.mat XMD


% M=1 Fit ================================================================

[Z]=nmode(XMD.omt,0.002,1,0,fs/2)

pltn_hanbit1(Z)

figure; 
subplot(2,1,1); hold on;
tfs = 16;
lfs = 16;

set(gca,'FontSize',lfs, 'LineWidth',1.5,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;
plot(Z.f,Z.n,'k-'); 
xlabel(['f [Hz]']);
ylabel(['n']);

subplot(2,1,2); hold on;
set(gca,'FontSize',lfs, 'LineWidth',1.5,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;
semilogy(Z.f,abs(Z.a),'k-'); 
xlabel(['f [Hz]']);
ylabel(['abs(\alpha)']);
set(gca,'YScale','log')

n_struc   = Z;
n_struc.f = Z.f'; 
n_struc   = fit_mag_power2(n_struc);

render_nmode4(n_struc, tnorm, fnorm, 19, 0.1, 10e+3)

% M=2 Fit ================================================================

[Z2]=nmode(XMD.omt,0.002,2,290e+3,310e+3)

pltn_hanbit2(Z2)


% M=3 Fit ================================================================

[Z3]=nmode(XMD.omt,0.002,3,290e+3,310e+3)

pltn_hanbit2(Z3)

return;