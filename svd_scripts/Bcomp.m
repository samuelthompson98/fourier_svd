function [eft, coil] = Bcomp(eft, coil)

% compute B in (r,t,v) coordinates at location coil.r, coil.v given eft file 
% MJH 11/20006

mu0=4*pi*1e-7;

eft.Z = eft.zmesh;
eft.R = eft.rmesh;

Nt = size(eft.time,1);
NR = size(eft.R,1);
NZ = size(eft.Z,2);

eft.BR = zeros(NR, NZ);
eft.BZ = zeros(NR, NZ);
eft.Bt = zeros(NR, NZ);

% Use centre-difference calculation for B across grid
for k=1:Nt
    for i=2:NR-1
        for j=2:NZ-1
           eft.BR(k, i,j) = -1/eft.R(i,j) * (eft.psi(k,i,j+1)-eft.psi(k,i,j-1))/(eft.Z(i,j+1)-eft.Z(i,j-1));
           eft.BZ(k, i,j) =  1/eft.R(i,j) * (eft.psi(k,i+1,j)-eft.psi(k,i-1,j))/(eft.R(i+1,j)-eft.R(i-1,j));
        end;    
       eft.Bt(k,i) = eft.Bvacgeom(k,2) * eft.rgeom(k,2)/eft.R(i,1);
   end;

    % extrapolate to boundaries
    eft.BR(k, 1:NR,1)  = eft.BR(k,1:NR,2);
    eft.BR(k, 1:NR,NZ) = eft.BR(k,1:NR,NZ-1);
    eft.BR(k, 1,1:NZ)  = eft.BR(k,2,1:NR);
    eft.BR(k, NR,1:NZ) = eft.BR(k,NR-1,1:NZ);

    eft.BZ(k,1:NR,1)  = eft.BZ(k,1:NR,2);
    eft.BZ(k,1:NR,NZ) = eft.BZ(k,1:NR,NZ-1);
    eft.BZ(k,1,1:NZ)  = eft.BZ(k,2,1:NR);
    eft.BZ(k,NR,1:NZ) = eft.BZ(k,NR-1,1:NZ);

    eft.Bt(k,1)       = eft.Bt(k,2);
    eft.Bt(k,NR-1)    = eft.Bt(k,NR);

    temp.BR(:,:) = eft.BR(k,:,:);
    temp.BZ(:,:) = eft.BZ(k,:,:);
    temp.Bt(:,:) = eft.Bt(k,:).';
    
    coil.BR(k,1) = eft.time(k);
    coil.BZ(k,1) = eft.time(k);
    coil.Bt(k,1) = eft.time(k);

    coil.BR(k,2) = griddata(eft.R, eft.Z, temp.BR, coil.R, coil.Z);
    coil.BZ(k,2) = griddata(eft.R, eft.Z, temp.BZ, coil.R, coil.Z);
    coil.Bt(k,2) = interp1(eft.R(:,1),   temp.Bt, coil.R);

end;

return;
