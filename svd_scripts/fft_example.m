
function fft_example

clear global signal
global signal

fs= 1e+3;
dt= 1/fs;
tmax = 1;
t = 0:dt:tmax;

a1      = 1;
PHI1    = 185/180 * pi;
f1      = 100;


x = real(a1 * exp(1i*(2*pi*f1*t + PHI1))); 
x = a1 * cos(2*pi*f1*t + PHI1); 

% choose frequency window length to EXACTLY correspond bin driving frequency
Nwin = length(t);
win  = boxcar(Nwin-1); % Hamming and Hann windows cause phase lag/advance
win  = boxcar(Nwin-32); 
win  = hann(Nwin-32); 
Nwin = length(win);

for i=1:Nwin
    xwin(i) = x(i)* win(i);
end

X = fft(xwin,Nwin);
f = fs * (0:fix(Nwin/2))/Nwin
Nf= length(f)

[Xmax, imax] = max(abs(X));
df      = f1 - f(imax);
delta_f = f(imax) - f(imax-1);
ph_adv  = df * tmax/2 * 2 * pi;         % average phase advance of f1 wrt f(imax) over window
ph_delta= delta_f * tmax/2 * 2 * pi;    % maximum average phase advance of f1 wrt f(imax) over window

figure; hold on;
subplot(3,1,1);
plot(t, real(x));

subplot(3,1,2);
plot(f, abs(X(1:Nf))); hold on;

% ==============================================================
% global signal
ffit = 0;

if ffit 

    Y.f = f;
    Y.X = X;
    sigma   = 10e+0;
    [a,i_pk]= max(abs(Y.X))
    df      = Y.f(2) - Y.f(1);
    i_min   = min(find(Y.f > Y.f(i_pk) - 2*sigma));
    i_max   = max(find(Y.f < Y.f(i_pk) + 2*sigma));
    Nwfit   = i_max-i_min+1;

    xfit(1) = Y.f(i_pk);
    xfit(2) = sigma/4;
    xfit(3) = abs(Y.X(i_pk));

    for i=1:Nwfit
        signal.f(i)    = Y.f(i+i_min);
        signal.Xmag(i) = abs(Y.X(i+i_min));
    end;

    gaussfit_res(xfit)

    OPTIONS = OPTIMSET('MaxIter', 100, 'MaxFunEvals', 1e+5, 'TolFun', 1e-6,'Display', 'iter');  
    xfit = fminsearch(@gaussfit_res, xfit, OPTIONS)

    for i=1:Nwfit
        signal.Xmag_trial(i) = xfit(3)*exp(-(signal.f(i)-xfit(1))^2/(2* xfit(2)^2));
    end;
    plot(signal.f, signal.Xmag_trial,'k-'); hold on;
    text(x(1), 2*x(3),['mu = ',num2str(xfit(1)),', sigma = ',num2str(xfit(2))]);

end
% ==============================================================


subplot(3,1,3);
plot(f,(angle(X(1:Nf))-ph_adv)/pi*180); hold on
% errorbar(f,(angle(X(1:Nf))-ph_adv)/pi*180, ph_delta/pi*180 * ones(Nf,1)); hold on



return



% residue function =====================================================
function [res]=gaussfit_res(x)

global signal

Nw = size(signal.f, 2);
res= 0;
for i=1:Nw
    signal.Xmag_trial(i) = x(3)*exp(-(signal.f(i)-x(1))^2/(2* x(2)^2));
    res = res + abs(signal.Xmag_trial(i)- signal.Xmag(i))^2;
end;

return;
