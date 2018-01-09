% formfigure4_batch
% 1. Fit Gaussian to data ==============================================

load 9425_xmd.mat

disp(['Fix Polarity =================================']);
pol_fix = 0;
if pol_fix
  xmd.omt(1).signal(:,2)  = - xmd.omt(1).signal(:,2);
  xmd.omt(2).signal(:,2)  = + xmd.omt(2).signal(:,2);
  xmd.omt(3).signal(:,2)  = - xmd.omt(3).signal(:,2);
end;


disp(['Fit signal pdf ===============================']);
% use elements of siganl_pdf_9425

tcoil      = 1;
Ncoils     = 3;

tmin       = 0.239;
tmax       = 0.35;
imin       = min(find(xmd.omt(tcoil).signal(:,1)>tmin))
imax       = max(find(xmd.omt(tcoil).signal(:,1)<tmax))
% signal_pdf = init_xmd_pdf(xmd, imin, imax);

% bin data 
for i=1:Ncoils
   signal_pdf(i) = init_xmd_pdf(xmd, imin, imax, i);
   if xmd.omt(i).data     
       signal_pdf(i).Px  = bin_point(xmd.omt(i).signal(imin:imax,2), signal_pdf(i).Px);
   end;   

  % normalise pdfs
  dPx = signal_pdf(i).Px(2,1) - signal_pdf(i).Px(1,1);
  signal_pdf(i).Px(:,2) = signal_pdf(i).Px(:,2)/sum(signal_pdf(i).Px(:,2)*dPx) ;

  icoil = i;
  save 9425_xmd_pdf_hr.mat signal_pdf icoil

  % fit to Gaussian pdf
  xmin = min(xmd.omt(i).signal(imin:imax,2));
  xmax = max(xmd.omt(i).signal(imin:imax,2));

  x0(1) = (xmin+xmax)/2;
  x0(2) = (xmax-xmin)/2;

  OPTIONS = OPTIMSET('MaxIter', 1000, 'MaxFunEvals', 1e+7, 'TolFun', 1e-10,'Display', 'iter');  
  x     = fminsearch(@gauss9425_res,x0, OPTIONS)
  res   = gauss9425_res(x)

  % construct fit
  fit_pdf(i).mu    = x(1);
  fit_pdf(i).sigma = x(2);

  NP = size(signal_pdf(i).Px, 1);
  for j=1:NP
      fit_pdf(i).Px(j,1) = signal_pdf(i).Px(j,1);
      fit_pdf(i).Px(j,2) = 1/(sqrt(2*pi)*fit_pdf(i).sigma) * exp(-(fit_pdf(i).Px(j,1) - fit_pdf(i).mu)^2/(2*(fit_pdf(i).sigma)^2));
  end;

  % figure; hold on;
  % plot(signal_pdf(i).Px(:,1), signal_pdf(i).Px(:,2),'kx');
  % plot(fit_pdf(i).Px(:,1),    fit_pdf(i).Px(:,2),'k-');
  % set(gca, 'YScale','log');
  % pause(0);
  
end; % Ncoils for loop

save 9425_xmd_pdf_hr.mat signal_pdf fit_pdf icoil

exit

% 2. Generate statistics ==============================================

file   = 'MC_9425d'
Ncoils = 1;

for i=1:Ncoils
   [data_pdf(i), spectra_pdf(i)]=MC_data(file, fit_pdf(i).mu, fit_pdf(i).sigma);
   save(file, 'data_pdf','spectra_pdf'); 
end;

exit




