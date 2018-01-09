clear all;
%
% reads in all shots and items
%
% Matthew Hole, Jan 2002


global data fftdata tfft ffft nlist
global fftdata2 tfft2 ffft2

file='bin_write.dat'
[nshots]=textread(file,'%d',1)
[shots]= textread(file,'%s',nshots,'delimiter',',','headerlines', 1)
[nitems]=textread(file,'%d',1,'headerlines', 2)
[items]=textread(file,'%s',nitems,'headerlines', 3)

shots =char(shots);
suffix=char(strrep(items,'/','_'));

k=1;
for i=1:nshots
  nlist(i,:) =['n',shots(i,:)];
  str5=['global ',char(nlist(i,:))]; 
  eval(str5)
  for j=1:nitems
    files(k,:)=[shots(i,:),suffix(j,:)];
    ref(i,j)=k;

    data(k,:) =['x',files(k,:)];
    str1=['global ',char(data(k,:))];     eval(str1);
    fftdata(k,:) =['FT',data(k,:)];
    str2=['global ',char(fftdata(k,:))];  eval(str2);
    ffft(k,:) =['fFT',data(k,:)];
    str3=['global ',char(ffft(k,:))];     eval(str3);
    tfft(k,:) =['tFT',data(k,:)];
    str4=['global ',char(tfft(k,:))];     eval(str4);

    fftdata2(k,:) =['FT2',data(k,:)];
    str2=['global ',char(fftdata2(k,:))];  eval(str2);
    ffft2(k,:) =['fFT2',data(k,:)];
    str3=['global ',char(ffft2(k,:))];     eval(str3);
    tfft2(k,:) =['tFT2',data(k,:)];
    str4=['global ',char(tfft2(k,:))];     eval(str4);


    ftemp=strrep(files(k,:),' ','');
    str1=[data(k,:),'=getmast(ftemp);'];
    eval(str1);
    k=k+1;
  end;
end;

data=char(data);
fftdata=char(fftdata);
ffft=char(ffft);
tfft=char(tfft);
fftdata2=char(fftdata2);
ffft2=char(ffft2);
tfft2=char(tfft2);
nlist=char(nlist);

