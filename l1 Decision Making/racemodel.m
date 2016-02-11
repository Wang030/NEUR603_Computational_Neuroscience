function [latencies,choices,act] = racemodel(evidence, threshold, trialnoise, neuralnoise)

% RACEMODEL  Generates reaction time and decision data from a race model
% 
% [latencies,choices,act] = racemodel(evidence, threshold, trialnoise, neuralnoise)
%
% The model can be run for N trials with M choices to choose between on
% each trial.
%
% evidence:     An NxM array of evidence values for M choices
% threshold:    The decision threshold
% trialnoise:   The strength of trial-to-trial variability
% neuralnoise:  The strength of moment-to-moment variability
%
% latencies:    An Nx1 array of decision latencies
% choices:      An Nx1 array of the choices made on each trial (1 to M)
% act:          A cell array {1:N} of TxM matrices of neural variables over
%               time from 1:T
%
% NOTE: If evidence has more than 1 column (M>1) then the simulation will
% run with M neural variables growing to the threshold, and will stop
% whenever any of them reaches the threshold.

[N,M] = size(evidence); % N=number of trials, M=number of choices
arousal = randn(N,M)*trialnoise;
act = {};         % History of activities over trials
maxtime = 5000;   % If the simulation goes on for more than 5000 time
                  % steps, abort and set choice to 0.

for i=1:N
   clear x;    % The variable "x" is a matrix of neural activities, where
               % rows are samples in time and columns are different neurons
   t = 1;      % Start at time t=1
   % Here, we initialize all M neural variables to zero
   x(t,1:M) = zeros(1,M); % x(t,2) = 100; % Give head start for column (choice) 2
   % Now we loop until one of them crosses the threshold
   while isempty(find(x(t,:)>threshold)) & t<maxtime;
      t=t+1;
      % Add evidence and noise to neural activity
      x(t,:) = x(t-1,:) + evidence(i,:) + arousal(i,:) + randn(1,M)*neuralnoise; % x(t,2) = x(t,2) - 0.1; % Stimulate decay of 0.1 for column (choice) 2
   end
   % Make a note of the latency
   latencies(i) = t;
   if ~isempty(find(x(t,:)>threshold))
      [m,choices(i)] = max(x(t,:));
   else
      choices(i) = 0;
   end
   % Store the history of neural activity
   act{i} = x;
end