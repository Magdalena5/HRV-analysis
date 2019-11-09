function [LFnu,HFnu,LFHFfft] = frequencydomain (signal_NN);
% signal_NN-RR spacing vector

[b,a] = butter(3,.02);
y = filtfilt(b,a,signal_NN);

signal_NN(:)=signal_NN(:)-y(:);
f=5;
N=length(signal_NN);
signal_NN =signal_NN -mean(signal_NN);
%% PSD (Power-spectral-density) calculated using Fourier transform

[pxx_fft,Ffft] = pwelch(y,300,150,[],1);
pxx_fft(1) = 0;
%% PSD calculated using Autoregression

% [pxx_ar, Far] = pburg(y,16,[],1);
% %pxx_ar(1) = 0;
% [pxx,f] = plomb(y);

%% The number of total spectral power in the LF, HF bands and the calculation of LF / HF for all methods

VLFfft = sum(pxx_fft(Ffft<=.04));
LFfft = sum(pxx_fft(Ffft<=.15))-VLFfft;  
HFfft = sum(pxx_fft(Ffft<=.4))-VLFfft-LFfft;
LFHFfft = LFfft/HFfft ;

HFnu = HFfft/(LFfft + HFfft)*100;
LFnu = LFfft/(LFfft + HFfft)*100;



%% Plot

figure(2)
plot(Ffft,pxx_fft);
title('FFT spectrum (Welch perdiogram)');xlabel('Frequency[Hz]');ylabel('PSD [ms^2/Hz]')
end
