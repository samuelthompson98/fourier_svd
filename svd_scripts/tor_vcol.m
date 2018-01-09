
function [Z]=tor_vcol(xdat, time, t1, f0)

% MJH 17/06/03
% plot time series data versus centre column height

[Nt,Ncoils] = size(xdat)

Nperiods = 20;
t2 = t1 + 20/f0;
t1_index = min(find(time>t1))
t2_index = max(find(time<t2))

figure; hold on;
for j=1:Ncoils

   ynorm = max(abs(xdat(t1_index:t2_index,j)));    
   plot(time(t1_index:t2_index),xdat(t1_index:t2_index,j)/ynorm);
   for m=t1_index:t2_index
       k = m+1-t1_index;
       Z(j,k)   = fix(1024*(xdat(m,j)/ynorm + 1));
       phase(j) = j/Ncoils * 360;
       time(k)  = time(m); 
  end;
end;
axis([t1 t2 -1 1]);

figure;
imagesc(time,phase,Z)
     xlabel('time');
     ylabel('phase');

% ================================================
% Make colormap

Nmap=1024;
r(1)=1;
g(1)=1;
b(1)=1;
map_index = 1;
for i=1:Nmap
  r(i)=((i-1)/(Nmap-1))^(map_index);
  g(i)=((i-1)/(Nmap-1))^(map_index);
  b(i)=((i-1)/(Nmap-1))^(map_index);
end;

for k=1:Nmap
  map(k,:) = [r(k) g(k) b(k)];
end;
colormap(map)

return;
