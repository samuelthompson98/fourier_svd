function [a,n,dF]=msvd1(Fv,th)

% Uses SVD to calcuate up to 2 independant eigen-modes for
% a given Fourier weight matrix Fv and theta array th.
% Returns eigen-mode weights a, eigen-modes n and resides dF
%
% Matthew Hole Jan 2002

global theta n F

theta=th;
F=Fv;

tol=1.0e-3;
svdtol=1.0e-4;

Nc=3;
k=1;

for i=-Nc:Nc
     % mode combination
     n=i;

     % SVD
     clear g U S V W Winv a 
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
     a = V*diag(Winv)*U'*F;
     Y =coeffs(a);
     dF=res(F,a,g);

     dFlist(k,1)=n;
     dFlist(k,2)=dF;
     k=k+1;

end;

% return most likely solution
[C,i]=min(dFlist(:,2));
n =dFlist(i,1);

clear g U S V W Winv a; 
g=gamma(n,theta);
[U,S,V]=svd(g,0);
W=diag(S);     
for h=1:length(W)
   Winv(h)=1/W(h);
end;

% solution
a = V*diag(Winv)*U'*F;
Y =coeffs(a);
dF=res(F,a,g);

return;


% #################################################
function [dYF]=res(F,a,g)

dYF=0;
r=g*a-F;
% take Hermitian tranpose
dYF=(abs(r'*r)/abs(F'*F))^0.5;
return;


function [Y]=coeffs(a)
% calculate Fourier coeffs
global theta n

Nm =length(n);
Nth=length(theta);

Y(Nth)=0;
for i=1:Nth
  for j=1:Nm
     Y(i)=a(j)*exp(-1i*theta(i)*n(j))+Y(i);
  end;
end;
return;

function [g]=gamma(n,theta)

N=length(theta);
M=length(n);

for i=1:N
   for j=1:M   
     g(i,j)=exp(-1i*n(j)*theta(i));
   end;
end;
return;

