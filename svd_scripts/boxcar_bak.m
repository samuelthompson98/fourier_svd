function w = boxcar(n_est)
%BOXCAR Boxcar window.
%   W = BOXCAR(N) returns the N-point rectangular window.
%
%   See also BARTLETT, BLACKMAN, CHEBWIN, HAMMING, HANN, KAISER
%   and TRIANG.

%   Copyright 1988-2001 The MathWorks, Inc.
%       $Revision: 1.7 $  $Date: 2001/04/02 20:22:26 $

w = ones(n_est,1);

% [EOF] boxcar.m
