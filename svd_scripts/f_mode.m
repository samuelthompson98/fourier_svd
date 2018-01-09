

function [pdf]=f_mode(Z)

% Inputs : FFT Z
% Output : plots of pdfs of mode number for different frequency bands

% Calculates the pdf and cdf of the modes of the data for given coil
% locations for different frequencies once structure of plasma has appeared
% to have ended.

% performed for one time point at Z.t
% Fbins frequency bins
% Nbins mode number bins

% set frequency bins
% Fbins has Fbin+1 frequency markers. 
Fbins= 4;
flow = 5000;
fhigh= 30000;
df   = (fhigh - flow)/Fbins;
fbin    = flow:df:fhigh;

% determine index markers corresponding to bins in Z.f
for i=1:Fbins+1
  if isempty(find(Z.f < fbin(i)))
     fZ_index(i) = 0;
  else
     fZ_index(i) = max(find(Z.f < fbin(i)));
  end;
end;

Ns    = 12;
Nc    = Ns/2;
Nbins = Ns+1;

% initialize ordinate array, and Pn
dr    = 0.1;
nbin  = -Nc:Nc;
rbin  = 0:dr:1;
Rbins = length(rbin);
Pn(1:Fbins, 1:Nbins)           = 0.0;
Pnr(1:Fbins, 1:Nbins, 1:Rbins) = 0.0;

% bin data
for k = 1:Fbins
    for i = 1:Nbins
      % disp(['i, k = ',num2str(i),',',num2str(k)]);

      % add to Pn(k,i) instances of nbin(i)
      n_common= find((Z.n(fZ_index(k)+1:fZ_index(k+1),1) == nbin(i))|(Z.n(fZ_index(k)+1:fZ_index(k+1),2) == nbin(i)))
      Pn(k,i) = Pn(k,i) + size(n_common,1);
      Fn(k,i) = sum(Pn(k,1:i));

      % add to Pnr(k,i,j) value of residue 
      for j=2:Rbins
         res_index  = find((Z.dF(n_common) <= rbin(j))&(Z.dF(n_common) > rbin(j-1)));
         Pnr(k,i,j) = Pnr(k,i,j) + size(res_index,1);
         Fnr(k,i,j) = sum(Pnr(k,i,1:j));
      end;

    end
    Pn(k,:) = Pn(k,:)/Fn(k,Nbins);
    Fn(k,:) = Fn(k,:)/Fn(k,Nbins);
end


pdf.fbin = fbin;
pdf.nbin = nbin;
pdf.rbin = rbin;
pdf.Pn = Pn;
pdf.Fn = Fn;
pdf.Pnr= Pnr;
pdf.Fnr= Fnr;


return;


