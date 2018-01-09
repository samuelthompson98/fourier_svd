function spec(shot,varargin)
%
% cacluates specotrgam of specified shot and items
%
% Matthew Hole, Jan 2002

global data fftdata tfft ffft

% read in variables as global
for i=1:size(data,1)
  str1=['global ',data(i,:)];
  str2=['global ',fftdata(i,:)];
  str3=['global ',ffft(i,:)];
  str4=['global ',tfft(i,:)];
  eval(str1);
  eval(str2);
  eval(str3);
  eval(str4);
end;

% find input shot
posn(size(data,1))=0;
for i=1:size(data,1)
   if findstr(data(i,:),int2str(shot))
     posn(i)=1;
   end;
end;

% input item from variable input
for i=1:size(varargin,2)
  item(i,:)=[varargin{i}];
end;

posn=posn';

% find items in data list if varargin supplied
if size(varargin)>0
 for i=1:size(data,1)
    if posn(i)==1
      item_present=0;
      for j=1:size(item,1)
        if findstr(data(i,:),item(j,:))
          item_present=1;
	end;
      end;
      posn(i)=item_present;
    end;
 end;
end;

% call spectrogram code

for i=1:size(data,1)
  if posn(i)==1
    disp(['Now calculating... ', fftdata(i,:)])
    stra=['[',fftdata(i,:),',', ffft(i,:),',', tfft(i,:),']'];
    strb=['=getspec(',data(i,:),',1,''',fftdata(i,:),''');'];
    str=[stra,strb];
    eval(str);
  end;
end;

return;

