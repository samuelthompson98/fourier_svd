function w = blackman(varargin)
%BLACKMAN   Blackman window.
%   BLACKMAN(N) returns the N-point symmetric Blackman window in a column
%   vector.
%   BLACKMAN(N,SFLAG) generates the N-point Blackman window using SFLAG
%   window sampling. SFLAG may be either 'symmetric' or 'periodic'. By 
%   default, a symmetric window is returned. 
%
%   See also BARTLETT, BARTHANNWIN, BLACKMANHARRIS, BOHMANWIN, CHEBWIN, 
%            GAUSSWIN, HAMMING, HANN, KAISER, NUTTALLWIN, RECTWIN, TRIANG, 
%            TUKEYWIN, WINDOW.

%   Copyright 1988-2001 The MathWorks, Inc.
%   $Revision: 1.9 $  $Date: 2001/04/02 20:22:27 $

% Check number of inputs
error(nargchk(1,2,nargin));

[w,msg] = gencoswin('blackman',varargin{:});
error(msg);

% [EOF] blackman.m
