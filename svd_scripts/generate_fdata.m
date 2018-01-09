
function [x] = generate_fdata

% OUTPUT 
% x.data = 1 (signal present)
% x.signal(:,1) = time column
% x.signal(:,2) = data column

tmin = 0.0;
tmax = 1e-3;
fs   = 1e+6;
dt   = 1/fs;
tmax = tmax - dt;
Nt   = (tmax - tmin)/dt

x.data = 1;
x.signal(:,1) = tmin: dt: tmax
x.signal(:,2) = x.signal(:,1)
x.signal(1:Nt,2) = rand(Nt,1);

return

