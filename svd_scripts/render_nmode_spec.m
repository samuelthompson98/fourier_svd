
function [h]=render_nmode_spec(X,tnorm, fnorm,snr)


t   = X.t/tnorm;
fl  = X.f/fnorm;
bpl = X.n;
amp = X.a;

% =======================================================
% cutoff, below this (fit to power law)*snr modes mapped to white

Nt  = length(X.t);
Nf  = length(X.f);
for i_row=1:Nf
    [i_col] = find(abs(amp(i_row,:)) < snr * X.alpha * fl(i_row)^X.beta);
    amp(i_row, i_col) = 0.0;
    disp(['i_col/i_tot = ',num2str(length(i_col)/Nt),' elminated']);
end

% [i_row, i_col] = find(bpl == (-n_alias -1));

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

%imagesc(t+toff,fl,log10(abs(bpl))); 
imagesc(t+toff,fl,log10(abs(amp)));

Nmap = 128;
cmap = colormap(jet(Nmap));
cmap = cmap .^ 0.1;

% set dynamic range of signals < eps to zero

eps      = 0.1; % cutoff, below this all amplitudes mapped to white
eps1    = 0.7;   % amplitudes mapped from white (eps) to blue (eps1)
eps2    = 0.9;   % amplitudes mapped from blue (eps1) to green (eps2)

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

cmap
colormap(cmap);

xlabel(['t [s]']);
ylabel(['f [Hz]']);

hspec = gca;


hbar = colorbar;
axes(hbar);
set(gca,'FontSize',fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;
ylabel(['log_{10} |\delta B| [T Hz^{-1}]']);

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



