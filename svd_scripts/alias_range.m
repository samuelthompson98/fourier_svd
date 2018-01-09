function [Nc] = alias_range(th, dphi)

% MJH 23/08/2013
% replace coil phase testing with a range about angle dphi

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

% compute complex phase of n=0 outside loop
k=1; n=0;
alpha(k,:)  =exp(1i*0*th(:)*pi/180).';

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
   
% search through to see if complex amplitude is same as
% a smaller mode number. Look at the phase at a single coil to
% start with


  for i=1:k-1
            
      if phase_match(alpha(k,1), alpha(i,1), dphi)
      % test set "i" matches phase of +n mode at coil one
      % now examine phase of this test set at the other coils
      test=1 ; 
      for j=2:Nth
        test=test .*  phase_match(alpha(k,j), alpha(i,j), dphi);
      end
      if test ==1; aliased=1;continue;end;
    end
    if phase_match(alpha(k+1,1), alpha(i,j), dphi)
      % test set "i" matches phase of -n mode at coil one
      % now examine phase of this test set at the other coils
      test=1 ; 
      for j=2:Nth
        test=test .* phase_match(alpha(k+1,j), alpha(i,j), dphi);
      end
      if test ==1; aliased=1;continue;end;
    end
  end

  if ~aliased & phase_match(alpha(k+1,1), alpha(k,1), dphi)      
    % phase of mode +n matches phase of mode -n at coil one.
    % now examine phase at the other coils
    test=1 ; 
    for j=2:Nth
      test=test + phase_match(alpha(k,j), alpha(k+1,j), dphi);
    end
    if test == 1; 
        % MH 21/09/2010 - correct alias: set aliased flag to true
        aliased = 1;
        disp(['WARNING cannot distingish n=+/-',num2str(n)]);
    end;
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
  if n==20 stop= 1; end;
end;

% MH 21/09/2010 - correct alias Nc from Nc = n-2 to Nc = n-1
Nc=n-1;
disp(['Alias number is n=',num2str(Nc)]);

[Xn, Xindex] = sort(X.alpha(:,1));
X.out = X.alpha(Xindex, :);

return;

function [match] = phase_match(zin, zout, dphi)
% MJH 
% determine whether phase of zin matches to zout within angle dphi

if abs(wrap(angle(zin) - angle(zout))) < dphi
    match = 1;
else
    match = 0;
end

