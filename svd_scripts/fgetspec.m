% ==========================================================
function [bpl, fl, t, dt, df]=fgetspec(x,a, varargin) 

fs   = 1/(x(2,1)-x(1,1));
% nfft length

if isempty(varargin)
    winl = min(128, length(x));
    norm = 1;
    test = 0;
    flow = fs/winl;
    fhigh= fs/2;
elseif (size(varargin,2)==1)
    winl = varargin{1};    
    norm = 1;
    test = 0;
    flow = fs/winl;
    fhigh= fs/2;
elseif  (size(varargin,2)==2)  
    winl = varargin{1};    
    norm = varargin{2};
    test = 0;
    flow = fs/winl;
    fhigh= fs/2;
elseif (size(varargin,2)==3)  
    winl = varargin{1};    
    norm = varargin{2};
    test = varargin{3};
    flow = fs/winl;
    fhigh= fs/2;
elseif (size(varargin,2)==5)  
    winl = varargin{1}    
    norm = varargin{2}
    test = varargin{3}
    flow = varargin{4}
    fhigh= varargin{5}
end;

nfft = min(winl,length(x))
nlap = fix(winl/2)

% Choose windowing
% win = boxcar(nfft);
% win = blackman(nfft,'periodic');
% win  = hann(nfft,'periodic');
win = hamming(nfft,'periodic');

[b,f,t]=fspecgram(x(:,2),nfft,fs,win, nlap, flow, fhigh);
df = fs/winl;
dt = 1/fs;

% expected number of spectra in b = length of t vector
NX = size(x,1);
k  = fix((NX-nlap)/(winl-nlap));
disp([' No of windows  = ',num2str(k)]);

% offset time axis
% t  = t + x(1,1);
% h  = axes('Position',[0 0 1 1],'Visible','off');

% calibrate data -----------------------------------
% Values of OMAHA taken from stray capacitance paper 
% Assume 10 times gain is off
Ncoils = 30;
A      = pi* (10.7e-3)^2;

if ~test 
    bp(1,:) = b(1,:);
    for i=1:size(f)
        bp(i,:) = norm * b(i,:)/(2*pi*f(i)*Ncoils*A* nfft); 
    end
else
    bp(1,:) = b(1,:);
    for i=1:size(f)
        bp(i,:) = norm * b(i,:)/nfft;  % nfft normalizes for Matlab defn of FFT
    end
 end;

% apply filter 
hf = polyval(a,2*pi*f*1i);
for i=1:size(f)
   bp(i,:)=bp(i,:)*hf(i);
end

% MJH 20/06/07: overload and rewrite
bp = norm * b;

% select freq slice
fl = f;
bpl= bp;

return;

