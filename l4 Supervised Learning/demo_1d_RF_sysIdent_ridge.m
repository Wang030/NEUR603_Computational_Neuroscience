function vaf = demo_1d_RF_sysIdent_ridge(alpha,eta,num_trials)
% demo_1d_RF_sysIdent_ridge.m 
%
% demonstrate simple ridge regression estimation of 1-d (spatial) receptive field
% $$ loop across alpha values, using regularization error to decide which to use

% clear all;  close all;  fprintf(1,'\n\n\n\n\n\n');

nRFpts = 32;    % number of points in receptive field (== number of parameters to be estimated)
nMeasEst = 32;   % number of measurements to use for receptive field estimation
nMeasReg = 10;    % additional measurements to use for regularization
nMeasPred = 32;    % additional measurements to use for prediction

%{
eta = input('learning rate:   '); 
if isempty(eta)  error('sorry you MUST specify a learning rate !');  end

num_trials = input('number of batch-mode trials (e.g. 50):   '); 
if isempty(num_trials) ;  num_trials = 50;  end

alpha = input('alpha, regularization parameter (e.g. 0):   ');  
if isempty(alpha)  ;  alpha=0;   end;
%}

figHanMain = figure('position',[60 60 400 500]);
figHanScat = figure('position',[500 60 400 400]);

% define a model receptive field (Gabor function), and plot it
xPtsK = 1:1:nRFpts;
mu = nRFpts/2;   lambda = nRFpts/5;   sig = lambda*0.5;
env = exp(-(xPtsK-mu).^2/(2*sig^2));  % Gaussian envelope
receptiveField = env.*sin(2*pi*xPtsK/lambda);
figure(figHanMain);  subplot(2,1,1);  plot(xPtsK,receptiveField,'b-'); grid;

% create input signals (stimuli):   white noise, range from -1 to +1
stimEst = (rand(nRFpts,nMeasEst) - 0.5);   % stimuli for estimation
stimReg = (rand(nRFpts,nMeasReg) - 0.5);   % stimuli for regularization
stimPred= (rand(nRFpts,nMeasPred) - 0.5);  % stimuli for prediction

% simulate response of the model system (receptive field) to input signal (with some added noise):
respEst = receptiveField*stimEst + 0.15*randn(1,nMeasEst);  % response to estimation stimuli
respReg = receptiveField*stimReg + 0.15*randn(1,nMeasReg);   % response to regularization stimuli
respPred= receptiveField*stimPred + 0.15*randn(1,nMeasPred);  % response to prediction stimuli

% stim   = nRFpts x nMeas
% resp   = 1 x nMeas           % note stim and resp are ~ zero-mean (as they need to be)
% w      = 1 x nRFpts

%w = randn(1,nRFpts);   % random initial weights (receptive field estimate)
w = zeros(1,nRFpts);   % all-zeros initial weights

figure(figHanMain);   % bring figure window to foreground

% $$ begin for-loop for alpha values, HERE

for iTrial = 1:num_trials    % loop over trials (iterations)

   respCalc = w*stimEst;             % predicted response

   % gradient descent
   dw = (respCalc - respEst)*stimEst' + alpha*w; % ridge regression-Bishop 3.23
   w = w - eta*dw;   % learning rule:  update weights   
      
   RF_est = w;
         
   % redraw plot of receptive field estimate 
   subplot(2,1,2);
   plot(xPtsK,receptiveField,'b-',xPtsK,RF_est,'ro');   grid;
   legend('actual receptive field','estimated receptive field');
   drawnow  
end

% test how well we can now predict the regularization dataset
predRespReg = RF_est*stimReg;
% $$ get sum-square-error (or VAF) between respReg and predRespReg
%       and record it
%    also record this RF_est (for this alpha-value)
% END of alpha-loop

% $$ graph sum-square-error vs alpha
%    plot the "best" RF_est, i.e. for the minimum value of the graph
%    set RF_est_final to this one

% $$-> change following, to use RF_est_final:
% assess how well this final estimated RF can predict the hold-back dataset:
predRespPred = RF_est*stimPred;
% VAF for respPredCalc vs respPred
vaf.R_matrix = corrcoef(respPred,predRespPred);  % 2 x 2 matrix, ones on diagonal
vaf.offDiag = vaf.R_matrix(1,2);
vaf.R_sq = vaf.offDiag^2;
fprintf('VAF = %3.1f percent\n', vaf.R_sq*100);

figure(figHanScat);  scatter(predRespPred,respPred);  xlabel('measured responses'); ylabel('predicted responses');
title(sprintf('VAF = %3.1f percent', vaf.R_sq*100));
vaf = vaf.R_sq*100;
end