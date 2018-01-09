

function [pdf]=norm_pdf(pdf)

% Inputs : pdf
% Output : normalized pdf 

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


% compute cumulative pdfs
for k = 1:Fbins
    for i = 1:Nbins
      Fn(k,i) = sum(Pn(k,1:i));  
      for j=2:Rbins
         Fnr(k,i,j) = sum(Pnr(k,i,1:j));
      end;
    end
end

NPn= sum(sum(Pn));
Pn = Pn/NPn;
Fn = Fn/NPn;
NPnr = sum(sum(sum(Pnr)));
Pnr= Pnr/NPnr;
Fnr= Fnr/NPnr;

% update pdf structure
pdf.Pn = Pn;
pdf.Fn = Fn;
pdf.Pnr= Pnr;
pdf.Fnr= Fnr;


return;


