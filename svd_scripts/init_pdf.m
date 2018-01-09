

function [pdf]=init_pdf(Z)
% MJH 11/10/05
% Inputs : none
% Output : initializes pdf binning for mode number, residue and common n

% Fbins = frequency bins
% Nbins = mode number bins
% Rbins = residue bins

% set frequency bins
% Fbins has Fbin+1 frequency markers. 
Fbins= 4;
flow = 5000;
fhigh= 30000;
df   = (fhigh - flow)/Fbins;
fbin    = flow:df:fhigh;

Nc    = Z.Nc;
Ns    = 2*Nc;
Nbins = Ns+1;

% initialize ordinate array, and Pn
dr    = 0.01;
nbin  = -Nc:Nc;
rbin  = 0:dr:1;
Rbins = length(rbin);
Pn(1:Fbins, 1:Nbins)           = 0.0;
Fn(1:Fbins, 1:Nbins)           = 0.0;
Pnr(1:Fbins, 1:Nbins, 1:Rbins) = 0.0;
Fnr(1:Fbins, 1:Nbins, 1:Rbins) = 0.0;

pdf.fbin = fbin;
pdf.nbin = nbin;
pdf.rbin = rbin;
pdf.Pn = Pn;
pdf.Fn = Fn;
pdf.Pnr= Pnr;
pdf.Fnr= Fnr;


return;


