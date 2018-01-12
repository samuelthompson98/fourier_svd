function [a,n,dF]=torm(X,tslice,fslice,nsimul);

% caclulate spatial spectrogram for one freq ie. Y(f,t)
% MJH Oct 02

k=1;
Nitem=size(X,2);
for i=1:Nitem
  if X(i).data
    tm=min(find(X(i).t>=tslice));
    fm=min(find(X(i).f>=fslice));
    %disp(abs(X(i).F(fm, :)))
    F(k)    =X(i).F(fm,tm);
    angle(k)=X(i).phi;
    Nc      =X(i).Nc;
    k=k+1;
  end;
end;

F       = F.';
angle   = angle.';
[a,n,dF]= msvd(F,angle,Nc,nsimul);

return;

