function zz = colmap(x,y)

% x denotes linear fraction of colormap devoted to blue scaling
% y denotes convergence

z = colormap(jet);

gray = z(1,3);

njet = size(z,1);
nmap = fix(njet/(1-x));

zz(nmap-njet+1:nmap,:)  = z;
for i=1:nmap-njet
    mul     = exp(y*(1- (i-1)/(nmap-njet)));
    zz(i,:) = gray * mul;
end;



return
