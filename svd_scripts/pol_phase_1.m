
function pol_phase_1(X,t,f)
[junk,Ncoils] = size(X)

tx  = X(1).t;
fx  = X(1).f;

t_index = max(find(tx<t))
f_index = max(find(fx<f))

% ================================================
% Make colormap

Nmap=100
for i=1:Nmap
  r(i)=sin(2*pi*i/Nmap)+1;
  g(i)=sin(2*pi*i/Nmap)+1;
  b(i)=sin(2*pi*i/Nmap)+1;
  map(i,:) = [r(i)/2 g(i)/2 b(i)/2];
end;

colormap(map);
% ================================================

figure;
clear x;
for j=1:36
  xa(:,j)   = abs(X(j).F(f_index,:)).';
  xp(:,j)   = angle(X(j).F(f_index,:)).';
  phase(j) = j;
end;
xa=xa.';
time  = tx;

% phase reference
for j=1:36
  xp(:,j)   = (xp(:,j)-xp(:,6)+pi)/(2*pi);
end;
xp=xp.';

imagesc(time,phase,20*log10(xa));
colormap(jet);

figure;
imagesc(time,phase,xp);
colormap(map);

return;

