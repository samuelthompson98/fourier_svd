
function [h]=render_kstar10(X,tnorm, fnorm, fc, snr)

global dt df

X   = fit_mag_power3( X )

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

Nf    = length(fl);
Nt    = length(t);
i_cut = min(find(X.f>fc));
eps   = 0.01 * snr * X.alpha * fl(i_cut)^X.beta;

% MJH 16/09/2013. Insertion to stop colormap changing span
Fmin  = min(min(abs(X.F)));

for i_row=1:i_cut-1
    [i_col] = find(abs(bpl(i_row,:)) < snr * X.alpha * fl(i_cut)^X.beta);
    bpl(i_row, i_col) = max([eps Fmin]);
    disp(['f = ',num2str(fl(i_row)),' =========================']);
    disp(['i_col/i_tot = ',num2str(length(i_col)/Nt),' elminated']);
    % for j=1:length(i_col)
    %     disp(['t = ',num2str(t(i_col(j))),' elminated']);
    % end   
end
 
for i_row=i_cut:Nf
    [i_col] = find(abs(bpl(i_row,:)) < snr * X.alpha * fl(i_row)^X.beta);
    % bpl(i_row, i_col) = 0.1 * snr * X.alpha * fl(i_row)^X.beta;
    % bpl(i_row, i_col) = Fmin;
    bpl(i_row, i_col) = min([abs(bpl(i_row, i_col)) 0.1 * snr * X.alpha * fl(i_row)^X.beta]);
    disp(['f = ',num2str(fl(i_row)),' =========================']);
    disp(['i_col/i_tot = ',num2str(length(i_col)/Nt),' elminated']);
    % for j=1:length(i_col)
    %     disp(['t = ',num2str(t(i_col(j))),' elminated']);
    % end   
end

imagesc(t+toff,fl,log10(abs(bpl)));

axis xy;
Nmap = 128;
colormap(kstar_cmap2(Nmap));
colormap(kstar_cmap(Nmap));

xlabel(['t [s], dt=',num2str(1/df), '[s]']);
ylabel(['f [Hz], df= ',num2str(df), '[Hz]']);

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

