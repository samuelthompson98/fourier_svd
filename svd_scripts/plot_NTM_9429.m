% function plot_MHD_9429

% get data
% efm_file = '/funsrv1/home/mhole/MAST/7085_290/efm0070.85_nstx_da'
% efm_file = '/funsrv1/home/mhole/MAST/7094_290/efm0070.94_nstx_da'
% efm_file = '/funsrv1/home/mhole/MAST/7094_290/efm0070.90_nstx_da'
% efm = getEFM(shot,efm_file)

% set line width 
clear all

lw = 1.5
bw = 2.0;  % box line width
cw = 1.5;
fs = 14.0; % font size  
tag = 0;

% MJH 19/04/04
% efm = getEFM(shot)
% xim = getXIM(shot)
% anb = getANB(shot)
% xsx = getXSX(shot)
% amc = getAMC(shot)
% xma = getXMA(shot)
% xmc = getXMC(shot)
% xmb = getXMB(shot)

t = [0.2 0.40]

load 9429_MHD_v6.mat
load 9429_xmd_v6.mat

% reverse
shot = data.shot
efm = data.efm 
xim = data.xim
anb = data.anb 
xsx = data.xsx 
amc = data.amc
xmb = data.xmb
xmc = data.xmc
xma = data.xma 

h=figure;
% ========================================================================================
subplot('Position', [0.15 0.1 0.75 0.14]);     
h1 = plot(xim.DA_HU10_U(:,1),xim.DA_HU10_U(:,2));
set(h1,'LineWidth',lw,'LineStyle','-','Color','k')
set(gca,'FontSize', fs, 'LineWidth',bw,'Box','on','TickLength',[0.02 0.02],'TickDir','in');

tlow  = min(find(xim.DA_HU10_U(:,1)>=t(1)))
thigh = max(find(xim.DA_HU10_U(:,1)<=t(2)))
y(1) = min(xim.DA_HU10_U(tlow:thigh,2));
y(2) = max(xim.DA_HU10_U(tlow:thigh,2));
axis([t(1) t(2) 0 4]);
ylabel(['D_{\alpha}']);
xlabel('time [s]');
xticks = fix(t(1)/0.05)*0.05:0.05:t(2);
for i=1:length(xticks)
    xticklabels{i} = num2str(1000*xticks(i));
end;
set(gca,'XTick',xticks,'XTickLabel',xticklabels,'XColor','k','YColor','k')
set(gca,'Ytick',[0 2 4])

% ========================================================================================
subplot('Position', [0.15 0.24 0.75 0.14]);
[ax,h1,h2] = plotyy(xsx.HCAMU(2).signal(:,1),xsx.HCAMU(2).signal(:,2),xsx.HCAMU(7).signal(:,1),xsx.HCAMU(7).signal(:,2));
tlow  = min(find(xsx.HCAMU(2).signal(:,1)>=t(1)))
thigh = max(find(xsx.HCAMU(2).signal(:,1)<=t(2)))

axes(ax(1));
y(1) = min(xsx.HCAMU(2).signal(tlow:thigh,2));
y(2) = max(xsx.HCAMU(2).signal(tlow:thigh,2));
axis([t(1) t(2) -0.05 0.13]);
ylabel(['X_2'],'FontSize', fs);
set(gca,'XTickLabel',{},'XColor','k','YColor','k')
set(h1,'LineWidth',lw,'LineStyle','-','Color','k')
set(gca,'FontSize', fs, 'LineWidth',bw,'Box','on','TickLength',[0.02 0.02],'TickDir','in');
set(gca,'Ytick',[0 0.1])

axes(ax(2));
y(1) = min(xsx.HCAMU(7).signal(tlow:thigh,2));
y(2) = max(xsx.HCAMU(7).signal(tlow:thigh,2));
axis([t(1) t(2) 0 0.12]);
ylabel(['X_7'],'FontSize', fs);
set(gca,'XTickLabel',{},'XColor','k','YColor','k')
set(h2,'LineWidth',cw*lw,'LineStyle','-','Color','c')
set(gca,'FontSize', fs, 'LineWidth',bw,'Box','on','TickLength',[0.02 0.02],'TickDir','in');
set(gca,'Ytick',[0 0.1],'YAxisLocation','Right')

