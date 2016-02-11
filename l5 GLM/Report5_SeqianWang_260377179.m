%% Exercise 1: Familiarize yourself with GLMs
%% a) Linear Model
load exercise1-1.mat;
[wLr,~,r] = regress(y,X);
expected = X*wLr;
figure; scatter3(X(:,1),X(:,2),expected); hold on;
scatter3(X(:,1),X(:,2),expected+r,'r');
scatter3(X(:,1),X(:,2),y,'g'); hold off;
title('Observed Values vs Expected Values for Normal Distribution');
legend('Expected Values','Observed Values');
wGlm = glmfit(X,y,'normal','constant','off');

%% b) Binomial Model
clear;
load exercise1-2.mat;
wLr = regress(y,X);
wGlm = glmfit(X,y,'binomial','constant','off');
expected = 1./(1+exp(-X*wGlm));
scatter3(X(:,1),X(:,2),X*wLr,'b'); hold on;
scatter3(X(:,1),X(:,2),expected,'r');
scatter3(X(:,1),X(:,2),y,'g');
hold off;
title('Expected Values vs Observed Values for Binomial Distribution');
legend('Expected Values from Linear Regression','Expected Values from GLM','Observed Values','location','NorthEast');

%% c) Model Deviance
[~,wDeviance, stats] = glmfit(X,y,'binomial','constant','off');
[~,wDevianceOffset, statsOffset] = glmfit(X(:,3),y,'binomial','constant','off');

display(wDeviance);
display(wDevianceOffset);
display(stats.p);
display(statsOffset.p);

%% Exercise 2: GLM Rat Data
%% a) Histogram
clear;
load exercise2.mat;
hist([x(y == 2) ; x(y == 2) ; x(y == 1)]);
title('Action Potentials based on Rat Position');
xlabel('Rat Position');
ylabel('Spike Counts');

%% b) GLM spatial model
X = [x ones(2000,1)];
wGlm = glmfit(X,y,'poisson','constant','off');
plot(X(:,1),exp(X*wGlm));
title('Spike Counts vs Rat Position');
xlabel('Rat Position');
ylabel('Spike Counts');

%% GLM for post-spike filter effect
clear; load exercise2.mat;

%{
times = 15;
spikes = find(y>0); % Gives indexes where there is a spike
X = zeros(length(x),times);
for i = 1:times % Do that 15 times, from 0 to 14
    X(spikes+i,1+i) = 1;
end
%}

times = 15;
X = zeros(2000,times+1);
for j = 1:1999
    for k = 1:times+1
        X(k+j+1, k) = y(j)>0;
    end
end

X = [X ones(length(X),1)]; % Add an offset column
wGlm = glmfit(X(1:2000,:),y,'poisson','constant','off');
plot(wGlm(1:15));
title('Post-Spike Filter');
ylabel('Weights');

%% GLM for post-spike filter effect and spatial effect
X = [x X(1:2000,:)]; % Add a spatial effect column
wGlm = glmfit(X,y,'poisson','constant','off');
plot(wGlm(1:16));
title('Filter with Post-Spike and Spatial Effects');
ylabel('Weights');

%% GLM Model Deviance as a function of the number of time lags
clear; load exercise2.mat;
%{
results = zeros(15,31);
for times = 1:15
    spikes = find(y>=1); % Gives indexes where there is a spike
    superGlm = zeros(length(x),15);
    for i = 0:times-1 % Do that 15 times
        superGlm(spikes+i,i+1) = 1;
    end
    [w,dev,stats] = glmfit(superGlm(1:2000,:),y,'poisson','constant','off');
    results(i)= [dev stats.p' w'];
end
%}
deviances = [];
for times = 1:15
    X = zeros(2000,times+1);
    for j = 1:1999
        for k = 1:times+1
            X(k+j+1, k) = y(j)>0;
        end
    end
    X = [X ones(length(X),1)]; % Add an offset column
    [~,deviance] = glmfit(X(1:2000,:),y,'poisson','constant','off');
    deviances(end+1) = deviance;
end
plot(1:15,deviances);
title('Deviance vs Number of time lags');
xlabel('Number of time lags considered');
ylabel('Deviance');