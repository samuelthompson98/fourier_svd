
function pol_phase_2(X,t)
[Nphase,Ncoils] = size(X)

% ================================================
% Make colormap

%Nmap=99
%for i=1:Nmap
%  r(i)=sin(2*pi*i/Nmap)+1;
%  g(i)=sin(2*pi*i/Nmap)+1;
%  b(i)=sin(2*pi*i/Nmap)+1;
%  map(i,:) = [r(i)/2 g(i)/2 b(i)/2];
%  r(i)=sin(pi/2*(Nmap-i-1)/Nmap);
%  g(i)=sin(pi/2*(i-1)/Nmap);
%  b(i)=sin(pi/2*(i-1)/Nmap);
%  map(i,:) = [r(i) g(i) b(i)];
%end;

Nmap=100;
r = 0:1/(Nmap-1):1; % r = fliplr(r);
g = 0:1/(Nmap-1):1; % g = fliplr(g);
b = 0:1/(Nmap-1):1; % b = fliplr(b);
map = [r.' g.' b.'];

colormap(map);
% ================================================
Nf=0;
Nt=0;
for j=1:Ncoils
  Nf= max([Nf size(X(j).F,1)]);
  Nt= max([Nt size(X(j).F,2)]);
end;

figure;
clear x;
for j=1:Ncoils

  if X(j).data==1
    tx  = X(j).t;
    fx   = X(j).f;
    t_index = max(find(tx<t));
    xa(:,j)   = abs(X(j).F(:,t_index));
    xp(:,j)   = angle(X(j).F(:,t_index));
  else
    xa(1:Nf,j)   = 0.0;
    xp(1:Nf,j)   = 0.0;
  end;
  phase(j) = j;
end;


% phase reference
for j=1:Ncoils
  if X(j).data==1
    xp(:,j)   = xp(:,j) - xp(:,3);
  end;
end;
xa=xa.';
freq  = fx;
xp=xp.';

% shift xp to lie in -pi<=xp<=pi
[Nph, Nf] = size(xp)
for i=1:Nph
  for j=1:Nf
    while(xp(i,j)>pi)  xp(i,j)=xp(i,j)-2*pi; end;
    while(xp(i,j)<-pi) xp(i,j)=xp(i,j)+2*pi; end;
  end;
end;

imagesc(freq,phase,20*log10(xa));
colormap(jet);

figure;
imagesc(freq,phase,xp);
colormap(map);

save pphase.mat;


figure;
title(['MAST shot ',num2str(shot)]);
hold on;
for j=1:Ncoils

  i = Ncoils+1-j;
  if x(i).data
    ys1   = voffset + vscale*x(i).phi/(2*pi) - ys2/2;
    subplot('Position',[xs1 ys1 xs2 ys2]);
    t_frame = find((x(i).signal(:,1)>=t1)&(x(i).signal(:,1)<=t2));
    ynorm = max(abs(x(i).signal(t_frame,2))); 
    plot(x(i).signal(:,1),x(i).signal(:,2)/ynorm);
    axis([t1 t2 -1 1]);
  end;

end;

xlabel(['t (sec)']);
return;
