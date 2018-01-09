
function [h]=render_fild1(X,tnorm, fnorm)

global dt df

t   = X.t/tnorm;
fl  = X.f/fnorm;
bpl = X.F;
df  = X.df/fnorm;
dt  = X.dt/tnorm;

% render spectrogram
set(0,'DefaultFigureVisible','on'); 
h=figure;
fs = 16;
lw = 2;
set(gca,'FontSize',fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;

% imagesc(t,fl,20*log10(abs(bpl))); 

% MJH offset time such that signal plotted over interval of fourier transform (not start)
if length(t)>1
  toff = (t(2)-t(1))/2;
  twin = t(2)-t(1);
else
  toff = 0;
  twin = 0;
end;

imagesc(t+toff,fl,log(abs(bpl)));

axis xy;
colormap(jet);
% colormap(kstar_cmap(128))
xlabel(['t [s], dt=',num2str(1/df), '[s]']);
ylabel(['f [Hz], df= ',num2str(df), '[Hz]']);

hspec = gca;

hbar = colorbar;
axes(hbar);
set(gca,'FontSize',fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;
ylabel(['Counts']);

axes(hspec);
if length(t)>1
    axis([min(t) max(t+twin) min(fl) max(fl)]);
else
    axis([0 1 min(fl) max(fl)]);
end

% str(1) = {'20 log_{10} |F(f)|'};
% set(gcf,'CurrentAxes')
% text(0.96,.4,str,'Rotation',90)

return;

