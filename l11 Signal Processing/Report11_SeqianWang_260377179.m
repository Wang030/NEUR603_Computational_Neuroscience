% NEUR 603 Report 11: Signal Processing
% Seqian Wang, In Collaboration with Sulantha Mathotaarachchi and Maxime Parent
cd 'C:\Users\wang0_000\SkyDrive\Documents\Business\NEUR 603 Computational Neuroscience\l11 Signal Processing';
clear;
%% Part 1: Amplitude and Power Spectrum
%% Adding Components Together
component1 = randn(1,1000*10); % 10s, 1000Hz, thus 10*1000 data points
component2 = 3 * sind(2*pi*60*[1:10000]);
component3 = 5 * sind(2*pi*25*[2001:6000]+pi/2);
component4 = 4 * sind(2*pi*100*[5001:8000]+pi) .* sind(2*pi*250*[5001:8000]+pi/3);
components = component1 + component2;
components(2001:6000) = components(2001:6000) + component3;
components(5001:8000) = components(5001:8000) + component4;

figure;
subplot(5,1,1); plot(linspace(0,10,length(component1)),component1); title('Component 1');
subplot(5,1,2); plot(linspace(0,10,length(component2)),component2); title('Component 2');
subplot(5,1,3); plot(linspace(2,6,length(component3)),component3); title('Component 3');
subplot(5,1,4); plot(linspace(5,8,length(component4)),component4); title('Component 4');
subplot(5,1,5); plot(linspace(0,10,length(component1)),components); title('Resulting Signal');
xlabel('Time (s)');

%% Discrete Fourier Transform
% Single sided normalized amplitude spectrum.
signal1000 = components;
dft1000 = fft(signal1000,1024)/1000;
xAxis = linspace(0,1,1024); % Normalizing it by number of frequency sampling
figure; plot(xAxis,abs(dft1000)); xlim([0 0.5]); % Only taking half of DFT
title('Discrete Fourier Transform');
ylabel('Amplitude');
xlabel('Frequency/SamplingFrequency');

% Power spectrum
% The power spectrum is the amplitude spectrum multiplied by its complex conjugate.
powerSpectrum = dft1000 .* conj(dft1000);
xAxis = linspace(0,1,1024); % Normalizing it by number of frequency sampling
figure; plot(xAxis,powerSpectrum); xlim([0 0.5]);
title('Power Spectrum');
ylabel('Amplitude');
xlabel('Normalized Frequency');

% Signal Desampling
signal500 = downsample(signal1000,2); % For 500Hz, 1000Hz/500Hz = 2
signal100 = downsample(signal1000,10); % For 100Hz, 1000Hz/100Hz = 10

figure;
subplot(3,1,1); plot(linspace(0,10,10000),signal1000); title('1000Hz');
subplot(3,1,2); plot(linspace(0,10,5000),signal500); title('500Hz');
subplot(3,1,3); plot(linspace(0,10,1000),signal100); title('100Hz');
xlabel('Time (s)');

dft500 = fft(signal500,1024)/500;
dft100 = fft(signal100,1024)/100;
figure;
xAxis = linspace(0,1,1024);
subplot(3,1,1); plot(xAxis,abs(dft1000)); title('1000Hz'); xlim([0 0.5]);
subplot(3,1,2); plot(xAxis,abs(dft500)); title('500Hz'); xlim([0 0.5]);
subplot(3,1,3); plot(xAxis,abs(dft100)); title('100Hz'); xlim([0 0.5]);
xlabel('Normalized Frequency');

