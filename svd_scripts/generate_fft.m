
% generate_fft

% MJH 01/07/07
% Example generation of FFT 

clear all

fs   = 1e+6;
dt   = 1/fs;
tmax = 1e-3;
t    = 0:dt:tmax;
Nt   = length(t);

PHI  = pi/2;
f0   = 20e+3;
x    = sin(2*pi* f0*t  + PHI);

X = fft(x);

