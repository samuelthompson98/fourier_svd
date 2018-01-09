
function [h]=render_nmode3(X,tnorm, fnorm, n_alias, snr, fc)

% MJH 22/03/2013
% Revert to JET color map

t   = X.t/tnorm;
fl  = X.f/fnorm;
bpl = X.n;
amp = X.a;
dF  = X.dF;
dF_min = 0.99;
% =======================================================
% cutoff, below this (fit to power law)*snr modes mapped to white
% MJH 26/04/2012. Apply cut-off to nloise threshold below fc

Nt  = length(X.t);
Nf  = length(X.f);

i_cut = min(find(X.f>fc));

for i_row=1:i_cut-1
    [i_col] = find((abs(amp(i_row,:)) < snr * X.alpha * fl(i_cut)^X.beta));
    [i_col1]= find(dF(i_row,:) > dF_min);
    i_col   = union(i_col, i_col1);
    bpl(i_row, i_col) = -n_alias-1;
    disp(['i_col/i_tot = ',num2str(length(i_col)/Nt),' elminated']);
end
 
for i_row=i_cut:Nf
    [i_col] = find((abs(amp(i_row,:)) < snr * X.alpha * fl(i_row)^X.beta));
    [i_col1]= find(dF(i_row,:) > dF_min);
    i_col   = union(i_col, i_col1);
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
title(['M = 1 for snr = ',num2str(snr),', dF\_min = ',num2str(dF_min)]);


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
ylabel(['n']);

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



