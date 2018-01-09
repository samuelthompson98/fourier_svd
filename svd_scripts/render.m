
function render(X)

global dt df

t   = X.t;
fl  = X.f;
bpl = X.F;
df  = X.df;
dt  = X.dt;

% render spectrogram
set(0,'DefaultFigureVisible','on'); 
h=figure;
fs = 14;
lw = 1.5;
set(gca,'FontSize',fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;

% imagesc(t,fl,20*log10(abs(bpl))); 

imagesc(t,fl,log10(abs(bpl))); 
axis xy;
colormap(jet);
xlabel(['t [s], dt=',num2str(1/df),'[s]']);
ylabel(['f [Hz], df= ',num2str(df), '[Hz]']);

hspec = gca;

% insert for rendering to paper
Nmap = 64;
mul  = 1.8;
k    = 1;
for i=1:Nmap
    RGB = 1 - (k*(i-1)/(Nmap-1))^(mul);
    cmap(i,1:3) = RGB;
end;

colormap(cmap)

hbar = colorbar;
axes(hbar);
set(gca,'FontSize',fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;
ylabel(['log_{10} |\delta B| [T Hz^{-1}]']);

axes(hspec)

% str(1) = {'20 log_{10} |F(f)|'};
% set(gcf,'CurrentAxes')
% text(0.96,.4,str,'Rotation',90)

return;

