function [X,fslice,tslice] = fspecgram(xx, nfft, fs, win, nlap, varargin)

% MJH 25/10/06
% nfft = length of fft
% fs   = sampling frequency
% win  = window function of length nfft, and fixed over all frequencies
% nwin = length of win
% nspec= number of spectra returned
% nlap = number of overlap between samples
% @fchirp = function that describes frequency 
% X(time,freq)= 2D fspectrogram, frequency and time resolved
% t    = time that X is computed
% f    = frequencies that X is computed - from fundamental (ie. fchirp(k, 1))

if ~isempty(varargin)
    flow = varargin{1};
    fhigh= varargin{2};
else
    flow = 0;
    fhigh= fs;    
end;

dt     = 1/fs;
nwin   = length(win); % should be length of fft MJH 30/10/06
kmax   = fix((fhigh-flow)/(fs/nwin))+1
kmax   = min([kmax fix(nfft/2)+1])

nx     = length(xx);
nspec  = nx/nwin;
nslice = fix((nx-nwin)/(nwin-nlap)+1);

X(1:fix(nfft/2)+1, 1:nslice)   = 0;

for k=1:kmax   % frequency loop
    fslice(k) = fs/nwin * (k-1) + flow;
    iptr      = 1;
    for islice = 1:nslice   % time loop
        tslice(islice) = (islice-1)*dt*(nwin-nlap);
        for i=iptr:iptr+nwin-1     % Fourier sum over slice
           % t(i)        = (i-1) * dt + tslice(islice);
           % t(i)        = (i-1) * dt ;
           j           = i-iptr+1;
           deltat(j)   = (j-1) * dt;
           % X(k, islice)= win(j) * xx(i) * exp(-1i * 2 * pi * fchirp(fslice(k),t(i)-tslice(islice)) * (t(i)-tslice(islice)) ) + X(k, islice);
           X(k, islice)= win(j) * xx(i) * exp(-1i * 2 * pi * fchirp(fslice(k),deltat(j)) * deltat(j) ) + X(k, islice);
           % X(k, islice) = win(j) * xx(i) * exp(-1i * 2 * pi/nwin * (k-1) * (j-1) ) + X(k,islice);
        end;
        iptr = iptr + nwin - nlap;    
    end;    
end;

% DEBUGGING =============================================================
% nfft
% for i=1:nwin
%     junk(i) = win(i)*xx(i);
% end;
% junk = junk.';
% disp(['fft in fspecgram input'])
% junk
% junk1 = fft(junk,nfft);
% X(1:fix(nfft/2), 1:nslice) = junk1(1:fix(nfft/2));

tslice = tslice.';
fslice = fslice.';

return;

