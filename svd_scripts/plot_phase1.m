
function plot_phase1(Z1, Z2)

figure
subplot(2,1,1); hold on;
plot(Z1.f, abs(Z1.a),'b-')
plot(Z2.f, abs(Z2.a),'r-')
set(gca,'YScale','log');

subplot(2,1,2); hold on;
plot(Z1.f, 180/pi*angle(Z1.a) - 180/pi*angle(Z2.a));

return