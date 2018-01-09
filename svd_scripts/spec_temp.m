
function spec_temp
% spec_temp
% drive spec with a test function, and examine amplitude of signal.

f0   = 100e+3;
fs   = 1e+6;
tmin = 0.0;
tmax = 1000/f0;
dt   = 1/fs;

A = 2* 1.5;
t = tmin:dt:tmax;
x = A* sin(f0*t);

temp.data        = 1;
temp.signal(:,1) = t;
temp.signal(:,2) = x;
temp.phi         = 0;

winl = 4096;
TEMP = spec(temp, winl);

figure;
plot(t(1:winl),x(1:winl));

render(TEMP);

figure;
plot(TEMP.f(1,:), abs(TEMP.F(:,1)))

return;