function time(shot,varargin)
%
% plots time trace of specified shot
%
% Matthew Hole, Jan 2002

global data

% read in variables as global
for i=1:size(data,1)
  str1=['global ',data(i,:)];
  eval(str1);
end;

% find input shot
posn(size(data,1))=0;
for i=1:size(data,1)
   if findstr(data(i,:),int2str(shot))
     posn(i)=1;
   end;
end;

% defalut items.. all toroidal coils
if size(varargin)~=0
  tstart=varargin{1};
  tstop =varargin{2};
end;

% create figure
figure;
hold;

i=1;
while posn(i)~=1
  i=i+1;
end;
start=i;

% overplot all items in shot
while i<=size(posn,2)
 if posn(i)==1
   
    % overwrite time series
    if size(varargin)~=0
      str=['istart=min(find(',data(i,:),'(:,1)>=tstart));']; eval(str);
      str=['istop =min(find(',data(i,:),'(:,1)>=tstop));']; eval(str);
      str=['temp=',data(i,:),'(istart:istop,:);']; eval(str);
      str=['clear ',data(i,:)]; eval(str);
      str=['global ',data(i,:)]; eval(str);
      str=[data(i,:),'=temp;']; eval(str);
    end;
    
    stra=['plot(',data(i,:),'(:,1),',data(i,:),'(:,2),'];
    r=num2str(rand); g=num2str(rand); b=num2str(rand);
    strb=['''Color'',[',r,' ',g,' ',b,']);'];
    str=[stra,strb];
    eval(str);
    i=i+1;
 else
    break;
 end;
end;

stop=i-1;

% create legend
str=[];
for i=start:stop
 name=strrep(data(i,:),'_','/');
 str=strvcat(name,str);
end;

legend(str);
title(['Time trace of shot ', int2str(shot)]);
xlabel('time (secs)');
ylabel('volts');
hold;

return;

