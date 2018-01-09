function pltn_hanbit(Z)

% plots eigen-mode amplitudes and residue as a fn. of freq
% Matthew Hole Jan. 2002 
% plot n mode number versus frequency

fs = 14;  % font size
lw = 1.5; % line width

h=figure;
set(gca,'FontSize', fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;

% ===============================================================
h2 = subplot(2,1,2)
set(gca,'FontSize', fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;
ylabel('r');
hold on;

% define residue tupe
residue.MarkerFaceColor ='k';
residue.MarkerSize      =3;
residue.Marker          ='o';
residue.LineStyle       = '-';
residue.Color           = 'k';
residue.LineWidth       = 1.5;

Nf = length(Z.f);
NM = size(Z.n, 2);

% plot residue
semilogy(Z.f,abs(Z.dF),residue); % plot common residure

% for i=1:Nf
%    semilogy(Z.f(i),abs(Z.dF(i)),residue); % plot common residure
% end;

fmin = min(Z.f);
fmax = max(Z.f);
rmin = 0.5 * 10^(floor(log10(min(abs(Z.dF)))));
rmax = 2;
axis([fmin fmax rmin rmax]);
set(gca, 'YScale','log','Box','on','YTick',[0.01 0.1 1])

% ===============================================================
h1 = subplot(2,1,1)


set(gca,'FontSize', fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;
ylabel('|\delta B| [T Hz^{-1}]');
hold on;

% plot the  amplitude of the mode(s)
Nc=Z.Nc; l(1:2*Nc+1,1)=1;

% Values of OMAHA taken from stray capacitance paper 
Ncoils = 30;
A      = pi* (10.7e-3)^2;
for i=1:Nf
 for j=1:NM
 
   x(l(Z.n(i,j)+Nc+1),Z.n(i,j)+Nc+1) = Z.f(i);
   % y(l(Z.n(i,j)+Nc+1),Z.n(i,j)+Nc+1) = abs(Z.a(i,j)) * 1/(2*pi*Z.f(i)*Ncoils * A);
   y(l(Z.n(i,j)+Nc+1),Z.n(i,j)+Nc+1) = abs(Z.a(i,j));
   l(Z.n(i,j)+Nc+1) = l(Z.n(i,j)+Nc+1) + 1;

 end;
end;

str=[];
amin = 1; amax = 1e-15;

for n=-Nc:Nc
  if l(n+Nc+1)-1>0
    nlabel = mtype(n);
    plot(x(1:l(n+Nc+1)-1,n+Nc+1), y(1:l(n+Nc+1)-1,n+Nc+1), nlabel);

    amin = min([min(y(1:l(n+Nc+1)-1,n+Nc+1)) amin]);
    amax = max([max(y(1:l(n+Nc+1)-1,n+Nc+1)) amax]);
   
    % if n > 11 ;
    %      str = strvcat(str,['n > 11 ']);
    % elseif n < -11 ;
    %     str = strvcat(str,['n < -11 ']);
    % else 
         str = strvcat(str,['n = ',num2str(n)]);
    % end
  end;
end;

legend(str);
% amin = 1; amax = 1e-15;
% for i=1:NM
    % amin = min([min(abs(Z.a(:,i))) amin]);
    % amax = max([max(abs(Z.a(:,i))) amax]);
    % amin = min([min(min(y(:,:))) amin]);
    % amax = max([max(max(y(:,:))) amax]);
% end;

mmin = 1.0 * 10^(floor(log10(amin)));
mmax = 1 *  10^(ceil(log10(amax)));
axis([fmin fmax mmin mmax]);
set(gca, 'YScale','log', 'Box','on','YTick',[10*mmin mmax/10])




return;
