
function [y]=ida_read(shot,label,item,varargin)

% Import IDA3 data and print to screen data header
% MJH 05/02
% Eg. To get the time trace from the efit reconstruction
% of shot 4505, type
% x=ida_read(4505,'efm','time');

ida_globals

% ==========================================================
% varargin= tindex and/or string comprising search path file
% for efm file. 

Nvar=size(varargin,2);

dir_assgned=0;
t_assgned=0;
for i=1:Nvar
  if ischar(varargin{i})
    dir=varargin{i};
    dir_assgned=1;
  else
    tindex=varargin{i};
    t_assgned=1;
  end;
end;

% turn off t_assgned if tindex=1
if t_assgned
  if tindex==1
    t_assgned=0;
  end;
end;

% default directory
if dir_assgned==0
  dir=['/net/fuslsa/data/MAST_Data/',num2str(shot),'/LATEST/'];
end;

% ==========================================================
file=[dir,label,'00',num2str(shot/100)]
f=ida_open(file,IDA_READ)

i=ida_find(f,[label,'_',item],0,0);
e=ida_print_head(i)
[e,x]=ida_get_data(i,IDA_D4+IDA_REAL,0);
e=ida_free(i);
e=ida_close(f);

% convert everything to double precision
x=double(x);

% if time index assigned, then return x at single time point
if  t_assgned
  Nx1=size(x,1);
  if Nx1==1
    y=x(tindex);
  else
    Nx2=size(size(x),2);
    switch Nx2
      case 2,  y=x(tindex,:);,
      case 3,  y(:,:)=x(:,:,tindex);
    end;
 end;
else
  y=x;
end;

return;
