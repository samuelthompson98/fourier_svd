function [y]=seed_noise(xn, data_pdf)

% MJH 25/05/04
% given random number 0<=xn<=1, use inverse transformation to seed Px

Nx     = size(xn,1);
for j=1:Nx
     y(j,1) = sqrt(2)*data_pdf.sigma * erfinv(2*xn(j,1)-1) + data_pdf.mu;        
end;
return;
