% MJH 04/02/03

% ns = sampling mode number 
% N  = number of coils 
% f  = amplitude of ideal signal

clear all;

ns=40; N=3; f=1;

th(1) = 0;
th(2) = 9/180*pi;
th(3) = 60/180*pi;

th(1)=6/180*pi;
th(2)=306/180*pi;
th(3)=357/180*pi;


for dn=1:ns+1

   x =0; 
   for i=1:N
     x = exp(-1i * (dn-1) * th(i)) + x; 
   end;
 
   r(dn, 1) = dn-1;
   r(dn, 2) = sqrt(N*f^2 - f^2/N * x * x')/(sqrt(N*f^2));

end;

% figure 7a ===================================================================
figure;
marker2.LineStyle = ':';
marker2.Color     = 'k';
marker2.Marker    = 'o';
marker1.LineStyle = '-';
marker1.Color     = 'k';


subplot(2,1,1); hold on;
fs = 14;  % font size
lw = 1.5; % line width
set(gca,'FontSize', fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;

plot(r(:,1), r(:,2), marker2);
ylabel('r_s');
xlabel('\Delta n');

% figure 7b ===================================================================

% sort r into increasing residue order
[junk, index] = sort(r(:,2),1);
x(1:ns+1,1:2) = r(index,1:2);

subplot(2,1,2);
set(gca,'FontSize', fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;
plot(x(:,2), x(:,1),marker2); 
ylabel('\Delta n');
xlabel('r_s');

% figure 8 ===================================================================
figure; hold on;
set(gca,'FontSize', fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;

for i=1:ns+1 plot(i,x(i,2),marker2); end;

plot(1:ns+1,x(1:ns+1,2),marker2)

y(:,1) = (0:1:ns)';
y(:,2) = 1/ns*y(:,1);
plot(y(:,1), y(:,2),marker1);
ylabel('r');
xlabel('N[\Delta n]');

