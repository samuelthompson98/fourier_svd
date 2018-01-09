function [Npdf] = null_signal(XF)
% add probability that all noise generated this Fourier amplitude on each Mirnov coil
% MJH 11/11/06
% input:
% XF(Nc), with fields F and f, with Nc = #coils
% xf(Nc), with fields xf.sigma (noise sigma)
%
% assumptions: 
% all XF are active
% all XF frequency bins are identical

size(XF)

Nf = length(XF(1).f);
Nc = length(XF);


for i=1:Nf

    Npdf.CF(i) = 1;
    Npdf.f(i) = XF(1).f(i);
    for j=1:Nc    
        Npdf.CF(i) = exp(-abs(XF(j).F(i))^2/XF(j).sigma^2) * Npdf.CF(i);
    end
    
end
return
