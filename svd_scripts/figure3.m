
% figure 2
% Perform SVD decomposition, and return n mode analysis

load 9429_xmd.mat

disp(['Fix Polarity =================================']);
pol_fix = 0;
if pol_fix
  xmd.omt(1).signal(:,2)  = - xmd.omt(1).signal(:,2);
  xmd.omt(2).signal(:,2)  = + xmd.omt(2).signal(:,2);
  xmd.omt(3).signal(:,2)  = - xmd.omt(3).signal(:,2);
end;


disp(['Normalization =================================']);
winl    = (4096/2e+6)/(1/18e+3) * (1/350e+3)/(1/2e+6)
winl    = 256

norm    = spec_norm(winl)


disp(['Spectrum ======================================']);
XMD.omt = spec(xmd.omt, winl, norm);

[Z]    = nmode(XMD.omt,0.2401,2,200e+3,400e+3)
Z.shot = 9429

pltn_paper(Z);

fs = 14;  % font size
lw = 1.5; % line width

hold on;
h1 = subplot('Position', [0.15 0.68 0.8 0.28]); hold on;
set(gca,'FontSize', fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;

text(350e+3,1e-6,'n=8','FontSize',fs);
text(350e+3,1e-7,'n=13','FontSize',fs);
