%% Decision lab
%
%  Instructions: Perform the following exercises by adding MATLAB code
%  after each comment block (Exercises 1 and 7 are examples). Write a short
%  report discussing your results, using figures you generate.
%  To make it easier to compare results, use a different figure for each of
%  the exercises, and give your variables different names so that you can
%  plot them together (see "help reciprobit").
%
%  decisionlab.m     Instructions
%  racemodel.m       Implementation of a "race" model (see "help racemodel")
%  reciprobit.m      Function for displaying reaction time distributions on
%                    a reciprobit plot.
%  invcumgaus.m      Inverse cumulative gaussian (used by reciprobit)
%

%% Exercise 1
% Run the race model 5000 times using evidence=3, threshold=300,
% trial-to-trial noise of 0.5, and no neural noise

% Run racemodel.m to generate data. Type "help racemodel" for instructions
% and explanation of the parameters
[lats3_300,choices,acts] = racemodel(ones(5000,1)*3,300,0.5,0);

% Plot the reaction time distribution
figure(1); clf; subplot(2,2,1); hist(lats3_300,50);
xlabel('Reaction time (ms)');
ylabel('Count');

% Plot the reaction times using a reciprobit plot
subplot(2,2,2); reciprobit(lats3_300);

% Plot the activities over all the trials
subplot(2,1,2); cla; hold on; for n=1:length(acts); plot(acts{n}); end
xlabel('Time (ms)');
ylabel('Neural Activity');

%% Exercise 2
%
% Now, run the model with evidence=2, and plot both RT distributions on
% the reciprobit plot. What is the relationship between the plots?
[lats2_300,choices,acts] = racemodel(ones(5000,1)*2,300,0.5,0);
figure(2); clf; subplot(2,2,1); hist(lats2_300,50);
xlabel('Reaction time (ms)');
ylabel('Count');
subplot(2,2,2); reciprobit(lats3_300,lats2_300);
subplot(2,1,2); cla; hold on; for n=1:length(acts); plot(acts{n}); end
xlabel('Time (ms)');
ylabel('Neural Activity');

%% Exercise 3
%
% Now, run the model with evidence=2 and threshold=200 and compare the RT
% distribution to that with evidence=2 and threshold=300.
% What is the relationship between the plots?
[lats2_200,choices,acts] = racemodel(ones(5000,1)*2,200,0.5,0);
figure(3); clf; subplot(2,2,1); hist(lats2_200,50);
xlabel('Reaction time (ms)');
ylabel('Count');
subplot(2,2,2); reciprobit(lats2_300,lats2_200);
subplot(2,1,2); cla; hold on; for n=1:length(acts); plot(acts{n}); end
xlabel('Time (ms)');
ylabel('Neural Activity');

%% Exercise 4
%
% Run the model with evidence=2, threshold=300, but trial-to-trial noise
% reduced to 0.2. Compare it to the case (above) with noise at 0.5.
[lats2_300_02,choices,acts] = racemodel(ones(5000,1)*2,300,0.2,0);
figure(4); clf; subplot(2,2,1); hist(lats2_300_02,50);
xlabel('Reaction time (ms)');
ylabel('Count');
subplot(2,2,2); reciprobit(lats2_300,lats2_300_02);
subplot(2,1,2); cla; hold on; for n=1:length(acts); plot(acts{n}); end
xlabel('Time (ms)');
ylabel('Neural Activity');

%% Exercise 5
%
% Compare the model from exercise 2 with one where neural noise
% is set to 1. What is different?
[lats2_300_05_1,choices,acts] = racemodel(ones(5000,1)*2,300,0.5,1);
figure(5); clf; subplot(2,2,1); hist(lats2_300_05_1,50);
xlabel('Reaction time (ms)');
ylabel('Count');
subplot(2,2,2); reciprobit(lats2_300,lats2_300_05_1);
subplot(2,1,2); cla; hold on; for n=1:length(acts); plot(acts{n}); end
xlabel('Time (ms)');
ylabel('Neural Activity');

%% Exercise 6
%
% Now try it with neural noise set to 10, and again compare to the
% results from exercise 2. What is different?
[lats2_300_05_10,choices,acts] = racemodel(ones(5000,1)*2,300,0.5,10);
figure(6); clf; subplot(2,2,1); hist(lats2_300_05_10,50);
xlabel('Reaction time (ms)');
ylabel('Count');
subplot(2,2,2); reciprobit(lats2_300,lats2_300_05_10);
subplot(2,1,2); cla; hold on; for n=1:length(acts); plot(acts{n}); end
xlabel('Time (ms)');
ylabel('Neural Activity');

%% Exercise 7
%
% Now run the model with two options, one with evidence=3 and the other
% with evidence=2. Set threshold to 200, trial-to-trial noise to 0.5 and
% neural noise to 1. Discuss the result. How often does the model make an
% error (i.e. chooses the option with less evidence)

[lats32_200,choices32_200] = racemodel(ones(5000,1)*[3,2],200,0.5,1);
% Report the percentage of correct choices
perccorrect = nnz(choices32_200==1)/length(choices32_200)
% Plot the distributions of RTs from correct and error trials
figure(7); clf; reciprobit(lats32_200(find(choices32_200==1)),lats32_200(find(choices32_200==2)));

%% Exercise 8
%
% Now run it with two options, one with evidence=3 and the other with
% evidence=2.8. Discuss the result in comparison with exercise 7.
[lats328_200,choices328_200] = racemodel(ones(5000,1)*[3,2.8],200,0.5,1);
perccorrect = nnz(choices328_200==1)/length(choices328_200)
figure(8); clf; reciprobit(lats328_200(find(choices328_200==1)),lats328_200(find(choices328_200==2)));

%% Exercise 9
%
% Modify racemodel.m so that one of the neural variables (x) starts at 0
% while the other starts at 100. Give them both evidence=2, threshold=300,
% trial-to-trial noise 0.5 and no neural noise.
%
% Plot (using reciprobit) the RT distribution for each of the choices
% (see ex 7). What was the effect of giving choice 2 a head-start? What
% does this plot resemble?

% After line 35 in racemodel.m, add
% x(t,2) = 100;
% giving a head start of 100 to choice 2 only

[lats22_300,choices22_300] = racemodel(ones(5000,1)*[2,2],300,0.5,0);
perccorrect = nnz(choices22_300==1)/length(choices22_300)
figure(9); clf; reciprobit(lats22_300(find(choices22_300==1)),lats22_300(find(choices22_300==2)));

%% Exercise 10
%
% Remove the head-start from racemodel.m, and instead modify it so that
% there is a small decay of the neural variable x on every time step.
% (NOTE: Make the decay very small or otherwise it will never reach
% threshold and you'll be waiting for a LONG time)
% Run it with only a single variable with evidence=3, threshold=300,
% trial-to-trial noise=0.5, and no neural noise. Compare this to the
% no-decay condition, using reciprobit plots. What is different?

% After line 40 in racemodel.m, add
% x(t,2) = x(t,2) - 0.1;
% to stimulate decay of 0.1 at every time step for choice 2 only

[lats33_300,choices33_300] = racemodel(ones(5000,1)*[2,2],300,0.5,0);
perccorrect = nnz(choices33_300==1)/length(choices33_300)
figure(10); clf; reciprobit(lats33_300(find(choices33_300==1)),lats33_300(find(choices33_300==2)));