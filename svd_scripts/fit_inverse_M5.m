
function fit_inverse_M5

load XMD_M5.mat XMD

it_slice = 1;
[Fmax, if_slice] = max(abs(XMD.omt(1).F(:,it_slice)))

for i=1:length(XMD.omt)
    F(i) = XMD.omt(i).F(if_slice,it_slice);
end

Fv = F.';

load glist_inv_Nc10_M5.mat glist

t0 = cputime;

Nglist = length(glist)
for i=1:Nglist
    % ginv(i,:,:) = glist(i).ginv;
    % g(i,:,:)    = glist(i).g;
    
    alist(i,:) = glist(i).ginv * Fv;
    rlist(i)   = res(Fv,glist(i).ginv * Fv,glist(i).g);
end;    

% mode Fourier coefficients are Fv

% alist(:) = ginv(:) * Fv.';
% rlist = res(Fv,alist,glist.g);

% find best fit
[r, i_soln] = min(rlist);
a = alist(i_soln,:);
n = glist(i_soln).n;

[b,i_a] = sort(abs(a),2,'descend');
b/b(1)
n(i_a)

t1 = cputime;
disp(['CPU time = ',num2str(t1-t0)]);

return

function [dYF]=res(Fv,a,g)
% function computes the residual
dYF=0;
r=g*a-Fv;
% take Hermitian tranpose
dYF=(abs(r'*r)/abs(Fv'*Fv))^0.5;
return;
