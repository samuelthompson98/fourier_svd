
function [h]=render_nmode_M2a(X,tnorm, fnorm, n_alias, snr, fc)

% MJH 22/03/2013
% Revert to JET color map

for M=1:2

t   = X.t/tnorm;
fl  = X.f/fnorm;
bpl = reshape(X.n(:,M,:), length(fl), length(t));
amp = reshape(X.a(:,M,:), length(fl), length(t));

% =======================================================
% cutoff, below this (fit to power law)*snr modes mapped to white
% MJH 26/04/2012. Apply cut-off to nloise threshold below fc

Nt  = length(X.t);
Nf  = length(X.f);

i_cut = min(find(X.f>fc));

for i_row=1:i_cut-1
    [i_col] = find(abs(amp(i_row,:)) < snr * X.alpha * fl(i_cut)^X.beta);
    bpl(i_row, i_col) = -n_alias-1;
    disp(['i_col/i_tot = ',num2str(length(i_col)/Nt),' elminated']);
end
 
for i_row=i_cut:Nf
    [i_col] = find(abs(amp(i_row,:)) < snr * X.alpha * fl(i_row)^X.beta);
    bpl(i_row, i_col) = -n_alias-1;
    disp(['i_col/i_tot = ',num2str(length(i_col)/Nt),' elminated']);
end

% [i_row, i_col] = find(bpl == (-n_alias -1));

% render spectrogram
set(0,'DefaultFigureVisible','on'); 
h(M) =figure;
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
hax(M) = imagesc(t+toff,fl,bpl, [-n_alias-1 n_alias]);


axis xy;
colormap(jet);
xlabel(['t [s]']);
ylabel(['f [Hz]']);
title(['M = 2']);

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
end


LinkFigures([h(1) h(2)],'xy');

%linkaxes([h(1) h(2)],'x');
%linkaxes([hax(1) hax(2)],'xy');

figure(h(1));

tlin= (min(t)+max(t+twin))/2;
fmin= min(fl);
fmax= max(fl);

hax  = gca;
hlin = imline(hax, [tlin fmin; tlin fmax]);

filt.gaussian  = 0;
filt.arbitrary = 0;

hpos      = hlin.getPosition()
[Z,hfig]  = pltn_M2data3(X, n_alias, hpos(1), 4, filt);

stop = 0;
while ~stop
    hpos      = wait(hlin)
    [Z, hfig] = pltn_M2data3(X, n_alias, hpos(1), 4, filt, hfig);
    if hpos(1,2) < 0
        stop = 1;
    end
    
end

return;



