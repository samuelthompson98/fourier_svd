
function [Z]=tor_col(x,t1,f0)

% MJH 17/06/03
% plot time series data versus centre column height

[junk,Ncoils] = size(x)

Nt = size(x(1).signal,1);

Nperiods = 20;
t2 = t1 + 20/f0;

t1_index = min(find(x(1).signal(:,1)>t1));
t2_index = max(find(x(1).signal(:,1)<t2));

figure; hold on;
for j=1:Ncoils

  i = Ncoils+1-j;
  if x(i).data
     t_frame = find((x(i).signal(:,1)>=t1)&(x(i).signal(:,1)<=t2));
     ynorm = max(abs(x(i).signal(t_frame,2)));    
     plot(x(i).signal(:,1),x(i).signal(:,2)/ynorm);
     for m=t1_index:t2_index
       k = m+1-t1_index;
       Z(i,k)   = fix(1024*(x(i).signal(m,2)/ynorm + 1));
       phase(i) = x(i).phi; 
       time(k)  = x(i).signal(m,1); 
     end;
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
