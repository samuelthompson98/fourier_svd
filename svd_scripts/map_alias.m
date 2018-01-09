function [h,p,f_alias] = map_alias(f, fs)
% MJH 21/01/2012
% compute aliased frequency according to 
% f_alias = h*f + p * fs
% See Appel et al, Plasma Phys. Control. Fusion 50 (2008) 115011 (23pp)

if mod(f, fs)>fs/2  
    h = -1; 
end;
if mod(f, fs)<=fs/2 
    h = +1; 
end;

p = -h * round(f/fs);

f_alias = h*f + p * fs;


end

