
function rendert(x,tevol)

% render time slice at t = tevol
t_index = min(find(x.tevol>tevol));
x
plot(x.tF,x.signal(:,t_index));

return;

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

