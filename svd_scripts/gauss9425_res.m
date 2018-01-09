% residue function =====================================================
function [res]=gauss9425_res(x)

% load matlab state
load 9425_xmd_pdf_hr.mat signal_pdf icoil

fit_pdf.mu    = x(1);
fit_pdf.sigma = x(2);

NP = size(signal_pdf(icoil).Px, 1);
res= 0;
for j=1:NP
    fit_pdf.Px(j,1) = signal_pdf(icoil).Px(j,1);
    fit_pdf.Px(j,2) = 1/(sqrt(2*pi)*fit_pdf.sigma) * exp(-(fit_pdf.Px(j,1) - fit_pdf.mu)^2/(2*(fit_pdf.sigma)^2));
    if (signal_pdf(icoil).Px(j,2)~=0)
      res = res + abs(signal_pdf(icoil).Px(j,2) - fit_pdf.Px(j,2));
    end;
end;

return;