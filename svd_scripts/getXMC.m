function [xmc]=getXMC(shot)

% get XMC data
% MJH 05/07/02

label='xmc';

% Centre Column vertical array 
for i=1:40
  clear temp;
  temp(:,:) = ida_read(shot,label,['cc/mv/2',num2str(i,'%02d')]);
  if isempty(temp)
    xmc.cc_mv_2(i).data  =0;
  else
    xmc.cc_mv_2(i).data  =1;
    xmc.cc_mv_2(i).signal=temp;
  end;
end;

% Outboard vertical array 
for i=1:19
  clear temp;
  temp(:,:) = ida_read(shot,label,['obv/mv/2',num2str(i,'%02d')]);
  if isempty(temp)
    xmc.ob_mv_2(i).data  =0;
  else
    xmc.ob_mv_2(i).data  =1;
    xmc.ob_mv_2(i).signal=temp;
  end;
end;

% Outboard radial array 
for i=1:19
  clear temp;
  temp(:,:) = ida_read(shot,label,['obr/mv/2',num2str(i,'%02d')]);
  if isempty(temp)
   xmc.ob_mr_2(i).data  =0;
  else
    xmc.ob_mr_2(i).data  =1;
    xmc.ob_mr_2(i).signal=temp;
  end;
end;

% ============================================================
% Toroidal array of Mirnov coils mounted on centre column at midplane

for i=1:12
  clear temp;
  temp(:,:) = ida_read(shot,label,['cc/mt/2',num2str(i,'%02d')]);
  if isempty(temp)
    xmc.cc_mt_2(i).data  =0;
  else
    xmc.cc_mt_2(i).data  =1;
    xmc.cc_mt_2(i).signal=temp;
  end;
end;

return;
