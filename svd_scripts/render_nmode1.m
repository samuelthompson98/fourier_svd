
function [h]=render_nmode1(X,tnorm, fnorm, n_alias, snr)


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
    bpl(i_row, i_col) = -n_alias-1;
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
imagesc(t+toff,fl,bpl, [-n_alias-1 n_alias]);


axis xy;
colormap(jet);
xlabel(['t [s]']);
ylabel(['f [Hz]']);

hspec = gca;



% cmap = colormap(jet);
% It gives black and white color table
%cmap = colormap(bone);
Nmap = 2*n_alias+1;
cmap = colormap(jet(Nmap));
cmap1(2:Nmap+1,:) = cmap;
cmap1(1,1:3) = 1;
colormap(cmap1);

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



