function zz = colmap(x)

% x denotes linear fraction of colormap devoted to white
% y denotes convergence

z = colormap(jet);

gray = z(1,3);

njet = size(z,1);
nmap = fix(njet/(1-x));

zz(1:nmap-njet,3)       = gray;

zz(1:nmap-njet,1:3)     = 1.0;
zz(nmap-njet+1:nmap,:)  = z;

return

% alternate working to attempt to blend colormap - not successful
% ================================================================
% y denotes convergence

for i=1:nmap-njet
    mul      = 1-(i-1)/(nmap-njet-1);
%    zz(i,:) = gray + (1-gray)* mul;
    zz(i,1:2)= gray * mul^y;
    
    mulb = mul^(0.1)
    zz(i,:) = zz(i,:)/gray^(mulb);
end;


clear zz
nmap = 100;

for i=1:nmap
    zz(i,1:3) = (1-(i-1)/(nmap-1))^y;
end;



return
