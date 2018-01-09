function [n_struc]=nmode_M2spline(X,tmin, tmax, nsimul,flow, fhigh, varargin)

% MJH 14/05/2013
% Hardwire for M=2

% manual over-ride MJH 03/08/2011
% tmin = 1.0;
% tmax = 6.0;

i_val = 1;
while isempty(X(i_val).t)
    i_val=i_val+1;
end

it_min = min(find(X(i_val).t>= tmin));
it_max = max(find(X(i_val).t<= tmax));

% manual alias number
if isempty(varargin)
    Nc = 19;
else
    Nc = varargin{1};
end

k=1;
for i=it_min:it_max 

    [Z(k)]    = nmode1(X,X(i_val).t(i),nsimul,flow, fhigh, Nc);
    Z(k)      = nmode_filter(Z(k));  % filter into descending order
    n_struc.a(:,:,k)  = Z(k).a;
    n_struc.n(:,:,k)  = Z(k).n;
    n_struc.dF(:,k) = Z(k).dF;
    n_struc.t(k,1)  = Z(k).t;
    k = k+1;
    
end

n_struc.f = Z(i_val).f.';

% fit power law to a for first slice
n_struc = fit_mag_power(n_struc);

return


% figure; hold on;
% loglog(n_struc.f, abs(n_struc.a(:,1)),'k-');
% loglog(n_struc.f, abs(n_struc.a_fit(:,1)),'k-');

tnorm = 1;
fnorm = 1;
Nc    = 19;
snr   = 10;

render_nmode1(n_struc, tnorm, fnorm, 19, 10)

% render_nmode_spec(n_struc, 1, 1, 0.001)

