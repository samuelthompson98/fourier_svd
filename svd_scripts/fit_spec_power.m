function [ f_struc ] = fit_spec_power( f_struc )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global f_temp a_temp

f_temp  = f_struc.f;
a_temp  = f_struc.F(:,1).';

% =======================================================
% cutoff, below this all amplitudes mapped to white
% fit to power law, and show if more than X% above power law.

N     = length(f_temp);

x0(2) = log(abs(a_temp(N)/a_temp(1))) / log(f_temp(N)/f_temp(1)) ;
x0(1) = abs(a_temp(1))/f_temp(1)^x0(2);

options = optimset('Display','iter','TolFun',1e-8);
[x,fval,exitflag,output] = fminsearch(@powerlaw,x0,options);

f_struc.alpha = x(1);
f_struc.beta  = x(2);

f_struc.F_fit = f_struc.alpha * f_temp.^(f_struc.beta).';

a_0 =  x0(1) * f_temp.^(x0(2)).';

figure; hold on;
loglog(f_struc.f, abs(f_struc.F(:,1)),'k-');
loglog(f_struc.f, abs(f_struc.F_fit(:,1)),'r-');
loglog(f_struc.f, 4 * abs(f_struc.F_fit(:,1)),'r--');
loglog(f_struc.f, abs(a_0(:,1)),'b-');
loglog(f_struc.f, 4 * abs(a_0(:,1)),'b--');
set(gca,'YScale','log','XScale','log');

% f_struc.alpha = x0(1);
% f_struc.beta  = -1;

end

% ================================================================

function [res] = powerlaw(x0)

global f_temp a_temp

alpha = x0(1);
beta  = x0(2);

a_power = alpha * f_temp.^(beta);
res     = sum(abs(log(abs(a_temp / a_power))));

end
