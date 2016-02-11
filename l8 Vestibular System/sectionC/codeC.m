clear all;

%% Question 1
load Afferent_model_1.mat;
load Afferent_model_2.mat;

spikes = find(Afferent_model_1(:,1)); %Find indexes for non-zero values at rest
isi1 = diff(spikes); % Calculate inter-spike times (ISI)

spikes = find(Afferent_model_2(:,1)); %Find indexes for non-zero values at rest
isi2 = diff(spikes); % Calculate ISI

%Calculate CV by dividing SD/Mean
CV1=(std(isi1)/mean(isi1));  %0.2465  Irregular
CV2=(std(isi2)/mean(isi2));  %0.0508  Regular

% Plot ISI Histograms
figure; hist(isi1); title('ISI Distribution, Model 1'); xlabel('ISI'); ylabel('Occurences');
figure; hist(isi2); title('ISI Distribution, Model 2'); xlabel('ISI'); ylabel('Occurences');

%% Question 2
load E.mat;

% Estimate multitaper cohere parameters
[~,prs1, pss1, prr1, f1]=multitaper_cohere(Afferent_model_1(:,2), Afferent_model_1(:,3), 2048,1000,E,1024,'none',8);
[~,prs2, pss2, prr2, f2]=multitaper_cohere(Afferent_model_2(:,2), Afferent_model_2(:,3), 2048,1000,E,1024,'none',8);

gain1=abs(prs1./pss1); % Response Gain as Absolute Value of prs/pss
gain1=gain1./gain1(3); % Normalize the gain by the one at 1Hz
gain2=abs(prs2./pss2); % Response Gain as Absolute Value of prs/pss
gain2=gain2./gain2(3); % Normalize the gain by the one at 1Hz

%Plot the gains
figure;
subplot(2,1,1);
loglog(f1,gain1);
axis([0 20 0 9]);
ylabel('Amplitude');title('Normalized Gain for Model 1');
subplot(2,1,2);
loglog(f2,gain2);
axis([0 20 .8 1.5]);
ylabel('Amplitude');title('Normalized Gain for Model 2');
xlabel('Frequency (deg/sec)');

%% Question 3

%Calculate the coherence for frequencies up to 20 Hz.  
for f=1:42 % Index 42 is where frequency is at about 20Hz
    C1(f)=abs(prs1(f)^2)/(pss1(f)*prr1(f));
    C2(f)=abs(prs2(f)^2)/(pss2(f)*prr2(f));
end

% Calculate the normalized mutual density
MI1 = -log2(1-C1)/mean(Afferent_model_1(:,3));
MI2 = -log2(1-C2)/mean(Afferent_model_2(:,3));

%Plot the mutual densities
figure;
subplot(2,1,1);
loglog(f1(1:42),MI1);
axis([0 20 0 30]);
ylabel('Amplitude');title('Normalized Mutual Density for Model 1');
subplot(2,1,2);
loglog(f2(1:42),MI2);
axis([0 20 20 50]);
ylabel('Amplitude');title('Normalized Mutual Density for Model 2');
xlabel('Frequency (deg/s)');