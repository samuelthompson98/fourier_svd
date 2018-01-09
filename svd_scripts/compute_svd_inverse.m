function [ginv]=compute_svd_inverse(n,theta)

   % compute inverse to gamma matrix given n vector and theta
   
   % SVD tolerence --- can be changed
   svdtol=1.0e-4;
   g=gamma(n,theta);
   [U,S,V]=svd(g,0);
   W=diag(S);
   for h=1:length(W)
     Wmax=max(W);
     if W(h)<svdtol*Wmax
       Winv(h)=0;
     else
       Winv(h)=1/W(h);
     end;
   end;
   
   % solution and error
   ginv = V*diag(Winv)*U';
      
return;


function [g]=gamma(n,theta)
%
% function computes matrix of coefficients
% to feed into SVD 
% MJH 14/06/07 - switch sign of g

for i=1:length(theta)
 for j=1:length(n)
   g(i,j)=exp(+1i*n(j)*theta(i));
 end;
end;

return;