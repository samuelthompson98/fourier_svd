

% ================================================
% Make colormap
load clown.mat

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

imagesc(X)

     colormap(map);
     hold on;

x = 1:1:100;
y = 2*x;
plot(x, y, 'Color',map(24,:))



return;
