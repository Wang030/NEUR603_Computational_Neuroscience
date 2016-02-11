% STDP and selectivity development
% Reproduction of Figure 1 in Song et al. Neuron 2001

close all
clear all
clc

%0. Parameters
 %Network Parameters
 N = 100; %number of neurons
 
 %STDP Parameters
 B = 1.05; %(tau_ltd*A_ltd)/(tau_ltp*A_ltp)
 tau_ltp = 20; %LTP timeconstant (ms)
 tau_ltd = tau_ltp; %LTD timeconstant (ms)
 A_ltp = 0.005; %LTP amplitude []
 A_ltd = B*A_ltp; %LTD amplitude []
 gmin = 0;
 gmax = 0.015*50;
 
 %Neuron Parameters
 Vrest = -74; %Resting membrane potential (mV)
 tau_m = 20; %Membrane timeconstant (ms)
 tau_ex = 5; %Excitatory kernel timeconstant (ms)
 Eex = 0; %Excitatory reversal potential (mV)
 Vth = -54; %Firing threshold (mV)
  
 stime = 500000; %Sim. time
 yConst = 2;
 
 sSTDP = @simSTDP2; %Set STDP simulation function (simSTDP: non-concurrent clusters, simSTDP2: concurrent clusters)
 
 
%1. Simulations
gFinal = zeros(N,3);

corri = zeros(N,1); % Correlation identifier 0 - uncorr; 1 - 1st corr pop; 2 - 2nd corr pop
corr_time = 20; %Correlation time (ms)

%1.1 1st cluster: uncorrelated, 2nd cluster: uncorrelated
figure
if(1)
 subplot(2,2,2);
 gFinal(:,1) = sSTDP(corri, corr_time, N, tau_ltp, tau_ltd, A_ltp, A_ltd, gmax, tau_ex, Vrest, Eex, tau_m, Vth, stime, yConst);
 title('Uncorrelated   Uncorrelated');
 ylabel('g/g_{max}');
 xlabel('Input Neuron');
end 
 
%1.2 1st cluster: correlated, 2nd cluster: uncorrelated 
corri(1:end/2) = 1; % Correlation identifier 0 - uncorr; 1 - 1st corr pop; 2 - 2nd corr pop 
if(1) 
 yConst = 2;
 subplot(2,2,3);
 gFinal(:,2) = sSTDP(corri, corr_time, N, tau_ltp, tau_ltd, A_ltp, A_ltd, gmax, tau_ex, Vrest, Eex, tau_m, Vth, stime, yConst);
 title('Correlated   Uncorrelated');
 ylabel('g/g_{max}');
 xlabel('Input Neuron');
end 

%1.3 1st cluster: correlated, 2nd cluster: correlated
if(1)
 gmax = 0.015*125;
 yConst = 15;
 subplot(2,2,4);
 corri(end/2+1:end) = 2; % Correlation identifier 0 - uncorr; 1 - 1st corr pop; 2 - 2nd corr pop
 gFinal(:,3) = sSTDP(corri, corr_time, N, tau_ltp, tau_ltd, A_ltp, A_ltd, gmax, tau_ex, Vrest, Eex, tau_m, Vth, stime, yConst); 
 title('Correlated   Correlated');
 xlabel('Input Neuron');
end

