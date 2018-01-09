% ======================================================================
function [pdf]=init_xmd_pdf(xmd,imin, imax, varargin)

% MJH 11/10/05
% Inputs : none
% Output : initializes pdf binning for mode number, residue and common n


% determine discretization level

xdiff = sort(abs(diff(xmd.omt(1).signal(:,2))));
idiff = find(xdiff~=0);
dx    = xdiff(idiff(1));

% NP = number of data point bins

xmin = 1;
xmax = 0;

if isempty(varargin)    
  for i = 1:3
      if xmd.omt(i).data  
         xmin = min([min(xmd.omt(i).signal(imin:imax,2)) xmin]);
         xmax = max([max(xmd.omt(i).signal(imin:imax,2)) xmax]);
      end; 
  end;
else
    i = varargin{1};  
    if xmd.omt(i).data  
        xmin = min([min(xmd.omt(i).signal(imin:imax,2)) xmin]);
        xmax = max([max(xmd.omt(i).signal(imin:imax,2)) xmax]);
    end; 
end;
   
% double range 
xmax1 = (xmax+xmin)/2 + (xmax-xmin);
xmin1 = (xmax+xmin)/2 - (xmax-xmin);

NP   = fix((xmax1-xmin1)/dx) + 1
pdf.Px(1:NP, 1:2) = 0;
pdf.Px(:,1)       = (xmin1: (xmax1 - xmin1)/(NP-1): xmax1).';


return;

