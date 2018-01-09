function [ Zout ] = nmode_filter( Z )
% MJH 09/05/2013
% filter modes to be in decreasing order of M (subjscript j=1 ... M)

Zout = Z;

Nf = length(Z.f);

for i=1:Nf
    [Zout.a(i,:),ia] = sort(Z.a(i,:),'descend');
    Zout.n(i,:) = Z.n(i,ia);
end

return

