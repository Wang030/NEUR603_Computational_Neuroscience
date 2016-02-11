% Seqian Wang, Report 10 Spike Train
% In Collaboration with Sulantha Mathotaarachchi and Maxime Parent
load spiketrain1.mat;
debug = 0;

%% Part I: Spike Train Statistics
%% A) Spike Train Binary Representation

%1 Vm Sampling Frequency
samplingFrequency =  1 / (timeaxis(2) - timeaxis(1)); % The sampling frequency is 1 over the time difference between two sampling

%2 Find times that cross threshold
thresh = -20; % Threshold
spiketimes = [];
tempIndicesList = find(Vm>thresh); % Find all indices where Vm > threshold
for j = tempIndicesList % For the indices
    if Vm(j-1)<thresh % If the indice-1 Vm < threshold
        spiketimes(end+1) = j;
    end
end
samplingTimeStep = 1 / samplingFrequency; % Sampling timestep, which is the inverse of sampling frequency
spiketimes = spiketimes * samplingTimeStep; % To convert indices into time

%3 Spike Train Binary Representation
% See function spiketrainBinary.m
myBin1ms = spiketrainBinary(spiketimes,timeaxis,0.001);
myBinDot5ms = spiketrainBinary(spiketimes,timeaxis,0.0005);
myBinDot1ms = spiketrainBinary(spiketimes,timeaxis,0.0001);

%% B) Interspike Interval Statistics
%1 Calculate the isi
isi = diff(spiketimes); % Find out interspike interval differences
binWidth = 0.001:0.001:0.2;

%2 Make the histogram
spikeHistogram = histc(isi,binWidth); % Computer ISI Histogram
figure; bar(binWidth,spikeHistogram);
xlabel('ISI (sec)');
ylabel('Frequency');
title('Interspike Interval Histogram');

%3 Calculate the CV
CV = std(isi) / mean(isi);

%4 Interspike Interval Correlation Coefficients
for j=0:length(isi)
    k=0;
    ImJ=length(isi)-j;
    for i=1:(ImJ)
        k=k+isi(i)*isi(i+j)/ImJ;
    end
    IiIj(j+1)=k;
end

isiMean = mean(isi);
isiMeanSquared = mean(isi.^2); %I^2
for j=1:length(isi)
    Pj(j)=(IiIj(j)-isiMean^2)/(isiMeanSquared-isiMean^2);
end

figure; plot(Pj(1:200));
title('Interspike Interval Correlation');
xlabel('j');
ylabel('Pj');

%% C) Autocorrelation function and Power spectrum
%1&2 Binary Representation Autocorrelation and Power Spectra
for dt = [0.001 0.0005 0.0001]
    binarySpikeTimes = spiketrainBinary(spiketimes,timeaxis,dt); % From Part I, Question A3
    b = 0.050 / dt; % Target period is 50ms
    [c,lags]=xcorr(binarySpikeTimes,b,'coeff');
    figure; plot(lags,c);
    xlabel('Lag (s)');
    ylabel('Autocorrelation');
    title(['Autocorrelation of Binary Representation of Spike Train with ' num2str(dt) 's sampling']);
    axis([0, 50, -0.02, 100 * dt]);
    
    [pxx,f] = pwelch(binarySpikeTimes,bartlett(2048),1024,2048,1/dt);
    figure; plot(f,pxx./2);
    xlabel('Frequency (Hz)');
    ylabel('Density');
    title(['Power Spectrum with ' num2str(dt) 's sampling']);
    axis([0, 200, 0, dt * 0.05]);
end

%% Part II: Neural Encoding Measures
clear; load spiketrain2.mat;
%% A) Raster plots and PSTH
%1 Plot data in Raster format
figure; plot(data(:,2),data(:,1),'.')
xlabel('Time (ms)');
ylabel('Trial Number');
title('Raster Plot');
axis([-5 100 -5 105]);

%2 PSTH, binwidth = 1ms
binWidth = 1;
epochsNumber = length(unique(data(:,1))); % Number of trials
psth = histc(data(:,2),1:50000);
psth = psth / epochsNumber / binWidth;
figure; bar(psth);
xlabel('Time (in ms)');
ylabel('Firing probability (in %)');
title('PSTH at 1ms timestep');
axis([0 50000 0 0.5]);

%% B) Cross-correlation function and transfer function
%1 Cross-correlation
dt = 1/2000; % 1/2KHz to have the time step
numBins=2000*50; % 2kHz * 50 seconds
myBin=zeros(100,numBins);
tempBin=round(data(:,2)/.5);
myBin(tempBin)=1; % Binarizing the information

figure; hold on;
xlabel('Lag (ms)');
ylabel('Cross-correlation');
title('Cross-correlation between Stimulus and Trials');

% Between Stimulus and Trial 1
[cor,lag]=xcorr(myBin(1,:),stim,200,'unbiased');
plot(lag,cor,'.b');

% Between Stimulus and Trial 20
[cor,lag]=xcorr(myBin(20,:),stim,200,'unbiased');
plot(lag,cor,'.g');

% Between Stimulus and Trial Averages
[cor,lag]=xcorr(mean(myBin,1),stim,200,'unbiased');
plot(lag,cor,'.r');

legend('Trial 1','Trial 20','Average Trial');
hold off;

%2 Cross-spectrum between Stimulus and Trial 1
[pxy,f]=cpsd(myBin(1,:),stim,bartlett(2048),1024,2048,2000);
figure; plot(f,pxy);
xlabel('Frequency (Hz)');
ylabel('Spectral magnitude');
title('Cross-Spectrum Between Stimulus and Trial 1');
axis([0 30 -.3e-7 .05e-6]);

%% C) Signal-to-Noise Ratio
%1 Power Spectrum

%Mean
[pxx,fp]=pwelch(mean(myBin,1),bartlett(2048),1024,2048,2000);
figure; plot(fp,pxx);
xlabel('Frequency (Hz)');
ylabel('Spectral magnitude');
title('Mean Trial Power Spectrum');
axis([-1 75 0 .000015]);

%Trials - Mean (Noise)
myDiffBin=myBin;
for i=1:100
    myDiffBin(i,:) = myBin(i,:) - mean(myBin,1);
end
meanDiff=mean(myDiffBin,1);

[pxxDiff,fpDiff]=pwelch(meanDiff,bartlett(2048),1024,2048,2000);
pxxDiff=pxxDiff/2;
fpDiff=fpDiff/2;

figure; plot(fpDiff,pxxDiff); % Mean vs Noise
xlabel('Frequency (Hz)');
ylabel('Spectral Magnitude');
title('Noise Power Spectrum');
axis([-1 75 0 4e-38]);

%Signal-to-Noise Ratio
snr=pxx/pxxDiff;
figure; plot(fpDiff,snr);
xlabel('Frequency (Hz)');
ylabel('Spectral Magnitude');
title('Signal to Noise Ratio');
axis([-1 75 0 3e29]);