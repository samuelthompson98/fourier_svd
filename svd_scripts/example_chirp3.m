

% function example_chirp
% make sample chirp
% average together shifted Fourier amplitudes, to produce single stronger Fourier amplitude for mode detection


clear all

global deltaf

deltaf = 50e+3/1.0e-3;

dt   = 1e-6;
f0(1)= 1e+5;
f0(2)= 1.3e+5
f0(3)= 0.7e+5
a(1) = 1;
a(2) = 0.8;
a(3) = 0.8;

phdiff(1)= 1.0;
phdiff(2)= 0.0;
phdiff(3)= 0.0;

noise(1) = 0.5;
noise(2) = 0.5;
noise(3) = 0.5;

Nt   = 10e+3;
Nt   = 2000
tmin = 0;
tmax = Nt * dt;

for i=1:Nt
    t(i)   = tmin + (i-1)*dt;
    x(i,1) = t(i);
    x(i,2) = real(a(1) * exp(1i*2*pi*fchirp(f0(1), t(i)-tmin)*t(i)) * 2*(0.5-noise(1)*rand) + ...
                  a(2) * exp(1i*2*pi*fchirp(f0(2), t(i)-tmin)*t(i)) * 2*(0.5-noise(2)*rand) + ...
                  a(3) * exp(1i*2*pi*fchirp(f0(3), t(i)-tmin)*t(i)) * 2*(0.5-noise(3)*rand));
    y(i,1) = t(i);
    y(i,2) = real(a(1) * exp(1i*2*pi*fchirp(f0(1), t(i)-tmin)*t(i) + 1i * phdiff(1)) * 2*(0.5-noise(1)*rand) + ...
                  a(2) * exp(1i*2*pi*fchirp(f0(2), t(i)-tmin)*t(i) + 1i * phdiff(2)) * 2*(0.5-noise(2)*rand) + ...
                  a(3) * exp(1i*2*pi*fchirp(f0(3), t(i)-tmin)*t(i) + 1i * phdiff(3)) * 2*(0.5-noise(3)*rand));
end;

fchirp(f0(1), t(1))
fchirp(f0(1), t(Nt))

tnorm = 1e-3
fnorm = 1e+3
%  figure(1);
%  plot(x(:,1), x(:,2));

%fftspec = 0
%
%if fftspec

disp(['Calling getspec...']);
[Xs.F, Xs.f, Xs.t, Xs.dt, Xs.df] = getspec(x,1, 256); 
[Ys.F, Ys.f, Ys.t, Ys.dt, Ys.df] = getspec(y,1, 256); 
render_example(Xs,tnorm, fnorm)

% map frequency ramping Fourier transform to single initial FT bin
NFT = size(Xs.t,1);
NFF = size(Xs.f,2);
Xsh = Xs;
for i=1:NFT
    if0(1)     = min(find(Xs.f>=fchirp(f0(1), Xs.t(i)-tmin)));
    if deltaf>0
        for j=1:NFT-if0(1)      Xsh.F(j,i) =  Xs.F(j+if0(1),i);        end
        for j=NFT+if0(1)+1:NFT  Xsh.F(j,i) = NaN;                      end        
    elseif deltaf<0
        for j=1:if0(1)-1        Xsh.F(j,i) =  NaN;                     end
        for j=if0(1):NFT        Xsh.F(j,i) =  Xs.F(j-if0(1),i);        end
    end
end

render_example(Xsh,tnorm, fnorm)

return
