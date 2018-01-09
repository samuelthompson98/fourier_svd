function phase(shot,tslice,varargin)
%
% cacluates specotrgam of specified shot and items
%
% Matthew Hole, Jan 2002

global fftdata tfft ffft

% read in variables as global
for i=1:size(fftdata,1)
  str2=['global ',fftdata(i,:)];
  str3=['global ',ffft(i,:)];
  str4=['global ',tfft(i,:)];
  eval(str2);
  eval(str3);
  eval(str4);
end;

% find input shot
posn(size(fftdata,1))=0;
for i=1:size(fftdata,1)
   if findstr(fftdata(i,:),int2str(shot))
     posn(i)=1;
   end;
end;

% input item from variable input
if size(varargin)>0
  flow=varargin{1};
  fhigh=varargin{2}; fmax=4.9e+5;
  if fhigh>fmax fhigh=fmax; end;
else
  flow=1e+6;
  fhigh=0;
end;

% over plot all phases associated with that pulse
figure;
subplot(2,1,1); hold;
subplot(2,1,2); hold;
leg=[]; Fmax=0; Fmin=1e+6;
for i=1:size(fftdata,1)
  if posn(i)==1

  % find correct time slice
  str=['tm=min(find(',tfft(i,:),'>=tslice));']; eval(str);
  str=['tmslice=',tfft(i,:),'(tm);']; eval(str);

  % find frequency range for fftdata(i,:) 
  if size(varargin)==0
    str=['fl=min(',ffft(i,:),');'];        eval(str);
    str=['if fl<flow flow=fl; end;'];      eval(str);
    str=['fh=max(',ffft(i,:),');'];        eval(str);
    str=['if fh>fhigh fhigh=fh; end;'];    eval(str);
  end;

  % find frequency range in fftdata(i,:)
  str=['ifl=min(find(',ffft(i,:),'>=flow));'];  eval(str);
  str=['ifh=min(find(',ffft(i,:),'>=fhigh));']; eval(str);

  % peak amplitudes of fftdata(i,:)
  str=['if max(abs(',fftdata(i,:),'(ifl:ifh,tm)))>Fmax Fmax=max(abs(',fftdata(i,:),'(ifl:ifh,tm))); end;']; 
  eval(str);
  str=['if min(abs(',fftdata(i,:),'(ifl:ifh,tm)))<Fmin Fmin=min(abs(',fftdata(i,:),'(ifl:ifh,tm))); end;']; 
  eval(str);

  % plot with different colour for each trace
  subplot(2,1,1);
  stra=['plot(',ffft(i,:),',abs(', fftdata(i,:),'(:,tm)),']; 
  r=num2str(rand); g=num2str(rand); b=num2str(rand);
  strb=['''Color'',[',r,' ',g,' ',b,']);'];
  str=[stra,strb];  eval(str);
  subplot(2,1,2);
  stra=['plot(',ffft(i,:),',180/pi*angle(', fftdata(i,:),'(:,tm)),']; 
  str=[stra,strb];  eval(str);

  % create legend
  name=strrep(fftdata(i,:),'_','/');
  leg=strvcat(name,leg);

  end; % if
end;  % for

subplot(2,1,1);
axis([flow fhigh Fmin Fmax]);
legend(leg);
title(['Phase of all FFT at t = ',num2str(tmslice),' for shot ', int2str(shot)]);
ylabel('magnitude');
subplot(2,1,2);
axis([flow fhigh -180 180]);
xlabel('frequency (Hz)');
ylabel('phase (degrees)');

return;
