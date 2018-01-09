function y = cnoise(nsamp, color, sr, q)

% cnoise - generate colored noise with power spectrum approximately 1/f^c
% function arguments:
% nsamp = number of output samples
% color = spectrum exponent c
% sr = samplerate (use nsamp if unknown)
% q = normalization constant to avoid divisions by zero (q=1 seems to work fine)


x = randn(1, nsamp);
X = fft(x);
freq = sr * (0:(nsamp/2 - 1)) / nsamp;
H = q ./ (freq.^(color/2) + q);
H = [H, zeros(1, nsamp - length(H))];
Y = X .* H;
y = real(ifft(Y) * 2 * pi);

return
