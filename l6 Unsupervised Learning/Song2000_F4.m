% STDP and reduction of latency
% Reproduction of Figure 4 in Song et al. NatNeuro 2000

close all
%clear all
clc

%0. Parameters
 %Network Parameters
 N = 1000; %number of neurons
 
 %STDP Parameters
 B = 1.05; %(tau_ltd*A_ltd)/(tau_ltp*A_ltp)
 tau_ltp = 20; %LTP timeconstant (ms)
 tau_ltd = tau_ltp; %LTD timeconstant (ms)
 A_ltp = 0.005; %LTP amplitude []
 A_ltd = B*A_ltp; %LTD amplitude []
 gmin = 0;
 gmax = 0.015;
 
 %Neuron Parameters
 Vrest = -74; %Resting membrane potential (mV)
 tau_m = 20; %Membrane timeconstant (ms)
 tau_ex = 5; %Excitatory kernel timeconstant (ms)
 Eex = 0; %Excitatory reversal potential (mV)
 Vth = -54; %Firing threshold (mV)
 
 ttimes = 2000; %Number of iterations

 
%1. Simulations

figure

latencies = randn(N,1)*15; % Latencies (15ms std dev)
burstdur = 20; %Burst duration (ms)
burstrate = 100; %Burst frequency (Hz)

gFinal = simSTDPlatencies(latencies, burstdur, burstrate, N, tau_ltp, tau_ltd, A_ltp, A_ltd, gmax, tau_ex, Vrest, Eex, tau_m, Vth, ttimes);
