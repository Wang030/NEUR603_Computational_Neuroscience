% Seqian Wang, 260377179
% Report 4: Supervised Learning

%% Single-layer classifier
% I modified demo_classifier_gradDesc.m as followed
% 1) No longer prompt for user input
% 2) Script into a Function, with a learning rate (eta) as input and the
% MSE error and history as output
% 3) Set the number of trials to 500

nTrials = 500;
nTrialsPerX = 1; % Per learning parameter
X = [0.01:0.01:0.2 0.3:0.1:1 1.5:0.1:2.5]; % eta, learning parameter
X = [X ; zeros(2,length(X))];
for i = 1:size(X,2)
    E_losses = zeros(1,nTrialsPerX);
    for j = 1:nTrialsPerX
        [E_loss, ~] = demo_classifier_gradDesc(X(1,i),nTrials);
        E_losses(j) = E_loss;
    end
    X(2,i) = mean(E_losses);
    X(3,i) = std(E_losses);
    close all;
end

%% Plot
figure; plot(X(1,:),X(2,:)) %,'b',X(1,:),X(3,:),'r');
title('Model Error as a function of the Learning Rate Parameter');
xlabel('Learning Rate (eta)');
ylabel('Mean Squared Error');
% legend('Mean','STdev');
grid on;

%% Plot 2
[~,function1] = demo_classifier_gradDesc(0.1,500);
[~,function2] = demo_classifier_gradDesc(1,500);
[~,function3] = demo_classifier_gradDesc(2,500);
plot(1:500,function1,1:500,function2,1:500,function3);
legend('0.1','1','2')
title('Error history as a function of the learning parameter used');
xlabel('batch trial');
ylabel('loss - square error');

%% Single-layer classifier with regularization
% I modified demo_classifier_gradDesc.m as followed
% 1) No longer prompt for user input
% 2) Script into a Function, with a learning rate (eta) and a
% regularization parameter as input and the MSE error and history as output
% 3) Set the number of trials to 200 to reduce the time
% 4) Set the learning rate parameter as 0.8, as it was the most optimal
% from the previous exercise
% 5) From line [108:111], I added a code that plots the weight values for
% each batch trials.

eta = 0.8;
nTrials = 200;
nTrialsPerX = 10;
X = [0.01:0.02:0.1 0.2:0.1:1]; % alpha, regularization parameter
X = [X ; zeros(3,length(X))];
for i = 1:size(X,2)
    E_losses = zeros(1,nTrialsPerX);
    for j = 1:nTrialsPerX
        [E_loss, ~] = demo_classifier_reg(eta,X(1,i),nTrials);
        E_losses(j) = E_loss;
    end
    X(2,i) = mean(E_losses);
    X(3,i) = std(E_losses);
    close all;
end

%% Plot
figure; plot(X(1,:),X(2,:),'b',X(1,:),X(3,:),'r');
title('Model Error as a function of the Regularization Hyperparameter');
xlabel('Regularization Parameter Value');
ylabel('Mean Squared Error');
legend('Mean','STdev');
grid on;

%% Plot 2
eta = 0.8;
[~,function1] = demo_classifier_reg(eta,0.001,200);
[~,function2] = demo_classifier_reg(eta,0.01,200);
[~,function3] = demo_classifier_reg(eta,1,200);
plot(1:200,function1,1:200,function2,1:200,function3);
legend('0.001','0.01','1');
title('Error history as a function of the hyperparameter used');
xlabel('batch trial');
ylabel('loss - square error');

%% Receptive field (RF) estimation using regression
% I modified demo_1d_RF_sysIdent.m as followed
% 1) No longer prompt for user % input
% 2) Script into a Function, with a learning rate (eta) and number of
% Trials as input and the MSE error and history as output
% 3) Set the number of trials to 50 to reduce the time
% 4) Line 39 and 40 are modified to test with or without random
% initial weights.
nTrialsPerX = 1;
for i = [0.01 0.04 0.05 0.06 0.1 0.5]
    vafs = zeros(1,nTrialsPerX);
    for j = 1:nTrialsPerX
        [vafs(j)] = demo_1d_RF_sysIdent(i,50);
    end
    X(end+1) = mean(vafs);
end

%% Plot
figure;
plot([0.01 0.04 0.05 0.06 0.1],X,[0.01 0.04 0.05 0.06 0.1],X2)
legend('Without Random Initial Weights','With Random Initial Weights');
title('Variance Accounted For as a Function of the Learning Rate');
xlabel('Learning Rate Parameter');
ylabel('Variance Accounted For (%)');
    
%% Estimation of receptive fields using regression with regularization
nTrialsPerX = 1;
X = []; Y = [];
for i = [0:0.02:0.1 0.3 0.5] % i = different alpha values
    vafs = zeros(1,nTrialsPerX);
    for j = 1:nTrialsPerX
        [vafs(j)] = demo_1d_RF_sysIdent_ridge(i,0.05,50);
    end
    X(end+1) = mean(vafs); % Mean of VAF for a given alpha value
    Y(end+1) = std(vafs); % Standard Deviation of VAF for a given alpha value
end

%% Plot
figure;
plot([0:0.02:0.1 0.3 0.5],X);
title('Variance Accounted For as a Function of the regularization hyperparameter');
xlabel('Regularization hyperparameter');
ylabel('Variance Accounted For (%)');