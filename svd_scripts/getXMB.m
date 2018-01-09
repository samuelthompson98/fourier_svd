function [xmb]=getXMB(shot)

% get XMC data
% MJH 05/07/02

label='xmb';

xmb.shot = shot;

% ============================================================
% Centre column mounted vertical array of Mirnov coils 
% N. 01 is at top and 20 is at midplane. 

for i=1:40
  clear temp;
  temp(:,:) = ida_read(shot,label,['cc/mv/2',num2str(i,'%02d')]);
  if size(temp,1)==1
    xmb.cc_mv_2(i).data  =0;
  else
    xmb.cc_mv_2(i).data  =1;
    xmb.cc_mv_2(i).signal=temp;
  end;
end;

% ============================================================
% Outer vertical array of Mirnov coils
% N. 01 is at top and 10 is at midplane. (Sector 9)

for i=1:19
  clear temp;
  temp(:,:) = ida_read(shot,label,['omv/2',num2str(i,'%02d')]);
  if size(temp,1)==1
    xmb.ob_mv_2(i).data  =0;
  else
    xmb.ob_mv_2(i).data  =1;
    xmb.ob_mv_2(i).signal=temp;
  end;
end;

% ============================================================
% Toroidal array of Mirnov coils mounted on centre column at midplane

for i=1:12
  clear temp;
  temp(:,:) = ida_read(shot,label,['cc/mt/2',num2str(i,'%02d')]);
  if size(temp,1)==1
    xmb.cc_mt_2(i).data  =0;
  else
    xmb.cc_mt_2(i).data  =1;
    xmb.cc_mt_2(i).signal=temp;
  end;
end;
dphi = 2*pi/12;
for i=1:12
  xmb.cc_mt_2(i).phi= dphi*i;
end;

return;
