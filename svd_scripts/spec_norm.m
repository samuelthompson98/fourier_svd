
function [norm] = spec_norm(winl)

% spec_temp
% drive spec with a test function, and examine amplitude of signal.
% determines normalization for spec.m

f0   = 100e+3;
fs   = 1e+6;
tmin = 0.0;
tmax = 1000/f0;
dt   = 1/fs;

A = 1.0;
t = tmin:dt:tmax;
x = A* sin(f0*t);

temp.data        = 1;
temp.signal(:,1) = t;
temp.signal(:,2) = x;
temp.phi         = 0;

% run spectrogram in normalization mode
TEMP = spec(temp, winl,1,1);
norm = A/max(abs(TEMP.F(:,1)));

% TEMP = spec(temp, winl,norm,0);
% norm = A/max(abs(TEMP.F(:,1)));

graphics = 0;
if graphics 
    figure;
    plot(t(1:winl),x(1:winl));

    render(TEMP);

    figure;
    plot(TEMP.f(1,:), abs(TEMP.F(:,1)))
end;
return;