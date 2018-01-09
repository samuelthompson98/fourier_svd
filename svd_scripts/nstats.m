function nstats(th,Nc,Nph)

% 13/09/05 - check using |F_k| and <F_k seeding, using 1 mode extraction.

for i=1:Nph
  % radnomize mag. and phase on each coil -----------------------------------
  for j=1:3
    F(j,1)=rand*exp(1i*2*pi*rand);
  end;
  
  [a1,n1,dF1]=msvd(F,th,Nc,1);

  Z1.n(i) = n1;
  Z1.a(i) = a1.';
  Z1.dF(i)= dF1;

  [a2,n2,dF2]=msvd(F,th, Nc, 2);

  Z2.n(i,:) = n2;
  Z2.a(i,:) = a2.';
  Z2.dF(i)  = dF2;
  
  % gaussian distributed Fkr and Fki on each coil ----------------------------
  fit_pdf.mu    = 0;
  fit_pdf.sigma = 1;
  for j=1:3
    F(j,1)=(sqrt(2)*fit_pdf.sigma * erfinv(2*rand-1) + fit_pdf.mu) + ...
            1i * (sqrt(2)*fit_pdf.sigma * erfinv(2*rand-1) + fit_pdf.mu);
  end;
  
  [a1,n1,dF1]=msvd(F,th,Nc,1);

  ZG1.n(i) = n1;
  ZG1.a(i) = a1.';
  ZG1.dF(i)= dF1;

  [a2,n2,dF2]=msvd(F,th, Nc, 2);

  ZG2.n(i,:) = n2;
  ZG2.a(i,:) = a2.';
  ZG2.dF(i)  = dF2;

  save nstats.mat Z1 Z2 ZG1 ZG2

  
end;

return;

