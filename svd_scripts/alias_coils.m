function [Nc,X]=alias_coils(th)

% MJH 30/08/02
% Lynton Appel 13/01/03

% Function computes the alias number n of a given array of theta values
% acc is the accuracy of the Fourier magnitude at a given position. 
%
%  Ensure that all waves have a common phase (i.e. phi=0) at the first coil location
%  by adding an offset to all the coils so that coil 1 is at 0 degrees.
%  We can then ignore this coil for calculating alias number.
th=th-th(1);
if length(th) == 1; disp('Only 1 coil so cannot compute alias number');return; end
th=th(2:length(th));

Nth=length(th);
alpha(1,Nth)=0;
aliased=0;
acc=10000;
acc=1000;
eps = 0.1;

% compute complex phase of n=0 outside loop
  k=1; n=0;
  alpha(k,:)  =exp(1i*0*th(:)*pi/180).';
  alpha(k,:)  =round(real(alpha(k,:))  *acc)/acc + 1i*round(imag(alpha(k,:))  *acc)/acc;

stop = 0;

X.alpha(1,1) = n;
M = size(alpha,2);
X.alpha(1,2:M+1) = alpha;

k=k+1; n=n+1;

% MJH 21/09/2010 - changed (~aliased)|(~stop) to (~aliased)&(~stop)

while (~aliased)&(~stop)

  % complex phase of this mode ((+n/-n)
  alpha(k,:)  =exp(1i*n*th(:)*pi/180).';
  alpha(k+1,:)=exp(-1i*n*th(:)*pi/180).';
  alpha(k,:)  =round(real(alpha(k,:))  *acc)/acc + 1i*round(imag(alpha(k,:))  *acc)/acc;
  alpha(k+1,:)=round(real(alpha(k+1,:))*acc)/acc + 1i*round(imag(alpha(k+1,:))*acc)/acc;
   
% search through to see if complex amplitude is same as
% a smaller mode number. Look at the phase at a single coil to
% start with

    for i=1:k-2
        if (check_alpha(alpha,i,k-1)<eps)||(check_alpha(alpha,i,k)<eps)
            aliased = 1;
        end
    end
  X.n(k)  = +n;
  X.n(k+1)= -n;
  M = size(alpha,2);
  X.alpha(k,1)     = n;
  X.alpha(k+1,1)   = -n;
  X.alpha(k,2:M+1)   = alpha(k,:);
  X.alpha(k+1,2:M+1) = alpha(k+1,:);

  k=k+2;
% test next mode number (+n/-n)
  n=n+1;

  % if n==20 stop= 1; end;   % MJH 08/07/2011. Why n==20? 
  % if n==20 stop= 1; end;   % MJH 17/01/2012
  if n==20 stop= 1; end;
end;

% MH 21/09/2010 - correct alias Nc from Nc = n-2 to Nc = n-1
Nc=n-1;
disp(['Alias number is n=',num2str(Nc)]);

[Xn, Xindex] = sort(X.alpha(:,1));
X.out = X.alpha(Xindex, :);

return;

% ==============================================================
function [tol] = check_alpha(alpha,i,k)

Nth = size(alpha,2);

diff = alpha(i,:)./alpha(k,:);

tol = (diff - diff(1))*(diff - diff(1))';
tol = tol^0.5;
return
