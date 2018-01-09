function [f] = fchirp(f0, ti)

% MJH 30/10/06 - frequency is time derivative of phase
% employ linear frequency ramp

global deltaf

f1 = deltaf/2;

f  = f0 + f1 * ti;

return