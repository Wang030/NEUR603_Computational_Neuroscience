function [E_loss, E_hist] = demo_classifier_reg(eta,alpha,nTrials)
%
% demo of single-layer binary classifer, using gradient descent with regularization
%   sum-square error, sigmoid activation
%   batch mode
%   derived from lab exercise in Bruno Olshausen's VS298 / lab2s.m - single neuron learning
%   uses Bruno's data files, "apples" and "oranges"
% finds line, w0 + w1*x1 + w2*x2 = 0, to best separate 2 categories of data pts

% clear all;   close all;

fprintf(1,'\n\n\n\n');

%load data files (from Bruno's VS298), and initialize data array
load apples;    load oranges;   % -> pair of 2x10 matrices

data=[apples oranges];          % -> 2x20 matrix (Bruno's VS298 data files)
[N nDataPts]=size(data);               % N=2, K=20
 

% initialize teacher (1x20 array)
teacher = [0*ones(1,nDataPts/2) +1*ones(1,nDataPts/2)]; 
lambda = 1;    % sigmoid parameter, in activation function

% learning rate
%{
eta = input('learning rate:   ');
if isempty(eta)  error('sorry you MUST specify a learning rate !');  end

nTrials = input('number of batch-mode trials (e.g. 500):   ');
if isempty(nTrials)  ;  nTrials=500;  end
    
alpha = input('regularization parameter, alpha:  ');
if isempty(alpha)  ;  alpha=0;  fprintf(1,'using alpha=0\n'); end
%}
% initialize weights
w  = randn(2,1);          % 2x1 array
w0 = randn(1);            % scalar

% initialize data plot, and display hyperplane implied by initial-guess weights
if ismac || isunix
    figHanMain = figure('position',[60 1000 300 600]);
    figWeights = figure('position',[60 1000 300 300]);
elseif ispc
    figHanMain = figure('position',[60   60 300 600]);
    figWeights = figure('position',[60   60 300 300]);
end

figure(figHanMain); subplot(2,1,1);
plot(apples(1,:),apples(2,:),'b+',oranges(1,:),oranges(2,:),'ro');  hold on
x1=0:4;
x2=-(w(1)*x1+w0)/w(2);
axis([0 4 -1 3])
h=plot(x1,x2);   grid on;   drawnow;

% initialize histories
E_hist =zeros(1,nTrials);
w0_hist=zeros(1,nTrials);  w1_hist=w0_hist;  w2_hist=w0_hist;

% loop over trials
for iTrial=1:nTrials
   % initialize dw's and E
   dw(1)  = 0;
   dw(2)  = 0;
   dw0    = 0;
   E_loss = 0;
   
   % loop over training set
   for iDataPt=1:nDataPts
        % compute neuron output
        u = w0 + w(1)*data(1,iDataPt) + w(2)*data(2,iDataPt); 
        
        y = 1 / (1 + exp(-lambda*u));  % activation
            
        % compute error
        E = teacher(iDataPt) - y;     % scalar value of raw error
        
        % accumulate dw and dw0
        dw(1) = dw(1) + E*(exp(-lambda*u)/((1+exp(-lambda*u))^2))*data(1,iDataPt);
        dw(2) = dw(2) + E*(exp(-lambda*u)/((1+exp(-lambda*u))^2))*data(2,iDataPt);
        dw0   = dw0   + E*(exp(-lambda*u)/((1+exp(-lambda*u))^2));            
        
        % accumulate error
        E_loss = E_loss + E^2;  % loss function = error-squared
   end
   
   % update weights
   w(1) = w(1) + eta*(dw(1) - alpha*w(1));     
   w(2) = w(2) + eta*(dw(2) - alpha*w(2));     
   w0   = w0   + eta*(dw0   - alpha*w0);   % (should w0 have it's own regularizer ?)    
   
   % record E_loss for history
   E_hist(iTrial) = E_loss;
   w0_hist(iTrial) = w0;
   w1_hist(iTrial) = w(1);
   w2_hist(iTrial) = w(2);
  
   % update display of separating hyperplane
   x2=-(w(1)*x1+w0)/w(2);
   set(h,'YData',x2);       % "h" from above, "h=plot(...)"
   
   % redraw plot of error (every 20th iteration)
   if mod(iTrial,20)==0
       figure(figHanMain);  subplot(2,1,2);  plot(E_hist);
       axis([0 nTrials 0 1.3*max(E_hist)]);   grid on;
       ylabel('loss - square-error');  xlabel('batch trial');
       
       figure(figWeights); plot(1:length(w0_hist),w0_hist,'r',1:length(w0_hist),w1_hist,'b',1:length(w0_hist),w2_hist,'g');
       axis([0 nTrials 0 1.3*max([w0_hist w1_hist w2_hist])]);   grid on;
       ylabel('weight value');  xlabel('batch trial');
       legend('w0','w1','w2');
   end
       
   drawnow  
end
hold off
fprintf(1,'\nfinal loss = %f\n', E_loss);

figure(figHanMain);  subplot(2,1,2);
plot(E_hist)
axis([0 nTrials 0 1.3*max(E_hist)]);   grid on;
ylabel('loss - square-error');
xlabel('batch trial');




