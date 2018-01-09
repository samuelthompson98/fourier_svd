function [a,n,dF]=msvd(Fv,theta,Nc,nsimul)

% Uses SVD to calcuate the most likely "nsimul" independant 
% eigen-modes for a given Fourier weight matrix Fv and theta array "theta".
% Eigenmodes between +/-Nc are searched for.
% Returns eigen-mode weights "a", eigen-modes "n" and resides "dF"
%
% Matthew Hole Jan 2002
% MJH 15/08/02
% LCA 4/12/02
k=0;
switch (nsimul)
  case 1 
    for i1=-Nc:Nc
      k=k+1 ;
      n=[i1] ;
      [coeffs,resid]=svd_fit(n,Fv,theta);
      Flist(k).resid=resid;
      Flist(k).modes=n;
      Flist(k).coeffs=coeffs;
    end;
  case 2
    for i1=-Nc:Nc
      for i2=i1+1:Nc
        k=k+1 ;
        n=[i1,i2];
        [coeffs,resid]=svd_fit(n,Fv,theta);
        Flist(k).resid=resid;
        Flist(k).modes=n;
        Flist(k).coeffs=coeffs;
      end;
    end;
  case 3
    for i1=-Nc:Nc
      for i2=i1+1:Nc
        for i3=i2+1:Nc
          k=k+1;
          n=[i1,i2,i3];
          [coeffs,resid]=svd_fit(n,Fv,theta);
          Flist(k).resid=resid;
          Flist(k).modes=n;
          Flist(k).coeffs=coeffs;
        end;
      end;
    end;
end;


% return solution with the smallest residual
j=1;
for m=2:k; if Flist(m).resid < Flist(j).resid ; j=m ; end;  end;
n=Flist(j).modes ;
a=Flist(j).coeffs ;
dF=Flist(j).resid ;

return;


% #################################################
function [dYF]=res(Fv,a,g)
% function computes the residual
dYF=0;
r=g*a-Fv;
% take Hermitian tranpose
dYF=(abs(r'*r)/abs(Fv'*Fv))^0.5;
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



function [coeffs,resid]=svd_fit(n,Fv,theta)

   % function peforms an SVD fit to obtain a
   % set of Fourier coefficients "coeffs" of modes
   % defined in array "n" to the complex amplitudes
   % set in array "Fv" of signals at angle "theta".
   % The residual is also returned.

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
   coeffs = V*diag(Winv)*U'*Fv;
   resid=res(Fv,coeffs,g);
      
return;
