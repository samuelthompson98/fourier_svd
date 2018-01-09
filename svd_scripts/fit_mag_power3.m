function [ n_struc ] = fit_mag_power3( n_struc , varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global f_temp a_temp

f_temp  = n_struc.f;
a_temp  = n_struc.a(:,1);

% =======================================================
% cutoff, below this all amplitudes mapped to white
% fit to power law, and show if more than X% above power law.

N     = length(f_temp);

x0(2) = log(abs(a_temp(N)/a_temp(1))) / log(f_temp(N)/f_temp(1)) ;
x0(1) = abs(a_temp(1))/f_temp(1)^x0(2);

x0 = double(x0);

options = optimset('Display','iter','TolFun',1e-8);
[x,fval,exitflag,output] = fminsearch(@powerlaw,x0,options);

n_struc.alpha = x(1);
n_struc.beta  = x(2);

n_struc.a_fit = n_struc.alpha * f_temp.^(n_struc.beta);

a_0 =  x0(1) * f_temp.^(x0(2));

if isempty(varargin)
    snr_confidence = 4;
else
    snr_confidence = varargin{1};
end 

figs =1;
if figs  
    figure; hold on;
    loglog(n_struc.f, abs(n_struc.a(:,1)),'k-');
    loglog(n_struc.f, abs(n_struc.a_fit(:,1)),'r-');
    loglog(n_struc.f, snr_confidence * abs(n_struc.a_fit(:,1)),'m-');
    loglog(n_struc.f, abs(a_0(:,1)),'b-');
    set(gca,'YScale','log','XScale','log');
end

end

% ================================================================

function [res] = powerlaw(x0)

global f_temp a_temp

alpha = x0(1);
beta  = x0(2);

a_power = alpha * f_temp.^(beta);
res     = sum(abs(log(abs(a_temp ./ a_power))));  % MJH 14/05/2013. Change / to ./
res     = double(res);
end
