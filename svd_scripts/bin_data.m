

function [pdf] = bin_data(Z,pdf,nsimul)

% Inputs : FFT Z, pdf
% Output : plots of pdfs of mode number for different frequency bands
% Function: adds data in Z to pdf, using structure in pdf
 
% performed for one time point at Z.t
% Fbins frequency bins
% Nbins mode number bins

% set frequency bins

fbin = pdf.fbin;
nbin = pdf.nbin;
rbin = pdf.rbin;
Pn   = pdf.Pn;
Fn   = pdf.Fn;
Pnr  = pdf.Pnr;
Fnr  = pdf.Fnr;

Nbins= length(nbin);
Fbins= length(fbin)-1;
Rbins= length(rbin);

% determine index markers corresponding to bins in Z.f
for i=1:Fbins+1
  if isempty(find(Z.f < fbin(i)))
     fZ_index(i) = 0;
  else
     fZ_index(i) = max(find(Z.f < fbin(i)));
  end;
end;

% bin data
for k = 1:Fbins
    for i = 1:Nbins

      % add to Pn(k,i) instances of nbin(i)
      if nsimul==2
        n_common= find((Z.n(fZ_index(k)+1:fZ_index(k+1),1) == nbin(i))|(Z.n(fZ_index(k)+1:fZ_index(k+1),2) == nbin(i)));
      else % assume nsimul ==1
        n_common= find((Z.n(fZ_index(k)+1:fZ_index(k+1),1) == nbin(i)));
      end;
      Pn(k,i) = Pn(k,i) + size(n_common,1);

      % add to Pnr(k,i,j) value of residue 
      for j=2:Rbins
         res_index  = find((Z.dF(n_common) <= rbin(j))&(Z.dF(n_common) > rbin(j-1)));
         Pnr(k,i,j) = Pnr(k,i,j) + size(res_index,1);
      end;

    end
end

% update pdf structure
pdf.Pn = Pn;
pdf.Pnr= Pnr;


return;


