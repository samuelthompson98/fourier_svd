% MJH 04/02/03

% Nk = number of samples
% ns = sampling mode number 
% N  = number of coils 
% f  = amplitude of ideal signal

% MJH 07/06 copied from coil_posns_2000 developed for 2003 EPS.

clear all;


Nk=10000; ns=40; N=3; f=1;
Nk=20000; ns=40; N=4; f=1;

ths = 2*pi/ns;

% for Nk random coil configurations 
for k=1:Nk

    th(1) = 0;
    th(2) = rand * ths;
    for i=3:N  th(i) = rand * (2*pi-ths) + ths; end;

    % remap to remove reflections and rotations ======================
    th = remap(th);

    % for all incorrect fits
    for dn=1:ns

        x =0; 
        for i=1:N
            x = exp(-1i * dn * th(i)) + x; 
       end;
 
       r(dn) = sqrt(N*f^2 - f^2/N * x * x');

    end;

    [rmin,index] = min(r);
    eps = 1.0e-6;

    if imag(rmin)/abs(rmin)>eps 
        err(['x*x''' is not real']);
    else
        rmin = real(rmin);
    end;
   
    X(k,1)     = rmin/(sqrt(N*f^2));
    X(k,2)     = index;
    X(k,3:N+2) = th(1:N);
    
end;

h(1)=figure; hold on;
fs = 14;  % font size
lw = 1.5; % line width
set(gca,'FontSize', fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;

for i=1:N
  plot(X(:,1), X(:,2+i)*180/pi,'k.');
end;
xlabel(['r_{min}']);
ylabel(['\theta [deg]']);


th_coils = [0 9 60];
plot([0 1], [th_coils(2) th_coils(2)], 'k--','LineWidth', 1.5) 
plot([0 1], [th_coils(3) th_coils(3)], 'k--','LineWidth', 1.5) 
axis([0 1 0 180]);
return;


