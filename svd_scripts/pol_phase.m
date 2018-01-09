
function pol_phase(X,t,f)
[junk,Ncoils] = size(X)

% ================================================
% Make colormap

Nmap=100
for i=1:Nmap
  r(i)=sin(pi*i/Nmap);
  g(i)=sin(pi*i/Nmap);
  b(i)=sin(pi*i/Nmap);
  map(i,:) = [r(i) g(i) b(i)];
end;

colormap(map);
% ================================================

figure;
hold on;

Fmax=0;

for i=1:Ncoils
  if X(i).data==1
   tx  = X(i).t;
   fx  = X(i).f;
   t_index = max(find(tx<t));
   f_index = max(find(fx<f));
   subplot(2,1,1); hold on;
   plot(i,abs(X(i).F(f_index,t_index)),'ko-');
   Fmax= max([Fmax max(abs(X(i).F(f_index,t_index)))]);
   subplot(2,1,2); hold on;
%   plot(i,angle(X(i).F(f_index,t_index))-angle(X(3).F(f_index,t_index)),'ko-');
   plot(i,angle(X(i).F(f_index,t_index))*180/pi,'ko-');
  end;
end;

subplot(2,1,1); hold on;
axis([0 40 0 Fmax]);

Fmax
return;

subplot(2,1,2);
hold on;
for i=1:Ncoils
  if X(i).data==1
    plot(i,angle(X(i).F(f_index,t_index)),'ko-');
%    plot(i,angle(X(i).F(f_index,t_index))-angle(X(3).F(f_index,t_index)),'ko-');
  end;
end;

hold off;

return;
