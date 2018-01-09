
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
Nth = 11;
Nc  = 20;

2*Nth/(3*5)
theta = rand([1 Nth])*2*pi; 

t0 = cputime;

k= 1;

for i1=-Nc:Nc
  for i2=i1+1:Nc
     for i3=i2+1:Nc
       for i4=i3+1:Nc
            for i5=i4+1:Nc
                  n = [i1,i2,i3,i4,i5];
                  % n = [i1,i2];
                  [glist(k).ginv] = compute_svd_inverse(n,theta);
                  k = k+1;
            end    
         end        
      end;
    end;
end

nchoosek(2*Nc+1,2)

t1 = cputime;
disp(['CPU time = ',num2str(t1-t0)]);

