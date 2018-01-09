
function tor_time(shot,x,t1,t2)

% MJH 17/06/03
% plot time series data versus centre column height

[junk,Ncoils] = size(x)

xs1 = 0.1; % left
xs2 = 0.8; % width
vscale = 0.8;
voffset= 0.1;
ys2 = vscale/Ncoils; % height

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
