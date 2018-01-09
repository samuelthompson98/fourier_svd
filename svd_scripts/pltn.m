function pltn(Z)

% plots eigen-mode amplitudes and residue as a fn. of freq
% Matthew Hole Jan. 2002 
% plot n mode number versus frequency
h=figure;
h1=subplot(2,1,1);
ylabel('mode amplitude');
title(['n mode spectrum at t=', num2str(Z.t),', for shot ', num2str(Z.shot)]);
hold on;
h2=subplot(2,1,2);
ylabel('residue');
hold on;

% define residue tupe
residue.MarkerFaceColor='k';
residue.MarkerSize=6;
residue.Marker='o';

Nf = length(Z.f);
NM = size(Z.n, 2);

% plot residue
for i=1:Nf
   subplot(2,1,2);
   semilogy(Z.f(i),abs(Z.dF(i)),residue); % plot common residure
end;

% plot the  amplitude of the mode(s)
Nc=Z.Nc; l(1:2*Nc+1,1)=1;
for i=1:Nf
 for j=1:NM
 
   x(l(Z.n(i,j)+Nc+1),Z.n(i,j)+Nc+1) = Z.f(i);
   y(l(Z.n(i,j)+Nc+1),Z.n(i,j)+Nc+1) = abs(Z.a(i,j));
   l(Z.n(i,j)+Nc+1) = l(Z.n(i,j)+Nc+1) + 1;

 end;
end;

set(gca, 'YScale','log')

subplot(2,1,1);
hold on;

str=[];
for n=-Nc:Nc
  if l(n+Nc+1)-1>0
    nlabel = mtype(n);
    plot(x(1:l(n+Nc+1)-1,n+Nc+1), y(1:l(n+Nc+1)-1,n+Nc+1), nlabel);
    if n > 6 ;
         str = strvcat(str,['n > 6 ']);
    elseif n < -6 ;
         str = strvcat(str,['n < -6 ']);
    else 
         str = strvcat(str,['n = ',num2str(n)]);
    end
  end;
end;

legend(str);
set(gca, 'YScale','log')

return;
