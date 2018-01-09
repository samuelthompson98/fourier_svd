
% figure 2
% Perform SVD decomposition, and return n mode analysis

% load 9429_xmd.mat
% load 9429_xmd_17_06_07.mat
load ../SVD4/9429_xmd.mat

% MJH processing 15/06/07: remove mean
xmd.omt(1).signal(:,2) = xmd.omt(1).signal(:,2) - mean(xmd.omt(1).signal(:,2));
xmd.omt(2).signal(:,2) = xmd.omt(2).signal(:,2) - mean(xmd.omt(2).signal(:,2));
xmd.omt(3).signal(:,2) = xmd.omt(3).signal(:,2) - mean(xmd.omt(3).signal(:,2));


disp(['Normalization =================================']);
winl    = 4096
% winl    = 2048
norm    = spec_norm(winl)


disp(['Spectrum ======================================']);
XMD.omt = spec(xmd.omt, winl, norm);

toff   = min(xmd.omt(1).signal(:,1));
% disp(['computation time = ', num2str(0.069+toff)]);
% [Z]    = nmode(XMD.omt,0.069+toff,1,500,100e+3)

[Z]    = nmode(XMD.omt,0.165,1,500,100e+3)
Z.shot = 9429

pltn_chirp(Z);

fs = 14;  % font size
lw = 1.5; % line width

hold on;
h1 = subplot('Position', [0.15 0.68 0.8 0.28]); hold on;
set(gca,'FontSize', fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;

text(20e+3,1e-5,'n=-1','FontSize',fs);
text(40e+3,1e-5,'n=-2','FontSize',fs);
text(60e+3,1e-5,'n=-3','FontSize',fs);
text(80e+3,1e-5,'n=-4','FontSize',fs);

[h,Zwin]  = pltn_chirp(Z);

tnorm = 1e-3
fnorm = 1e+3
render_example(XMD.omt(1),tnorm, fnorm)



