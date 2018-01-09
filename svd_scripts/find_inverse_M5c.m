
function find_inverse


% compute pseudo inverse matrices 
% find_inverse_M5.m

% test inverse

clear X U S V F 
clear all

X = [ [1 2]; [3 4]; [5 6]; [7 8]];

[U,S,V] = svd(X,0)

U*S*V'
F = [1; 2; 3; 4;];
V*inv(S)*U'* F


% ===========================
% Nth = 11;
% Nc  = 20;
Nth = 11;
Nc  = 14;

2*Nth/(3*5)

s=RandStream('mt19937ar');
reset(s);
theta = rand(s, [1 Nth])*2*pi; 

t0 = cputime;

k= 1;

for i1=-Nc:Nc
  for i2=i1+1:Nc
     for i3=i2+1:Nc
       for i4=i3+1:Nc
            for i5=i4+1:Nc
                  glist(k).n    = [i1,i2,i3,i4,i5];
                  glist(k).g    = gamma(glist(k).n,theta);
                  [U,S,V]       = svd(glist(k).g,0);
                  glist(k).ginv = V*inv(S)*U';
                  k = k+1;
            end    
         end        
      end;
    end;
end

save glist_inv_Nc10_M5.mat glist

disp(['k = ',num2str(k-1)]);
disp(['nchoosek(2*Nc+1,5) = ',num2str(nchoosek(2*Nc+1,5))]);

t1 = cputime;
disp(['CPU time = ',num2str(t1-t0)]);

return


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