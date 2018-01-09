
function plot_biphase(bispec, flow, fhigh, f0)

ifk_range = find((bispec.fk(:,1)>flow)&(bispec.fk(:,1)<fhigh));
ifl_range = find((bispec.fl(1,:)>flow)&(bispec.fl(1,:)<fhigh));

[junk, ifk_vec]  = max(abs(bispec.Bn(ifk_range,ifl_range)));
[junk, ifk_posn] = max(max(abs(bispec.Bn(ifk_range,ifl_range))));

ifk = ifk_vec(ifk_posn) + min(ifk_range);
f1  = bispec.fk(ifk,1);

figure

fs = 14;
lw = 1.5;
set(gca,'FontSize',fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;

subplot(2,1,1); hold on;
set(gca,'FontSize',fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;

plot(bispec.fl(ifk-2,:), abs(bispec.Bn(ifk-2,:)),'k:')
plot(bispec.fl(ifk-1,:), abs(bispec.Bn(ifk-1,:)),'k:')
plot(bispec.fl(ifk+0,:), abs(bispec.Bn(ifk+0,:)),'k','LineWidth',1.5)
plot(bispec.fl(ifk+1,:), abs(bispec.Bn(ifk+1,:)),'k:')
plot(bispec.fl(ifk+2,:), abs(bispec.Bn(ifk-2,:)),'k:')

if0 = min(find(bispec.fl(ifk,:)>= f0))
f0p = bispec.fl(ifk,if0)

nf_max = floor(max(bispec.fl(ifk,:))/f0)
for i=1:nf_max
    x(i) = i * f0;
    yabs(i) = abs(bispec.Bn(ifk,i * if0));
    yang(i) = angle(bispec.Bn(ifk,i * if0))/pi*180;
end;
plot(x,yabs,'ko', 'MarkerSize', 14)
ylabel(['|B|']);
title(['bispectrum slice along f_l at f_k = ',num2str(f1)]);

subplot(2,1,2); hold on;
set(gca,'FontSize',fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;

plot(bispec.fl(ifk-2,:), angle(bispec.Bn(ifk-2,:))/pi * 180,'k:')
plot(bispec.fl(ifk-1,:), angle(bispec.Bn(ifk-1,:))/pi * 180,'k:')
plot(bispec.fl(ifk+0,:), angle(bispec.Bn(ifk+0,:))/pi * 180,'k','LineWidth',1.5)
plot(bispec.fl(ifk+1,:), angle(bispec.Bn(ifk+1,:))/pi * 180,'k:')
plot(bispec.fl(ifk+2,:), angle(bispec.Bn(ifk+2,:))/pi * 180,'k:')
plot(x,yang,'ko', 'MarkerSize', 14);
    
xlabel(['f [Hz]']);
ylabel(['<B']);

return