%% Part 2: Wavelets
%% Wavelet Coefficients of the Signal
coeffs = morlet_wavelet(components,1000,linspace(2,500,100));
figure; imagesc(abs(coeffs)');
title('Wavelet Coefficients of Resulting Signal');
xlabel('Time (ms)');
ylabel('Frequency (Hz)');

%% Wavelet Coefficients of a LFP
load signals.mat;
samplingFrequency = 500; % Hz
coeffs = morlet_wavelet(lfp1(1:5*samplingFrequency),samplingFrequency,logspace(log10(2),log10(500),100)); %Sampled at 500Hz, thus the first 5 seconds only include the first 500*5 values
figure; imagesc(abs(coeffs));
title('Wavelet Coefficients of LFP1');
xlabel('Time');
ylabel('Frequency (Hz)');

%% LFP Wavelet Coefficients Power Normalization
coeffs = morlet_wavelet(lfp1(1:5*samplingFrequency),samplingFrequency,logspace(log10(2),log10(500),100)); %Sampled at 500Hz, thus the first 5 seconds only include the first 500*5 values
coeffs = 10*log10(abs(coeffs)/mean(abs(coeffs(:))));
figure; imagesc(coeffs);
title('Wavelet Coefficients of LFP1');
xlabel('Time');
ylabel('Frequency (Hz)');

%% Saccade-Triggered Wavelet Average
samplingFrequency = 500/1000; % Per ms
waveletCoeffs = zeros(length(sacc_end),100,500*samplingFrequency+1); % 100 saccades, 100 frequencies, (200+300ms)*500Hz+1
for j = 1:length(sacc_end) % For each saccade end times (in s)
    i = sacc_end(j);
    indice = round(samplingFrequency * i * 1000); % Get the indice for desired saccade
    saccadeBefore = indice - round(200*samplingFrequency); % Get the indice for the saccade 200ms before
    saccadeAfter = indice + round(300*samplingFrequency); % Get the indice for the saccade 300ms after
    lfp1Segment = lfp1(saccadeBefore:saccadeAfter,1); % Get the segment
    coeffs = morlet_wavelet(lfp1Segment,500,logspace(log10(2),log10(150),100));
    waveletCoeffs(j,:,:) = abs(coeffs);
end
% Average across saccades
averageWaveletCoeffs = squeeze(mean(waveletCoeffs,1));
figure; imagesc(averageWaveletCoeffs);
title('Saccade-Trigged Wavelet Average for LFP1');
xlabel('Time');
ylabel('Frequency (Hz)');

%% Saccade-Triggered Wavelet Average Power Normalization
averageWaveletCoeffs = squeeze(mean(waveletCoeffs,1));
correctedWaveletCoeffs = 10*log10(abs(averageWaveletCoeffs)/mean(abs(averageWaveletCoeffs(:))));
figure; imagesc(correctedWaveletCoeffs);
title('Saccade-Trigged Wavelet Average for LFP1');
xlabel('Time');
ylabel('Frequency (Hz)');

%% Part 3: Synchronicity
%% Cross-Correlation
xlfp12 = xcorr(lfp1,lfp2,'coeff');
xlfp13 = xcorr(lfp1,lfp3,'coeff');
xlfp23 = xcorr(lfp2,lfp3,'coeff');

xRange = [length(lfp1)-500 length(lfp1)+500]; % 500Hz, 500 measurements per second
figure;
subplot(3,1,1); plot(xlfp12); title('Cross-Correlation 1 and 2'); xlim(xRange);
subplot(3,1,2); plot(xlfp13); title('Cross-Correlation 1 and 3'); xlim(xRange);
subplot(3,1,3); plot(xlfp23); title('Cross-Correlation 2 and 3'); xlim(xRange);

%% Coherence
figure;
subplot(3,1,1); mscohere(lfp1,lfp2); title('Coherence estimate between 1 and 2');
subplot(3,1,2); mscohere(lfp1,lfp3); title('Coherence estimate between 1 and 3');
subplot(3,1,3); mscohere(lfp2,lfp3); title('Coherence estimate between 2 and 3');

%% Beta Filtered Signals Coherence
t1 = morlet_wavelet(betalfp1,500,30); %Frequency at 30Hz
t2 = morlet_wavelet(betalfp2,500,30);
t3 = morlet_wavelet(betalfp3,500,30);

t12 = mscohere(t1,t2);
t13 = mscohere(t1,t3);
t23 = mscohere(t2,t3);

bC12 = abs(mean(exp(sqrt(-1)*t12)));
bC13 = abs(mean(exp(sqrt(-1)*t13)));
bC23 = abs(mean(exp(sqrt(-1)*t23)));

%% Granger Causality
[F,c_v] = granger_cause(lfp1,lfp2,0.05,10); display(F>c_v); % If the F-value is higher than the critical value, then we can reject the null hypothesis (There is causality)
[F,c_v] = granger_cause(lfp1,lfp3,0.05,10); display(F>c_v);
[F,c_v] = granger_cause(lfp2,lfp3,0.05,10); display(F>c_v);
[F,c_v] = granger_cause(lfp2,lfp1,0.05,10); display(F>c_v);
[F,c_v] = granger_cause(lfp3,lfp1,0.05,10); display(F>c_v);
[F,c_v] = granger_cause(lfp3,lfp2,0.05,10); display(F>c_v);