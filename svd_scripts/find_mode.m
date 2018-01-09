function [X]=find_mode(Z,f)

% reveal mode numbers at particular frequencies

flow = f(1);
fhigh= f(2);

i_low = min(find(Z.f >= flow));
i_high= min(find(Z.f >= fhigh));



  [X.a, i_max] = max(abs(Z.a(i_low:i_high)));
  X.mag_a = Z.a(i_low + i_max - 1);
  X.mag_n = Z.n(i_low + i_max - 1);
  X.mag_f = Z.f(i_low + i_max - 1);

  [X.a, i_max] = min(Z.dF(i_low:i_high));
  X.con_a = Z.a(i_low + i_max - 1);
  X.con_n = Z.n(i_low + i_max - 1);
  X.con_f = Z.f(i_low + i_max - 1);


return
