function [res]=gaussian_res(x)

% load matlab state
load 9429_sample_pdf.mat signal_pdf

fit_pdf.mu    = x(1);
fit_pdf.sigma = x(2);

NP = size(signal_pdf.Px, 1);
res= 0;
for j=1:NP
    fit_pdf.Px(j,1) = signal_pdf.Px(j,1);
    fit_pdf.Px(j,2) = 1/(sqrt(2*pi)*fit_pdf.sigma) * exp(-(fit_pdf.Px(j,1) - fit_pdf.mu)^2/(2*(fit_pdf.sigma)^2));
    res = res + abs(signal_pdf.Px(j,2) - fit_pdf.Px(j,2));
end;

return;