
function [data_pdf, spectra_pdf]=MC_data(MC_temp, varargin)

% MJH 05/06 generate Gaussian distributed data

global NP NX tcpu data_pdf X spectra_pdf

% MJH 08/03/07 - remove sample restart

    % MJH 04/04 
    % pre-allocation
    % MJH 08/03/07 - reset sampling frequency to 2 MHz.
    fs   = 2e+6;
    dt   = 1/fs;

    % MJH 08/03/07 - window length forced to 4096; was previously 128 resulting in df=7.8125 kHz.
    % This caused disagreement in pdf moments of frequency vs. detailed pdf descriptions
    winl  = 4096;
    tmin = 0.0;
    tmax = winl * dt
    
    Nt   = (tmax - tmin)/dt;
    NX0  = fix(Nt);
    tvec =  tmin: dt: (tmax-dt);
    NX = max([NX0 4000*NX0]);
    NP = 40;
    % NX = 1e+3;
    % NP = 100;
    data_pdf.pdf = 'gaussian';
    data_pdf.Px  = zeros(NP, 2);
    data_pdf.IPx = zeros(NP, 2);
    
    if isempty(varargin)           
       data_pdf.sigma = 1.0;
       data_pdf.mu    = 0.0;
    else
       data_pdf.sigma = varargin{2};
       data_pdf.mu    = varargin{1};
    end;  

    % form data_pdf
    xmin = data_pdf.mu - 4 * data_pdf.sigma;
    xmax = data_pdf.mu + 4 * data_pdf.sigma;
    dx   = (xmax-xmin)/(NP-1);
    data_pdf.Px(:,1)    = xmin:dx:xmax; 
    data_pdf.IPx(:,1)   = xmin:dx:xmax; 
    
    for j=1:NP
       data_pdf.Px(j,2) = 1/(sqrt(2*pi)*data_pdf.sigma) * exp(-(data_pdf.Px(j,1) - data_pdf.mu)^2/(2*(data_pdf.sigma)^2));
    end;
    
    % form spectra_pdf
    % Nf   = NP/2;
    df   = 1/tmax;
    fmin = df;
    fmax = fs/2
    fvec = fmin:df:fmax;
    Nf   = length(fvec)
    
    % Nf x NP x 3 arrays: 
    % (:,:,1) = freq
    % (:,:,2) = xbin
    % (:,:,3) = xpdf
    spectra_pdf.IPFr   = zeros(Nf, NP, 3);
    spectra_pdf.IPFi   = zeros(Nf, NP, 3);
    spectra_pdf.IPFmag = zeros(Nf, NP, 3);
    spectra_pdf.IPFph  = zeros(Nf, NP, 3);
    
    Ncoils = 30;
    A      = pi* (10.7e-3)^2;
    Vdb    = A * Ncoils; % H/V calibration from coil 
    for i=1:Nf
        spectra_pdf.IPFr(i,1:NP,1)    = fvec(i); 
        spectra_pdf.IPFi(i,1:NP,1)    = fvec(i); 
        spectra_pdf.IPFmag(i,1:NP,1)  = fvec(i); 
        spectra_pdf.IPFph(i,1:NP,1)   = fvec(i); 

        Fmin  = -max([abs(xmax) abs(xmin)])/(2*pi* fvec(i) * Vdb);
        Fmax  = +max([abs(xmax) abs(xmin)])/(2*pi* fvec(i) * Vdb);

        % winl  = min([4096 Nt])
        % MJH 15/07/06
        % arbitrary division by factor of winl, 
        % signal has zero autocorrelation, and therefore Fk will tend to accumulate near Fk=0.
        
        Fmin  = Fmin/(2*sqrt(winl));
        Fmax  = Fmax/(2*sqrt(winl));
        dF    = (Fmax-Fmin)/(NP-1);
        Fvec  = Fmin:dF:Fmax;
        spectra_pdf.IPFr(i,:,2)    = Fvec; 
        spectra_pdf.IPFi(i,:,2)    = Fvec;

        Fmagmin = 0.0;
        Fmagmax = +sqrt(2)*Fmax;
        dFmag   = (Fmagmax-Fmagmin)/(NP-1);
        Fmagvec = Fmagmin:dFmag:Fmagmax;
        spectra_pdf.IPFmag(i,:,2)  = Fmagvec; 

        spectra_pdf.IPFph(i,:,2)   = -pi:(2*pi)/(NP-1):pi; 
    end;
  klow = 1;
  khigh= fix(NX/NX0);    

khigh = max([khigh 1]);
disp(['klow  = ', num2str(klow)]);
disp(['khigh = ', num2str(khigh)]);

