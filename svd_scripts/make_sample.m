
function make_sample

tmin = 0.5;
tmax = 1.0;
fs   = 1e+5;
dt   = 1/fs;
tvec = tmin : dt : tmax; 
Nt   = length(tvec);
data_pdf.mu    = 0.0;
data_pdf.sigma = 0.1;

for i=1:12
    xmb.cc_mt_2(i).data         = 1;
    xmb.cc_mt_2(i).signal(:,1)  = tvec;
    % xmb.cc_mt_2(i).signal(:,2)  = 2*(rand(Nt,1)-0.5);
    % xmb.cc_mt_2(i).signal(:,2)  = 2*(rand(Nt,1)-0.5);
    for j=1:Nt
        xmb.cc_mt_2(i).signal(j,2) = sqrt(2)*data_pdf.sigma * erfinv(2*rand-1) + data_pdf.mu;        
    end;
end;

save 9429_sample.mat xmb

return;