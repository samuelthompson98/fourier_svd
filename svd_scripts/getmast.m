
function [data]=getmast(X)

% X=data file, fs= sample freq.
fid = fopen(X,'r');
[toff,count]=fread(fid,1,'float32');
[dt,count]  =fread(fid,1,'float32');
[nitems,count]  =fread(fid,1,'int32');
[data(:,2),count]   =fread(fid,nitems,'float32');

time=toff:dt:((size(data,1)-1)*dt+toff)';
data(:,1)=time(:);

% data plot
%X=strrep(X,'_','/');
%figure;
%plot(data(:,1), data(:,2));
%xlabel('time [s]');
%ylabel('volts [V]');
%title(X);

