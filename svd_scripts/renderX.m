
function renderX(X)

global dt df

t   = X.t;
fl  = X.f;
bpl = X.F;
df  = X.df;
dt  = X.dt;

% render spectrogram
imagesc(t,fl,20*log10(abs(bpl))); 
axis xy;
colormap(jet);
xlabel(['t [s], dt=',num2str(1/df),'[s]']);
ylabel(['f [Hz], df= ',num2str(df), '[Hz]']);

colorbar;
% str(1) = {'20 log_{10} |F(f)|'};
% set(gcf,'CurrentAxes')
% text(0.96,.4,str,'Rotation',90)

return;