for k=klow:khigh

    % process start
    tcpu(k) = cputime;

    % generate seed cumulative pdf 
    X = rand(fix(NX0),1);
 
    % make data
    data.data = 1;
    data.signal(:,1) = tvec;
    data.signal(:,2) = data.signal(:,1);
    data = make_fdata(data);
    
    % generate data spectra
    set(0,'DefaultFigureVisible','off');
    spectra = MC_spec(data, winl);

    % bin data
    bin_data(data);

    % bin spectra
    bin_spectra(spectra);

    disp(['Iteration k = ', num2str(k),': saving data to file']);
    save(MC_temp, 'data_pdf','tcpu', 'NP', 'NX','NX0', 'spectra_pdf','spectra','data','k','khigh','tvec');
 end;

% free memory
clear global X;
clear data;

return;

% =========================================================================
function [data]=make_fdata(data)
global X data_pdf

data.signal(:,2) = seed_fx(X);
 
return;

% ======================================================================
function bin_data(data)
global data_pdf

data_pdf.IPx    = bin_point(data.signal(:,2), data_pdf.IPx);

return;

% ======================================================================
function bin_spectra(spectra)
global spectra_pdf

% find correspinding frequency bin and insert F_k

Nf = size(spectra_pdf.IPFr, 1);
NP = size(spectra_pdf.IPFr, 2);

for k=1:Nf
    temp(1:NP,1) = spectra_pdf.IPFr(k,1:NP,2).';        
    temp(1:NP,2) = spectra_pdf.IPFr(k,1:NP,3).' ;
    temp         = bin_point(real(spectra.F(k)), temp);
    spectra_pdf.IPFr(k,1:NP,3) = temp(1:NP,2).';

    temp(1:NP,1) = spectra_pdf.IPFi(k,1:NP,2).';        
    temp(1:NP,2) = spectra_pdf.IPFi(k,1:NP,3).' ;
    temp         = bin_point(imag(spectra.F(k)), temp);
    spectra_pdf.IPFi(k,1:NP,3) = temp(1:NP,2).';
    
    temp(1:NP,1) = spectra_pdf.IPFmag(k,1:NP,2).';        
    temp(1:NP,2) = spectra_pdf.IPFmag(k,1:NP,3).' ;
    temp         = bin_point(abs(spectra.F(k)), temp);
    spectra_pdf.IPFmag(k,1:NP,3) = temp(1:NP,2).';

    temp(1:NP,1) = spectra_pdf.IPFph(k,1:NP,2).';        
    temp(1:NP,2) = spectra_pdf.IPFph(k,1:NP,3).' ;
    temp         = bin_point(angle(spectra.F(k)), temp);
    spectra_pdf.IPFph(k,1:NP,3) = temp(1:NP,2).';
end;


return;

% ======================================================================
function [Px] = bin_point(x, Px,varargin)
% bin point linearly
% NB: ALL bin points must be equi-spaced within machine precision (06/04/04).

% random check
check = 1;
if check==1  
  eps   = 1.0e-8;
  NP    = size(Px,1);
  index1= fix(rand*NP); index1 = max([ 2 index1]);
  index2= fix(rand*NP); index2 = max([ 2 index2]);
  % disp(['index1 = ',num2str(index1),', index2 = ',num2str(index2)]);
  dx    = Px(index1,1) - Px(index1-1,1);
  dx2   = Px(index2,1) - Px(index2-1,1);
   if abs(1-dx/dx2)>eps
       error(['Crash: bin_point called with non-uniformly spaced pdf bins']);
   end;
else 
    dx    = Px(2,1) - Px(1,1);
end;
    
% find bin index for each point
clear index;
% MJH 08/04/04 add all points less than least bin to lowest bin
% MJH 03/05/04 plus double bin pdf as bin is half size
index   = find(x(:,1)<= Px(1,1)+dx/2);
Px(1,2) = Px(1,2) + size(index,1);

for i=2:NP-1
  clear index;
  index = find((x(:,1) > Px(i,1)-dx/2) & (x(:,1)<= Px(i,1)+dx/2));
  Px(i,2) = Px(i,2) + size(index,1);   % add number of points
  
end;

clear index;
% MJH 08/04/04 add all points greater than top bin to top bin
% MJH 03/05/04 plus double bin pdf as bin is half size
index   = find(x(:,1) > Px(NP,1)-dx/2);
Px(NP,2) = Px(NP,2) + size(index,1);
return;


% ======================================================================
function [y]=seed_fx(xn)

% MJH 25/05/04
% given random number 0<=xn<=1, use inverse transformation to seed Px

global data_pdf

Nx     = size(xn,1);
for j=1:Nx
    switch data_pdf.pdf
    case 'gaussian'
       y(j,1) = sqrt(2)*data_pdf.sigma * erfinv(2*xn(j,1)-1) + data_pdf.mu;        
    case 'lognormal'
       y(j,1) = sqrt(2*data_pdf.sigmaln)*erfinv(2*xn(j,1)-1) + data_pdf.muln;
       y(j,1) = exp(y(j,1));
    end;
end;
return;

