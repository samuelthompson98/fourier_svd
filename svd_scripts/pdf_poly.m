
function [pdf] = pdf_poly(pdf)
% fit polynomial to residue function 

pfit = 0;
if pfit 
    porder      = 20;
    [p]         = polyfit(pdf.rbin, pdf.Fr, porder)
    pdf.Frpoly  = polyval(p, pdf.rbin);
end;

% spline over first X zero elements

pdf.Frpoly          = pdf.Fr;
[index]             = min(find(pdf.Frpoly>0))
pdf_eps             = pdf.Fr(index)
pdf.Frpoly(1:index) = 0: pdf_eps/(index-1): pdf_eps;

pdf.Fr = pdf.Frpoly

% figure; hold on
% plot(pdf.rbin, pdf.Fr)
% plot(pdf.rbin, pdf.Frpoly)

return
