%* ---------- ---------- ----------
%* plot_rotflex_sweep
%* Description: Generate and plot the power spectrum of the ROFLEX from the sweep data 
%               given in the plot rotflex sweep.m file
%* Copyright:   2010 Quanser Consulting Inc
%* History:     03/31/2025 - upload to github
%* ---------- ---------- ----------
%% Load data (if needed)
%load('data_rotflex_sweep_alpha.mat');

%% Plot

t = data_alpha(:,1); %* time
x = data_alpha(:,2); %* measured flexible link angle

%* plot link response
figure(1)
plot(t,x,'r-','linewidth',2);
xlabel('time (s)');
ylabel('\alpha (deg)');

%% Power Spectrum (FFT)
dt   = 0.002;         %* sampling interval (s)
N    = length(x);     %* length of signal (samples)
NFFT = 2^nextpow2(N); %* Next power of 2 from length
y    = fft(x,NFFT);   %* Fourier Transform of x

%* Power Spectral Density (PSD) (V^2/Hz)
Sx = abs(y)/N;

%* Single-sided power spectrum of signal x: Px
Px = 2*Sx(1:NFFT/2);

%% Plot
%* sampling frequency (Hz)
fs = 1 / dt;

%* frequency division (Hz)
f = fs/2*linspace(0, 1, NFFT/2);

%* Plot from 1 to 5 Hz (or input of sweep signal)
figure(2)
plot(f,Px,'r-','linewidth',2);
axis([0 10 0 1.2*max(Px)]);
xlabel('f (Hz)');
ylabel('P_x');

%% Natural Frequency
[Px_max, i_n] = max(Px); %* Index of maximum amplitude
fn = f(i_n);  %* Natural frequency (Hz)
wn = 2*pi*fn; %* Natural frequency (rad/s)
Ks = Jl*wn^2  %* Stiffness (N.m/rad)