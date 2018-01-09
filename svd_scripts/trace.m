function trace(item)
%
% plots time trace of all item(s)
%
% Matthew Hole, Jan 2002
% Lynton Appel, 04/12/02

h=figure;
hold on;
size(item);

str_leg=[];

k=0;
for i=1:size(item,2); if item(i).data==1 ; k=k+1;end;end;

if k <= 7 
  m=0;
  cindex=['rbmkcgy'];
  for i=1:size(item,2)
    if item(i).data==1
      m=m+1;
      plot(item(i).signal(:,1),item(i).signal(:,2),cindex(m));
      str_leg=strvcat(['Ch. ',num2str(i)],str_leg);
    end;
   end; 
else
   for i=1:size(item,2)
     if item(i).data==1
      r=rand; g=rand; b=rand;
      plot(item(i).signal(:,1),item(i).signal(:,2),'Color',[r,g,b]);
      str_leg=strvcat(['Ch. ',num2str(i)],str_leg);
    end;
   end; 
end;

% legend(str_leg);
return;


