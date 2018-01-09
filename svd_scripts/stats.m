

function [X] = stats(pdf)

% generate statitsics of given probability distribution
% pdf must be binned linearly
% MJH 01/03

Nrows = size(pdf,1);
Ncols = size(pdf,2);

dx = pdf(2,1)-pdf(1,1);

% set all NaN to zero in pdf
for i=1:Nrows
    for j=1:Ncols
        if isnan(pdf(i,j)) pdf(i,j) = 0.0; end;
    end;
end;

for j=1:Ncols
  X.int(j) = sum(pdf(:,j))*dx;
  X.mu(j)  = mu_pdf(X,pdf,j);
  X.sd(j)  = sd_pdf(X,pdf,j);
  X.pk(j)  = pk_pdf(pdf,j);
end;

return;

% ===================================================================
function [mu] = mu_pdf(X, pdf, j)

% compute first moment
% pdf assumed to be uniformily spaced in x

Nrows = size(pdf,1);
dx = pdf(2,1)-pdf(1,1);

% normalize - only normalize probability - not abscissa
pdf(:,j)  = pdf(:,j)/X.int(j);
mu   = 0; 
for i=1:Nrows
   mu = pdf(i,1) * pdf(i,j) * dx + mu; 
end;

return;

% ===================================================================
function [sd] = sd_pdf(X, pdf, j)

% compute second moment
% pdf assumed to be uniformily spaced in x

Nrows = size(pdf,1);
dx = pdf(2,1)-pdf(1,1);

% normalize
pdf(:,j)  = pdf(:,j)/X.int(j);
mu   = X.mu(j);
sd = 0; 
for i=1:Nrows
   sd = (pdf(i,1) - mu)^2 * pdf(i,j) * dx + sd; 
end;
sd = sqrt(sd); 

return;

% ===================================================================
function [Vpk] = pk_pdf(pdf, j)

% locate peaks of distribution function

[pmax, index] = max(pdf(:,j));
Vpk = pdf(index,1); 


return;

