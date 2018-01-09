
% figure 1a
% Perform SVD decomposition, and return n mode analysis

% MJH 20/06/07
% Copy chirp_9429c4.m and set for remote operation

clear all

load ../SVD4/9429_xmd.mat
% shot= 9429
% xmd = getXMD(shot)

% select time chunk 

f0   = 18.5e+3;
tmin = 0.160
tmax = tmin + 10/f0;

% tmin = 0.250
% tmax = 0.270

clear ymd

Ncoils = size(xmd.omt,2)

for i=1:Ncoils
  if xmd.omt(i).data
     imin = min(find(xmd.omt(i).signal(:,1)>=tmin));
     imax = min(find(xmd.omt(i).signal(:,1)>=tmax));
     ymd.omt(i).data = 1;
     ymd.omt(i).phi  = xmd.omt(i).phi;
     ymd.omt(i).signal(1:imax-imin+1,:) = xmd.omt(i).signal(imin:imax, :);
     ymd.omt(i).signal(1:imax-imin+1,:) = xmd.omt(i).signal(imin:imax, :);     

     % average over clock - it has a huge dither MJH 08/11/06
     dt_trace = diff(ymd.omt(i).signal(:,1));
     dt   = mean(dt_trace);     

     tmin = min(ymd.omt(i).signal(:,1));
     tmax = max(ymd.omt(i).signal(:,1));     
  end;
  
  if xmd.omr(i).data
     imin = min(find(xmd.omr(i).signal(:,1)>=tmin));
     imax = min(find(xmd.omr(i).signal(:,1)>=tmax));
     ymd.omr(i).data = 1;
     ymd.omr(i).phi  = xmd.omr(i).phi;
     ymd.omr(i).signal(1:imax-imin+1,:) = xmd.omr(i).signal(imin:imax, :);
     ymd.omr(i).signal(1:imax-imin+1,:) = xmd.omr(i).signal(imin:imax, :);     
  end;

  if xmd.omv(i).data
     imin = min(find(xmd.omv(i).signal(:,1)>=tmin));
     imax = min(find(xmd.omv(i).signal(:,1)>=tmax));
     ymd.omv(i).data = 1;
     ymd.omv(i).phi  = xmd.omv(i).phi;
     ymd.omv(i).signal(1:imax-imin+1,:) = xmd.omv(i).signal(imin:imax, :);
     ymd.omv(i).signal(1:imax-imin+1,:) = xmd.omv(i).signal(imin:imax, :);     
  end;
end;

figure; hold on;
subplot('position',[0.1 0.1 0.8 0.8]); hold on;

ymin = 1;
ymax = -1;
for i=1:3
    if (ymd.omt(i).phi)>pi
        ymd.omt(i).phi =  ymd.omt(i).phi - 2*pi;
    elseif (ymd.omt(i).phi)<-pi
        ymd.omt(i).phi =  ymd.omt(i).phi + 2*pi;
    end    
    phi(i) = ymd.omt(i).phi;
    ymin   = min([min(ymd.omt(i).signal(:,2)) ymin])
    ymax   = max([max(ymd.omt(i).signal(:,2)) ymax])
end
dphi = (max(phi)-min(phi));
xmin = tmin;
xmax = 0.1605;
tnorm= 1e-3;

%for i=1:3
%        
%    x(i) = (ymd.omt(i).phi - min(phi))/dphi * 0.8 + 0.1;
%    y(i) = 0.05;
%    subplot('position',[0.1 x(i) 0.8 y(i)]); hold on;
%    plot(ymd.omt(i).signal(:,1)/tnorm, ymd.omt(i).signal(:,2))
%    axis([xmin/tnorm xmax/tnorm ymin ymax]);
%    if phi(i)==min(phi)
%        set(gca, 'YTickLabel','');
%    else
%        set(gca, 'YTickLabel','','XTickLabel','');
%    end    
%end

yabs = max([abs(ymin) abs(ymax)]);
figure; 
fs = 14;
lw = 1.5;
set(gca,'FontSize',fs, 'LineWidth',lw,'Box','on','TickLength',[0.02 0.02],'TickDir','in'); hold on;
hold on;
for i=1:3
    plot(ymd.omt(i).signal(:,1)/tnorm, (phi(i) + 0.1*ymd.omt(i).signal(:,2)/yabs)/pi*180)
    plot([xmin/tnorm xmax/tnorm], [phi(i)/pi*180 phi(i)/pi*180],'k-');

    [junk, ik] = max(ymd.omt(i).signal(:,2));
    ph_time(i) = ymd.omt(i).signal(ik,1);
    % plot(ph_time(i)/tnorm, (phi(i) + 0.1* junk/yabs)/pi*180,'ko');
    % plot([ph_time(i)/tnorm, ph_time(i)/tnorm], [phi(i)-0.1, phi(i)+0.1]/pi*180 ,'k-');
    
    % find periodicity adjacent to peak
    it_min = min(find(ymd.omt(i).signal(:,1)>0.16005));
    it_max = min(find(ymd.omt(i).signal(:,1)>0.16010));

    [junk, ik] = max(ymd.omt(i).signal(it_min:it_max,2));
    tau(i) = ph_time(i) - ymd.omt(i).signal(it_min + ik, 1);

end

time = ymd.omt(1).signal(:,1)/tnorm;
[p, s] = polyfit(ph_time/tnorm, phi, 1);
hn = plot(time, (p(1)*time + p(2))/pi*180,'r-');
axis([xmin/tnorm xmax/tnorm -60 10]);

hnstr = ['n = ',num2str(p(1)*mean(tau)/tnorm /(2*pi))];
legend(hn, hnstr);
xlabel(['time (ms)']);
ylabel(['\phi (degrees)']);

return
    
