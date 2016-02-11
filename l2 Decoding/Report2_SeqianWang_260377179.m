% Report 2 Neural Decoding
% Seqian Wang, 260377179

% 1) Load the data
load decodingLabData;

% 2) Check the data
%labHandOutFigure;

%% ROC Neurometric Analysis
%% 3a) Histograms
before1 = neuron1(:,400:499);
after1 = neuron1(:,540:639);
before2 = neuron2(:,400:499);
after2 = neuron2(:,540:639);

A = figure(1);
bar1 = hist(sum(before1,2),0:6);
bar2 = hist(sum(after1,2),0:6);
bar(0:6,[bar1;bar2]');
title('Neuron 1');
xlabel('Action Potentials per 100 ms');
ylabel('Number of Trials');
legend('Before Motion Stimulus','After Motion Stimulus');
saveas(A,'Figure 1.jpg');

B = figure(2);
bar1 = hist(sum(before2,2),0:6);
bar2 = hist(sum(after2,2),0:6);
bar(0:6,[bar1;bar2]');
title('Neuron 2');
xlabel('Action Potentials per 100 ms');
ylabel('Number of Trials');
legend('Before Motion Stimulus','After Motion Stimulus');
saveas(B,'Figure 2.jpg');

%% 3b) Neurometric ROC
rocN1neurometric = roc(sum(before1,2),sum(after1,2)); % Neuron 1, no difference between 1 or 2
rocN2neurometric = roc(sum(before2,2),sum(after2,2)); % Neuron 2, stimulus has an effect on neural response, neuron related to stimulus.

%% 4) Detect Probability Analysis
%% 4a) Histograms
after1 = neuron1(:,540:639);
after2 = neuron2(:,540:639);
failedTrials = find(isnan(responseTime));
correctTrials = find(isnan(responseTime)==0);
n1Failed = sum(after1(failedTrials,:),2);
n1Correct = sum(after1(correctTrials,:),2);
n2Failed = sum(after2(failedTrials,:),2);
n2Correct = sum(after2(correctTrials,:),2);

C = figure(3);
bar1 = hist(n1Failed,0:6);
bar2 = hist(n1Correct,0:6);
bar(0:6,[bar1;bar2]');
title('Neuron 1');
xlabel('Action Potentials per 100 ms');
ylabel('Number of Trials');
legend('Failed Trials','Correct Trials');
saveas(C,'Figure 3.jpg');

D = figure(4);
bar1 = hist(sum(n2Failed,2),0:6);
bar2 = hist(sum(n2Correct,2),0:6);
bar(0:6,[bar1;bar2]');
title('Neuron 2');
xlabel('Action Potentials per 100 ms');
ylabel('Number of Trials');
legend('Failed Trials','Correct Trials');
saveas(D,'Figure 4.jpg');

%% 4b) Detect Probability ROC
rocN1dp = roc(n1Failed,n1Correct);
rocN2dp = roc(n2Failed,n2Correct);