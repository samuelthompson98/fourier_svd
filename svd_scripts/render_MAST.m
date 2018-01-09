
function [h]=render_MAST(X,tnorm, fnorm, varargin)

global dt df

t   = X.t/tnorm;
fl  = X.f/fnorm;
bpl = X.F;
df  = X.df/fnorm;
dt  = X.dt/tnorm;

% render spectrogram
fs = 16;
lw = 2;
if isempty(varargin)
    set(0,'DefaultFigureVisible','on'); 
    h=figure;
    set(gca,'FontSize',fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;
end

% imagesc(t,fl,20*log10(abs(bpl))); 

% MJH offset time such that signal plotted over interval of fourier transform (not start)
if length(t)>1
  toff = (t(2)-t(1))/2;
  twin = t(2)-t(1);
else
  toff = 0;
  twin = 0;
end;

%imagesc(t+toff,fl,log10(abs(bpl))); 
imagesc(t+toff,fl,log10(abs(bpl)));
imagesc(t+toff,fl,log10(abs(bpl)));

axis xy;
if isempty(varargin)
    xlabel(['t [s], dt=',num2str(1/df), '[s]']);
    ylabel(['f [Hz], df= ',num2str(df), '[Hz]']);
end

hspec = gca;



% cmap = colormap(jet);
% It gives black and white color table
%cmap = colormap(bone);
Nmap = 128;
cmap = colormap(jet(Nmap));
cmap = cmap .^ 0.1;

% set dynamic range of signals < eps to zero

eps     = 0.2; % cutoff, below this all amplitudes mapped to white
eps1    = 0.5;   % amplitudes mapped from white (eps) to blue (eps1)
eps2    = 0.8;   % amplitudes mapped from blue (eps1) to green (eps2)

Nlow    = round(eps*Nmap)
N1       = round(eps1*Nmap)
N2       = round(eps2*Nmap)
N3       = Nmap;

cmap(1:Nlow, :) = 1;

cmap(Nlow+1:N1,1) = ((1:-1/(N1-Nlow-1):0)').^0.5;
cmap(Nlow+1:N1,2) = ((1:-1/(N1-Nlow-1):0)').^0.5;
cmap(Nlow+1:N1,3) = 1;

cmap(N1+1:N2,1) = 0;
cmap(N1+1:N2,2) = ((0:1/(N2-N1-1):1)').^1;
cmap(N1+1:N2,3) = ((1:-1/(N2-N1-1):0)').^1;

cmap(N2+1:N3,1) = ((0:1/(N3-N2-1):1)').^1;
cmap(N2+1:N3,2) = ((1:-1/(N3-N2-1):0)').^1
cmap(N2+1:N3,3) = 0;

colormap(cmap);

if isempty(varargin)
    hbar = colorbar;
    axes(hbar);
    set(gca,'FontSize',fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;
    ylabel(['log_{10} |\delta B| [T Hz^{-1}]']);
end

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

