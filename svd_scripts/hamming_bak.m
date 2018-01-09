function w = hamming(varargin)
%HAMMING   Hamming window.
%   HAMMING(N) returns the N-point symmetric Hamming window in a column vector.
% 
%   HAMMING(N,SFLAG) generates the N-point Hamming window using SFLAG window
%   sampling. SFLAG may be either 'symmetric' or 'periodic'. By default, a 
%   symmetric window is returned. 
%
%   See also BARTLETT, BARTHANNWIN, BLACKMAN, BLACKMANHARRIS, BOHMANWIN, 
%            CHEBWIN, GAUSSWIN, HANN, KAISER, NUTTALLWIN, RECTWIN, TRIANG, 
%            TUKEYWIN, WINDOW.

%   Copyright 1988-2001 The MathWorks, Inc.
%   $Revision: 1.9 $  $Date: 2001/04/02 20:21:54 $

% Check number of inputs
disp(['bugger..']);
error(nargchk(1,2,nargin));

disp(['bugger..']);
[w,msg] = gencoswin('hamming',varargin{:});
error(msg);

% [EOF] hamming.m
