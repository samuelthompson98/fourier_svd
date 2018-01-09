% ======================================================================
function [pdf]=init_signal_pdf(xmb,imin, imax)

% MJH 11/10/05
% Inputs : none
% Output : initializes pdf binning for mode number, residue and common n

% NP = number of data point bins
NP   = 200; 
xmin = 1;
xmax = 0;
for i = 1:12
    if xmb.cc_mt_2(i).data  
        xmin = min([min(xmb.cc_mt_2(i).signal(imin:imax,2)) xmin]);
        xmax = max([max(xmb.cc_mt_2(i).signal(imin:imax,2)) xmax]);
    end; 
end;

xmin = -max([abs(xmin) abs(xmax)]);
xmax = +max([abs(xmin) abs(xmax)]);

pdf.Px(1:NP, 1:2) = 0.0;
pdf.Px(:,1)       = (xmin: (xmax - xmin)/(NP-1): xmax).';


return;

