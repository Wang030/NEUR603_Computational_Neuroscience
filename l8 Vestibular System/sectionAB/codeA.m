%% Setting up constants for section A
clear all;

fs = 1000; % Sampling Frequency
Ts = 1/fs; % Sampling period

% I. Define the simulink parameters
g = 1; % gain
T= 0.015; % zero time constant
T1 = 5.7; % canals long time constant
T2 = 0.003; % canals short time constant
fc = 1/(2*pi*T); % the corresponding cutoff frequency

figure; set(0,'DefaultAxesFontSize',12); %Set Default Axes Font Size to 12
%% Designing the sine wave input and run the simulation
i = 1;
for f = [0.5 10 20] % fundamental frequency of the sine wave % Input
    L = 10/f; % Simulation length = 10 periods

    t = [1/fs:1/fs:L]'; % Time vector sampled at Ts
    input = 10*sin (2*pi*f*t); %%% Equation for sine wave, f in degrees

    % Use the "sim" function call to simulate canal_dynamics.mdl
    TIMESPAN = [Ts L]; % start time = 0.001 (sec), end time = L (sec)
    sim ('canal_dynamics',TIMESPAN);

    %plot the input and its corresponding output.
    subplot(2,3,i), hold all, plot(t,input),plot(t,simoutCA), title (['Input-Output Response for Canal Afferents, ' num2str(f) 'Hz']);
    legend ('input','output'),xlabel ('Time (sec)'), ylabel ('amplitude (deg/s)')
    
    subplot(2,3,i+3), hold all, plot(t,input),plot(t,simoutTP), title (['Input-Output Response for Torsion Pendulum, ' num2str(f) 'Hz']);
    legend ('input','output'),xlabel ('Time (sec)'), ylabel ('amplitude (deg/s)')
    i = i+1;
    
    display([num2str(f) ' CA ' num2str(max(simoutCA))]); % To determine the max output value
    display([num2str(f) ' TP ' num2str(max(simoutTP))]);
end

%% Transfer functions and Bode plots

% Parameters for the Canal Afferents
Z = [0 -1/T];
P =[-1/T1 -1/T2];
K = [T/(T1*T2)];
LP = zpk(Z,P,K,'Ts',0); %%% Transfer function objects, don't have to use models

% Parameters for the Torsion Pendulum
Z = [];
P =[-1/T1 -1/T2];
K = [1/(T1*T2)];
LP = zpk(Z,P,K,'Ts',0); %%% Transfer function objects, don't have to use models

% Use "bode" to plot the bode plots.
FMIN = 0.01; FRES =.01; FMAX = 100;
fVect = FMIN:FRES:FMAX; %%% Vectors of Frequency
wVect = fVect.*(2*pi);
mag = zeros(length(fVect),1);
ph = zeros(length(fVect),1);
w = zeros(length(fVect),1);
[mag(:),ph(:),w(:)] = bode(LP,wVect); 
figure;
subplot(2,1,1)
loglog(fVect,mag)
ylabel('Amplitude');title('Magnitude Response')
subplot(2,1,2)
semilogx(fVect,ph)
ylabel('Phase (deg)');title('Phase Response')
xlabel('Frequency (deg/sec)')