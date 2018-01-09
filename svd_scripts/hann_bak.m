function w = hann(varargin)
%HANN   Hann window.
%   HANN(N) returns the N-point symmetric Hann window in a column vector.
% 
%   HANN(N,SFLAG) generates the N-point Hann window using SFLAG window sampling.
%   SFLAG may be either 'symmetric' or 'periodic'. By default, a symmetric
%   window is returned. 
%
%   See also BARTLETT, BARTHANNWIN, BLACKMAN, BLACKMANHARRIS, BOHMANWIN, 
%            CHEBWIN, GAUSSWIN, HAMMING, KAISER, NUTTALLWIN, RECTWIN, TRIANG, 
%            TUKEYWIN, WINDOW.

%   Copyright 1988-2001 The MathWorks, Inc.
%   $Revision: 1.5 $  $Date: 2001/04/02 20:21:53 $ 

% Check number of inputs
error(nargchk(1,2,nargin));

[w,msg] = gencoswin('hann',varargin{:});
error(msg);

% [EOF] hann.m
