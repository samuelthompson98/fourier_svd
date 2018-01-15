function render_example(X,tnorm, fnorm)

global dt df

t   = X.t;%/tnorm;
fl  = X.f;%/fnorm;
bpl = X.F;
df  = X.df;%/fnorm;
dt  = X.dt;%/tnorm;

%disp(1e6 * abs(bpl(290:end, 1000)))
%[1 1] + [1 1 1]
offset = 100;
for i = 1:size(t)
    t(i)
    abs(bpl(offset:200, i))'
    index = find(max(bpl(offset:end, i))) + offset - 1
    fl(index)
    fl(1:200) %fl(index + offset - 1)
end
[1 1] + [1 1 1]

% render spectrogram
set(0,'DefaultFigureVisible','on'); 
h=figure;
fs = 14;
lw = 1.5;
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

imagesc(t+toff,fl,log10(abs(bpl))); 
axis xy;
colormap(jet);
xlabel(['t [ms], dt=', num2str(1/df), '[ms]']);
ylabel(['f [kHz], df= ', num2str(df), '[kHz]']);

hspec = gca;

% insert for rendering to paper
Nmap = 64;
mul  = 1.8;
k    = 1;
for i=1:Nmap
    RGB = 1 - (k*(i-1)/(Nmap-1))^(mul);
    cmap(i,1:3) = RGB;
end;

colormap(jet);
colormap(bone);
map = colormap(jet);
map1(65:128,:) = map;

map1(1:65+16,3)   = 1;
map1(1:65+16,1)   = (1:-1/(64+16):0).';
map1(1:65+16,2)   = (1:-1/(64+16):0).';

map2 = colmap(0.7);
map2 = colmap(0.0);
colormap(map2);

hbar = colorbar;
ylabel(hbar, 'log_{10} |\delta B| [T Hz^{-1}]')
%axes; %axes(hbar)
%set(gca,'FontSize',fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;
%ylabel(['log_{10} |\delta B| [T Hz^{-1}]']);

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