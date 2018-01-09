function [efit] = Bcomp(efit, coil)

% compute B in (r,t,v) coordinates at location coil.r, coil.v given efit file 
% MJH 11/20006

mu0=4*pi*1e-7;

efit.Z = efit.zmesh;
efit.R = efit.rmesh;

NR = size(efit.R,1);
NZ = size(efit.R,2);

efit.BR = zeros(NR, NZ);
efit.BZ = zeros(NR, NZ);
efit.Bt = zeros(NR, NZ);

% Use centre-difference calculation for B across grid
for k=1:Nt
    for i=2:NR-1
        for j=2:NZ-1
   
        efit.BR(k, i,j) = -1/efit.R(i,j) * (efit.psi(k,i,j+1)-efit.psi(k,i,j-1))/(efit.Z(k,i,j+1)-efit.Z(k,i,j-1));
        efit.BZ(k, i,j) =  1/efit.R(i,j) * (efit.psi(k,i+1,j)-efit.psi(k,i-1,j))/(efit.R(k,i+1,j)-efit.R(k,i-1,j));

        % highly dubious - guess, since Lynton hasn't computed f outside plasma
        efit.Bt(k,i) = efit.Bvacgeom(k,2) * efit.rgeom(k,2)/efit.R(i,j);
        
        end;    
    end;

    % extrapolate to boundaries
    efit.BR(k, 1:NR,1)  = efit.BR(k,1:NR,2);
    efit.BR(k, 1:NR,NZ) = efit.BR(k,1:NR,NZ-1);
    efit.BR(k, 1,1:NZ)  = efit.BR(k,2,1:NR);
    efit.BR(k, NR,1:NZ) = efit.BR(k,NR-1,1:NZ);

    efit.BZ(k,1:NR,1)  = efit.BZ(k,1:NR,2);
    efit.BZ(k,1:NR,NZ) = efit.BZ(k,1:NR,NZ-1);
    efit.BZ(k,1,1:NZ)  = efit.BZ(k,2,1:NR);
    efit.BZ(k,NR,1:NZ) = efit.BZ(k,NR-1,1:NZ);

    efit.Bt(k,1:NR,1)  = efit.Bt(k,1:NR,2);
    efit.Bt(k,1:NR,NZ) = efit.Bt(k,1:NR,NZ-1);
    efit.Bt(k,1,1:NZ)  = efit.Bt(k,2,1:NR);
    efit.Bt(k,NR,1:NZ) = efit.Bt(k,NR-1,1:NZ);

end;


coil.BR(k,2) = interp2(efit.R, efit.Z, efit.BR(k,:,:), coil.R, coil.Z);
coil.BZ(k,2) = interp2(efit.R, efit.Z, efit.BZ(k,:,:), coil.R, coil.Z);
coil.Bt(k,2) = interp2(efit.R, efit.Z, efit.Bt(k,:,:), coil.R, coil.Z);

return;
