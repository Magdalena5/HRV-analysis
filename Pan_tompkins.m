%% Magdalena Śmieszek
%Finding R waves based on PAN-TOMPKINS in an ECG signal
%All variables have the name BP in them refer to the BP signal  BP
%All variables have the name ECG in them refer to the ECG signal.

%1.load a file - 16265m.mat from Physionet MITBIH (time format:samples,
%https://physionet.org/about/database/) - Ładowanie danych z bazy Physionet 
dataEKG=load('16265m.mat');
dataBP=load('meas225.txt');

%2.Choosing a lead 1 and samples 1:1000 - ECG -signal
ECGsignal=dataEKG.val(1,7000:9000)';
BPsignal=dataBP(10000:15000,2);

%3.Check a sampling frequency (Fs) from an annotation file
FsECG=128;
FsBP=100;

%4.Change samples to seconds (based on Fs)
tECG=(0:length(ECGsignal)-1)./FsECG;
tBP=(0:length(BPsignal)-1)./FsBP;

%5.Plot a signal (x-time, y-ECG signal)
figure(1);
subplot(2,1,1)
plot(tECG,ECGsignal);xlabel('czas[s]');ylabel('amplituda[mV]');title('Sygnał EKG');
subplot(2,1,2)
plot(tBP,BPsignal);xlabel('czas[s]');ylabel('amplituda[mmHg]');title('Sygnał BP');


%6. calculate a Signal-to-noise ratio
rECG=snr(ECGsignal,FsECG);
rBP=snr(BPsignal,FsBP);

%% Filtering - Butterworth filter
f1=5;
f2=15;

%calculate a normalized cutoff frequency Wn (based on Fs-Nyquist theorem)
WnECG=[f1 f2]*2/FsECG; % - taking into account the Nyquist frequency fn = fs / 2
WnBP=[f1 f2]*2/FsBP;

% check an order of Butterwoth filter: ex. https://www.electronics-tutorials.ws/filter/filter_8.html
n= 3; %- decides how sharp the filter cut-off should be 1 - means that it is not very sharp and the larger the closer it gets to a rectangular one

%bandpass filtering
[a,b]=butter(n,WnECG);
[c,d]=butter(n,WnBP);

%zero-phase filtering - why? (filtfilt) - reduces noise in the signal, is better than the standard filter (filter)
%because it does not delay the signal
ECGsignal=(ECGsignal-mean(ECGsignal))/max(abs(ECGsignal-mean(ECGsignal))); %-Normalizacja sygnału
yECG = filtfilt(a,b,ECGsignal);
BPsignal=(BPsignal-mean(BPsignal))/max(abs(BPsignal-mean(BPsignal)));
yBP = filtfilt(c,d,BPsignal);

%plot a signal after filtering (x-t, y- ECG signal after filtering) - title: 'Band Pass Filtered'
figure(2);
subplot(2,1,1)
plot(tECG,yECG);xlabel('czas[s]');ylabel('amplituda[mV]');title('Band Pass Filtered-ECG');
subplot(2,1,2)
plot(tBP,yBP);xlabel('czas[s]');ylabel('amplituda[mmHg]');title('Band Pass Filtered-BP');

%% Derivative filter H(z) = (1/8T)(-z^(-2) - 2z^(-1) + 2z + z^(2))
h_dECG=[-2 -1 0 1 2]*(1/8)*FsECG;
h_dBP=[-2 -1 0 1 2]*(1/8)*FsBP;

%zero-phase filtering or convolution with h_d convolution- is a convolution of y and h_d vectors in this case 
%no difference was observed between the detection of peaks if we use convolution or zero-phase filtering
yECG = filtfilt(h_dECG,1,yECG);
yECG = yECG/max(abs(yECG)); %-normalizacja sygnału
yECGconv = conv(yECG,h_dECG);
yBP = filtfilt(h_dBP,1,yBP);
yBP = yBP/max(abs(yBP));
yBPconv = conv(yBP,h_dBP);

%plot-title:'Filtered with the derivative filter'
figure(3)
subplot(2,1,1)
plot(tECG,yECG);xlabel('czas[s]');ylabel('amplituda[mV]');title('Filtered with the derivative filter-ECG');
subplot(2,1,2)
plot(tBP,yBP);xlabel('czas[s]');ylabel('amplituda[mmHg]');title('Filtered with the derivative filter-BP');

%% Squaring nonlinearly enhance the dominant peaks
yECG=yECG.^2;
yECG=yECG/max(abs(yECG));
%yBP=yBP.^2; %- we detect bends better
%yBP=yBP/max(abs(yBP));

%plot-title:'Squared'
figure(4)
%subplot(2,1,1)
plot(tECG,yECG);xlabel('czas[s]');ylabel('amplituda[mV]');title('Squared');
%subplot(2,1,2)
%plot(yBP);ylabel('amplituda[mV]');


%% finding R waves, 550 ms was chosen as the minimum distance between RR
[pECG,lECG]=findpeaks(yECG,'MINPEAKDISTANCE',0.55*FsECG);
figure(6)
hold on;
plot(ECGsignal);xlabel('numer próbki');ylabel('amplituda[mV]');title('Sygnał ECG z detekcją pików R');
hold on,scatter(lECG,ECGsignal(lECG),'m');
hold off;

%% finding maxima in arterial pressure, 700ms was chosen as the minimum distance between maxima
[pBP,lBP]=findpeaks(yBP,'MINPEAKDISTANCE',0.55*FsBP);
figure(7)
hold on;
plot(BPsignal);xlabel('numer próbki');ylabel('amplituda[mmHg]');title('Sygnał ECG z detekcją pików R');
hold on,scatter(lBP,BPsignal(lBP),'m');
hold off;
