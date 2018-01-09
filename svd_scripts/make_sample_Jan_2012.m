
% function make_sample_Jan_2012
clear all

n0 = 5;
f0 = 600e+3;
fs = 1e+6;
DT = 10e-3;
t  = 0:1/fs:DT-1/fs;

theta   = 0;
phi     = 6/180*pi;

% noise not handled properly, should be Gaussian distributed - not uniform distribution
noise.sigma = 0.01;
noise.mu    = 0.0;

phi = [0 30 45 60 90 120]/pi;

for i=1:length(phi)
    xmd.omt(i).data           = 1 ;
    xmd.omt(i).phi            = phi(i);
    xmd.omt(i).signal(:,1)    = t.';
    xmd.omt(i).signal(:,2)    =  1.0 * cos( 2*pi*f0 .* t + n0 * xmd.omt(i).phi ) + seed_noise(rand(length(t)),noise).';
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

return;