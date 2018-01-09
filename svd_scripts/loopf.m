function [list]=loopf(X,tslice,flow,fhigh,nsimul)

% find frequency markers. fhigh offset by df to handle f=fhigh

% find non-zero freq array
i=1;
while X(i).data==0
  i=i+1;
end;
f    = X(i).f;
ilow = min(find(f>=flow));
ihigh= min(find(f>=fhigh-1));

j=0;
for i=ilow:ihigh
  j=j+1;
  [a,n,dF]=torm(X,tslice,f(i),nsimul);
  list.f(j,1) =f(i);
  list.n(j,:) =n(:);
  list.a(j,:) =a(:);
  list.dF(j,1)=dF;

  % MJH testing START ==========================================
  % f(i)
  % if abs((f(i)-1.5869143e+04)/f(i)) < 1.0e-6
  %     disp(['f(i) = f_force']);
  % end
  % MJH testing STOP ===========================================
  
  
end;

return;