% set(get(ax(1),'Ylabel'),'String','Left Y-axis')
% set(get(ax(2),'Ylabel'),'String','Right Y-axis')
% h1 = plotyy(xsx.HCAMU(2).signal(:,1),xsx.HCAMU(2).signal(:,2),'k-','LineWidth',lw); hold on;
% h2 = plot(xsx.HCAMU(7).signal(:,1),xsx.HCAMU(7).signal(:,2),'c-','LineWidth',lw);
% tlow  = min(find(xsx.HCAMU(2).signal(:,1)>=t(1)))
% thigh = max(find(xsx.HCAMU(2).signal(:,1)<=t(2)))
% y(1) = min([min(xsx.HCAMU(2).signal(tlow:thigh,2)) min(xsx.HCAMU(7).signal(tlow:thigh,2))]);
% y(2) = max([max(xsx.HCAMU(2).signal(tlow:thigh,2)) max(xsx.HCAMU(7).signal(tlow:thigh,2))]);
% axis([t(1) t(2) 0.0 0.10]);
% ylabel(['SXR'],'FontSize', fs);
% set(gca,'XTickLabel',{},'XColor','k','YColor','k')
% set(gca,'Ytick',[0.0 0.10])
% clear hleg hlabel
% hleg(1)   = h1; 
% hleg(2)   = h2; 
% hlabel{1} = 'HCAMU(2)';
% hlabel{2} = 'HCAMU(7)';  
% set(gca,'FontSize', fs, 'LineWidth',bw,'Box','on','TickLength',[0.02 0.02],'TickDir','in');

% ========================================================================================
load 9429_ane_v6.mat ane

subplot('Position', [0.15 0.38 0.75 0.14]);
Eth_norm   = 1e+3;
ne_norm    = 1e+19;
[ax,h1,h2] = plotyy(efm.time,efm.thE/Eth_norm,ane.ne(:,1),ane.ne(:,2)/ne_norm)

axes(ax(1));
thEmin   = 0;     
thEmax   = 80;  
axis([t(1) t(2) thEmin thEmax]);
ylabel(['E_{th}'],'FontSize', fs);
set(gca,'XTickLabel',{},'XColor','k','YColor','k')
set(h1,'LineWidth',lw,'LineStyle','-','Color','k')
set(gca,'FontSize', fs, 'LineWidth',bw,'Box','on','TickLength',[0.02 0.02],'TickDir','in');
set(gca,'Ytick',[0.5 1 1.5])

axes(ax(2));
tlow  = min(find(ane.ne(:,1)>=t(1)))
thigh = max(find(ane.ne(:,1)<=t(2)))
y(1) = min(ane.ne(tlow:thigh,2)/ne_norm);
y(2) = max(ane.ne(tlow:thigh,2)/ne_norm);
axis([t(1) t(2) y(1) y(2)]);
ylabel(['n_e \times 10^{19} [m^{-3}]'],'FontSize', fs);
set(gca,'XTickLabel',{},'XColor','k','YColor','k')
set(h2,'LineWidth',cw*lw,'LineStyle','-','Color','c')
set(gca,'FontSize', fs, 'LineWidth',bw,'Box','on','TickLength',[0.02 0.02],'TickDir','in');
set(gca,'Ytick',[4.5 5.5 6.5])

clear hleg hlabel
hleg(1)   = h1; 
hleg(2)   = h2; 
hlabel{1} = 'E_{th}';
hlabel{2} = 'q_{95}';  

% ========================================================================================
subplot('Position', [0.15 0.66 0.75 0.14]);
h1 = plot(anb.TOT_sum_power(:,1),anb.TOT_sum_power(:,2)); hold on;
tlow  = min(find(anb.TOT_sum_power(:,1)>=t(1)))
thigh = max(find(anb.TOT_sum_power(:,1)<=t(2)))
axis([t(1) t(2) 0 2.5]);
ylabel(['P_{NBI} [MW]'],'FontSize', fs);
set(gca,'XTickLabel',{},'XColor','k','YColor','k')
set(h1,'LineWidth',lw,'LineStyle','-','Color','k')
set(gca,'FontSize', fs, 'LineWidth',bw,'Box','on','TickLength',[0.02 0.02],'TickDir','in');
set(gca,'Ytick',[0 1 2])

clear hleg hlabel
hleg(1)   = h1; 
hlabel{1} = 'P_{tot}';
% legend(hleg, hlabel);

% ========================================================================================

dBint = locked_m1(xmd.omr(3).signal,t,0);


subplot('Position', [0.15 0.52 0.75 0.14]);
Ipnorm = 1e+3;
Isnorm = 1;
[ax,h1,h2] = plotyy(amc.Ip(:,1),amc.Ip(:,2)/Ipnorm,dBint(:,1),dBint(:,2));
axes(ax(1));
tlow  = min(find(amc.Ip(:,1)>=t(1)))
thigh = max(find(amc.Ip(:,1)<=t(2)))
axis([t(1) t(2) 0 0.8]);
ylabel(['I_p [MA]'],'FontSize', fs);
set(h1,'LineWidth',lw,'LineStyle','-','Color','k')
set(gca,'FontSize', fs, 'LineWidth',bw,'Box','on','TickLength',[0.02 0.02],'TickDir','in');
set(gca,'XTickLabel',{},'XColor','k','YColor','k')
set(gca,'Ytick',[0 0.4 0.8])

