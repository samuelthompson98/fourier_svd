function pltn5(list,tslice,shot,fhigh)

% plots eigen-mode amplitudes and residue as a fn. of freq
% Matthew Hole Jan. 2002 

% plot n mode number versus frequency
h=figure;
h1=subplot(2,1,1);
ylabel('mode amplitude');
title(['n mode spectrum at t=', num2str(tslice),', for shot ', num2str(shot)]);
hold;
h2=subplot(2,1,2);
ylabel('residue');
hold;

% define residue tupe
residue.MarkerFaceColor='k';
residue.MarkerSize=6;
residue.Marker='o';

% locate representative markers to use on the legend
modes=[0;1;2;3;-1;-2;-3];
strtext=strvcat('n=0','n=1','n=2',...
         'n=3','n=-1','n=-2','n=-3');
str  ={[];[];[];[];[];[];[]};
index={[];[];[];[];[];[];[]};
jndex={[];[];[];[];[];[];[]};
leg=[];

% first the biggest mode
for j=1:7
  index{j}=find(list(:,2) == modes(j)) ;
  if size(index{j},1) > 1 index{j}=index{j}(1); end;
end
for k=1:7  if ~isempty(index{k}) str{k}=strtext(k,:);end;end;

% now the other mode
for j=1:7
  if isempty(index{j}) jndex{j}=find(list(:,3) == modes(j)) ; end;
  if size(jndex{j},1) > 1 jndex{j}=jndex{j}(1); end;
end
for k=1:7  if ~isempty(jndex{k}) str{k}=strtext(k,:);end;end;

% construct legend text: include only modes that will be plotted
for k=1:7  if ~isempty(str{k}) leg=strvcat(leg,str{k});end;end;


handles={[];[];[];[];[];[];[]};
for i=1:size(list,1)
   subplot(2,1,1);
   nlabel=mtype(list(i,:),2);
   h=plot(list(i,1),abs(list(i,4)),nlabel); % plot first mode soln.
   for j=1:7; if ~isempty(index{j}) & i==index{j} handles{j}=h; end;end;
   nlabel=mtype(list(i,:),3);
   h=plot(list(i,1),abs(list(i,5)),nlabel); % plot second mode soln.
   for j=1:7; if ~isempty(jndex{j}) & i==jndex{j} handles{j}=h; end;end;
  
   subplot(2,1,2);
   semilogy(list(i,1),abs(list(i,6)),residue); % plot common residure
end;


% finally create legend
  handleg=[];
  for i=1:7; if ~isempty(handles{i}) handleg=[handleg;handles{i}];end;end;
  subplot(2,1,1);
  legend(handleg,leg);
 
return;

% ==================================================
% Add statiscal significance levels
% s1(residue, statiscal significance) for one mode
% s2(residue, statiscal significance) for two modes
load s1.mat
load s2.mat
fmin=min(list(:,1));
fmax=max(list(:,1));
% fix axes on both plots 
subplot(2,1,1);
axis([fmin fmax 0 1]);
axis 'auto y';
subplot(2,1,2);
axis([fmin fmax 0 1]);
axis 'auto y';
smin=3;
smax=4; 

leg=[]; k=1;
clear handles;
for i=smin:smax
  slabel=stype(s1(i,2),1);
  h=plot([fmin fmax],[s1(i,1) s1(i,1)],slabel);
  handles{k}=h; k=k+1;
  leg=strvcat(leg,['s(M=1) = ',num2str(s1(i,2))]); 
%  text(fmin+0.8*(fmax-fmin),s1(i,1),['s=',num2str(s1(i,2))]);  
end;

for i=smin:smax
  slabel=stype(s1(i,2),2);
  h=plot([fmin fmax], [s2(i,1) s2(i,1)],slabel);
  handles{k}=h; k=k+1;
  leg=strvcat(leg,['s(M=2) = ',num2str(s2(i,2))]); 
%  text(fmin+0.5*(fmax-fmin),s2(i,1),['s=',num2str(s2(i,2))]);
end;

% create legend
handleg=[]; Ni=size(handles,2);
for i=1:Ni; if ~isempty(handles{i}) handleg=[handleg;handles{i}];end;end;
legend(handleg,leg);

return;
