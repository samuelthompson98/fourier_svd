
function [Z]=tor_xcol(x,f0,t)

% MJH 17/06/03
% plot time series data versus centre column height

[junk,Ncoils] = size(x)

Nt = size(x(1).signal,1);

% find time slice within ift reconstruction
Nperiods = 20;
t1 = 0;
t2 = t1 + 20/f0;
t1_index = min(find(x(1).tF > t1))
t2_index = max(find(x(1).tF < t2))

% find time slice of ift reconstruction
t_index  = min(find(x(1).tevol>t));

figure; hold on;
for j=1:Ncoils

  i = Ncoils+1-j;
  if x(i).data
     ynorm = max(abs(x(i).signal(t1_index:t2_index,t_index)))   
     plot(x(i).tF(t1_index:t2_index),real(x(i).signal(t1_index:t2_index,t_index)/ynorm));
     for m=t1_index:t2_index
       k = m+1-t1_index;
       Z(i,k) = fix(1024*(real(x(i).signal(m,t_index))/ynorm + 1));
     end;
  end;

end;
axis([t1 t2 -1 1]);

figure;
imagesc(Z)

return;
