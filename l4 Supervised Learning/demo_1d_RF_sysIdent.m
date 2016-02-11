function [vaf] = demo_1d_RF_sysIdent(eta,num_trials)
% demo_1d_RF_sysIdent.m 
%
% demonstrate simple regression estimation of 1-d (spatial) receptive field

% clear all;  close all;  fprintf(1,'\n\n\n\n\n\n');

nRFpts = 32;    % number of points in receptive field (== number of parameters to be estimated)
nMeasEst = 64;     % number of measurements to use for receptive field estimation
nMeasPred = 32;
%{
eta = input('learning rate:   '); 
if isempty(eta)  error('sorry you MUST specify a learning rate !');  end

num_trials = input('number of batch-mode trials (e.g. 50):   '); 
if isempty(num_trials) ;  num_trials = 50;  end
%}
figHanMain = figure('position',[60 60 400 500]);
figHanScat = figure('position',[500 60 400 400]);
    
% define a model receptive field (Gabor function), and plot it
xPtsK = 1:1:nRFpts;
mu = nRFpts/2;   lambda = nRFpts/5;   sig = lambda*0.5;
env = exp(-(xPtsK-mu).^2/(2*sig^2));  % Gaussian envelope
receptiveField = env.*sin(2*pi*xPtsK/lambda);
figure(figHanMain); subplot(2,1,1); plot(xPtsK,receptiveField,'b-'); grid;

% create an input signal (stimulus):   white noise, range from -1 to +1
stimEst = (rand(nRFpts,nMeasEst) - 0.5);   % stimuli for estimation
stimPred= (rand(nRFpts,nMeasPred) - 0.5);  % stimuli for prediction

% simulate response of the model system (receptive field) to input signal (with some added noise) 
respEst = receptiveField*stimEst + 0.15*randn(1,nMeasEst);  % response to estimation stimuli
respPred= receptiveField*stimPred + 0.15*randn(1,nMeasPred);  % response to prediction stimuli

% stim   = nRFpts x nMeas
% resp   = 1 x nMeas           % note stim and resp are ~ zero-mean (as they need to be)
% w      = 1 x nRFpts

% w = randn(1,nRFpts);   % random initial weights (receptive field estimate)
w = zeros(1,nRFpts);   % all-zeros initial weights

figure(figHanMain);  % bring figure to foreground

RFs_est = [];
for iTrial = 1:num_trials    % loop over trials (iterations)

   respCalc = w*stimEst;             % predicted response

   % gradient descent
   dw = (respCalc - respEst)*stimEst';  % gradient - Bishop 3.23
   w = w - eta*dw;   % learning rule:  update weights   
    
   RF_est = w; RFs_est(end+1) = w;

   % redraw plot of receptive field estimate 
   subplot(2,1,2);
   plot(xPtsK,receptiveField,'b-',xPtsK,RF_est,'ro');   grid;
   legend('actual receptive field','estimated receptive field');
   drawnow  
end

% assess how well this estimated RF can predict the hold-back dataset:
predRespPred = RF_est*stimPred;
% VAF for respPredCalc vs respPred
vaf.R_matrix = corrcoef(respPred,predRespPred);  % 2 x 2 matrix, ones on diagonal
vaf.offDiag = vaf.R_matrix(1,2);
vaf.R_sq = vaf.offDiag^2;
fprintf('VAF = %3.1f percent\n', vaf.R_sq*100);

figure(figHanScat);  
scatter(predRespPred,respPred);  xlabel('measured responses'); ylabel('predicted responses');
title(sprintf('VAF = %3.1f percent', vaf.R_sq*100));
vaf = vaf.R_sq;
end