axes(ax(2));
axis([t(1) t(2) min(dBint(:,2)) max(dBint(:,2))]);
ylabel(['B_r [T]'],'FontSize', fs);
set(gca,'XTickLabel',{},'XColor','k','YColor','k')
set(h2,'LineWidth',cw*lw,'LineStyle','-','Color','c')
set(gca,'FontSize', fs, 'LineWidth',bw,'Box','on','TickLength',[0.02 0.02],'TickDir','in');
set(gca,'YTick',[-50 -25 0])
set(gca,'YTickLabels',[-50 -25 0])
clear hleg hlabel
hleg(1)   = h1; 
hleg(2)   = h2; 
hlabel{1} = 'I_p';
hlabel{2} = 'I_{sol}';  



% spectrum
% ------------------------------------------------------------------

tmin = t(1);
tmax = t(2);
tmin = min(xmd.omt(1).signal(:,1));
tmax = max(xmd.omt(1).signal(:,1));


% tmin = 0.250
% tmax = 0.270

clear ymd

Ncoils = size(xmd.omt,2)

for i=1:Ncoils
  if xmd.omt(i).data
     imin = min(find(xmd.omt(i).signal(:,1)>=tmin));
     imax = min(find(xmd.omt(i).signal(:,1)>=tmax));
     ymd.omt(i).data = 1;
     ymd.omt(i).phi  = xmd.omt(i).phi;
     ymd.omt(i).signal(1:imax-imin+1,:) = xmd.omt(i).signal(imin:imax, :);
     ymd.omt(i).signal(1:imax-imin+1,:) = xmd.omt(i).signal(imin:imax, :);     

     % average over clock - it has a huge dither MJH 08/11/06
     dt_trace = diff(ymd.omt(i).signal(:,1));
     dt   = mean(dt_trace);     

     tmin = min(ymd.omt(i).signal(:,1));
     tmax = max(ymd.omt(i).signal(:,1));     
  end;
  
  if xmd.omr(i).data
     imin = min(find(xmd.omr(i).signal(:,1)>=tmin));
     imax = min(find(xmd.omr(i).signal(:,1)>=tmax));
     ymd.omr(i).data = 1;
     ymd.omr(i).phi  = xmd.omr(i).phi;
     ymd.omr(i).signal(1:imax-imin+1,:) = xmd.omr(i).signal(imin:imax, :);
     ymd.omr(i).signal(1:imax-imin+1,:) = xmd.omr(i).signal(imin:imax, :);     
  end;

  if xmd.omv(i).data
     imin = min(find(xmd.omv(i).signal(:,1)>=tmin));
     imax = min(find(xmd.omv(i).signal(:,1)>=tmax));
     ymd.omv(i).data = 1;
     ymd.omv(i).phi  = xmd.omv(i).phi;
     ymd.omv(i).signal(1:imax-imin+1,:) = xmd.omv(i).signal(imin:imax, :);
     ymd.omv(i).signal(1:imax-imin+1,:) = xmd.omv(i).signal(imin:imax, :);     
  end;
end;

disp(['Spectrum ======================================']);

winl    = 2*512;
flow    = 150e+3
flow    = 2/(winl * dt)
fhigh   = 100e+3

disp(['Normalization =================================']);
winl    = 1024
norm    = spec_norm(winl)

disp(['Spectrum ======================================']);
YMD.omt = spec(ymd.omt(1), winl, norm, 0, flow, fhigh);

tnorm = 1e-3
fnorm = 1e+3
figure(h);
subplot('Position', [0.15 0.80 0.75 0.14]);
imagesc(YMD.omt(1).t,YMD.omt(1).f/fnorm, log10(abs(YMD.omt(1).F)));
axis xy;
colormap(jet)
y(1) = 0;
y(2) = fhigh;
axis([t(1) t(2) 0 fhigh/fnorm]);
ylabel('f [kHz]','FontSize', fs);
set(gca,'XTickLabel',{},'XColor','k','YColor','k')
set(gca,'FontSize', fs, 'LineWidth',bw,'Box','on','TickLength',[0.02 0.02],'TickDir','in');

title(['MAST shot ', num2str(shot)]); 


return


% locked mode \delta B
% =====================================================

