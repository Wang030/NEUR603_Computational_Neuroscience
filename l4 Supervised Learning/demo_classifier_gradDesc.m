function [E_loss,E_hist] = demo_classifier_gradDesc(eta,nTrials)
% demo_classifer_gradDesc.m 
%
% demo of single-layer binary classifer, using gradient descent
%   sum-square error, sigmoid activation
%   batch mode
%   derived from lab exercise in Bruno Olshausen's VS298 / lab2s.m - single neuron learning
%   uses Bruno's data files, "apples" and "oranges"
% finds line, w0 + w1*x1 + w2*x2 = 0, to best separate 2 categories of data pts

% clear all;   close all;     
fprintf(1,'\n\n\n\n');

%load data files (from Bruno's VS298), and initialize data array
load apples;    load oranges;   % -> pair of 2x10 matrices

data=[apples oranges];          % -> 2x20 matrix
[N nDataPts]=size(data);               % N=2, K=20
 

% initialize teacher (1x20 array)
teacher = [0*ones(1,nDataPts/2) +1*ones(1,nDataPts/2)]; 
lambda = 1;    % sigmoid parameter, in activation function
%{
% eta = input('learning rate:   ');
% if isempty(eta)  error('sorry you MUST specify a learning rate !');  end
if ~exist('eta','var'); error('sorry you MUST specify a learning rate !');  end

%nTrials = input('number of batch-mode trials (e.g. 500):   ');
% if isempty(nTrials)  ;  nTrials=200;  end
if ~exist('nTrials','var')  ;  nTrials=500;  end
%}
    
% initialize weights
w  = randn(2,1);          % 2x1 array
w0 = randn(1);            % scalar

% initialize data plot, and display hyperplane implied by initial-guess weights

if ismac || isunix
    figHanMain = figure('position',[60 1000 300 600]);
elseif ispc
    figHanMain = figure('position',[60   60 300 600]);
end

subplot(2,1,1);
plot(apples(1,:),apples(2,:),'b+',oranges(1,:),oranges(2,:),'ro');  hold on
x1=0:4;
x2=-(w(1)*x1+w0)/w(2);
axis([0 4 -1 3])
h=plot(x1,x2);   grid on;   drawnow;


% initialize histories
E_hist =zeros(1,nTrials);


for iTrial=1:nTrials    % loop over trials (iterations)
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
   w(1) = w(1) + eta*dw(1); 
   w(2) = w(2) + eta*dw(2);     
   w0   = w0   + eta*dw0;       
      
   % record E_loss for history
   E_hist(iTrial) = E_loss;
  
   % update display of separating hyperplane
   x2=-(w(1)*x1+w0)/w(2);
   set(h,'YData',x2);       % "h" from above, "h=plot(...)"
   
   % redraw plots of error (every 20th iteration)
   if mod(iTrial,20)==0
       figure(figHanMain);  subplot(2,1,2);  plot(E_hist);
       axis([0 nTrials 0 1.3*max(E_hist)]);   grid on;
       ylabel('loss - square-error');  xlabel('batch trial');
   end
       
   drawnow  
end
hold off

fprintf(1,'%f, %f\n', eta, E_loss);
% fprintf(1,'\nfinal loss = %f\n', E_loss);

%{
figure(figHanMain);  subplot(2,1,2);
plot(E_hist)
axis([0 nTrials 0 1.3*max(E_hist)]);   grid on;
ylabel('loss - square-error');
xlabel('batch trial');
title([eta]);
saveas(gcf,[int2str(eta)]);
%}
end