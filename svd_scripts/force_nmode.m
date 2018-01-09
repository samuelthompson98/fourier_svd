function [Y]=force_nmode(X,t_force, n_force, f_force)
%
% For nsimul =1
% Force mode with n = n_force at f = f_force about df_force
%
% 17/08/2013 MJH

Z      = X;  % save copy
nsimul = 1;
Nc     = 20;

i_tforce = min(find(X(1).t>= t_force));
t_force  = X(1).t(i_tforce);
i_fforce = min(find(X(1).f>= f_force));
f_force  = X(1).f(i_fforce);


% irange_fforce    = find((X(1).f >= f_force - df_force)&(X(1).f <= f_force + df_force));
% [Xpk, i_fforce]  = max(abs(X(1).F(irange_fforce, i_tforce)));
% f_force   = X(1).f(i_fforce + min(irange_fforce)-1);
% remove offset such that phi_1 = 0


% call mode code
str1=['imposing mode structure at t= ' ,num2str(t_force)];
str2=['imposing mode structure at f= ' ,num2str(f_force)];
disp([str1]);
disp([str2]);

% remove offset to make coil(1) = 0

disp(['Fixing offset so angle of coil 1 = 0 ']);
Nitem = size(X,2);
k     = 1;
start = 1;
for i=1:Nitem
  if (X(i).data)&&(start==1)
    phi0     = X(i).phi;
    X(i).phi = X(i).phi - phi0;
    start    = 0;
    k=2;
  elseif (X(i).data)&&(start==0)
    X(i).phi = X(i).phi - phi0;
    k=k+1;
  end;
end;

k=1;
Nitem=size(X,2);
for i=1:Nitem
  if X(i).data
    F(k)     = X(i).F(i_fforce,i_tforce);
    phi(k)   = X(i).phi + phi0;
    phip(k)  = X(i).phi;
    k=k+1;
  end;
end;

F     = F.';
phip  = phip.';
phi   = phi';

angle_F     = unwrap(angle(F));
alpha_solns = angle_F - n_force * phi 

alpha_phase = angle_F(1);
phip
phip_fit    = (angle_F - alpha_phase)/n_force
phi_fit     = phip_fit + phi0
phi

% overwrite phi in output 
Y = X;
k = 1;
Nitem=size(Y,2);
for i=1:Nitem
  if Y(i).data
    Y(i).phi = phi_fit(k);
    k=k+1;
  end;
end;

return;
