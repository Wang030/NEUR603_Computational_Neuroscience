%% Parameters and Constants for Section B
clear all;

fs = 1000; % Sampling Frequency
Ts = 1/fs; % Sampling period

% I. Define the simulink parameters
g = -5; % gain
T= 0.015; % zero time constant
T2 = 0.003; % canals short time constant
Tc = 5.7;
Tvor = 20;
Te1 = 20;
Te2 = 0.016;
delay = 0.007;
fc = 1/(2*pi*T); % the corresponding cutoff frequency


set(0,'DefaultAxesFontSize',12); %Set Default Axes Font Size to 12
%% Designing the sine wave input and simulate vor_block_diagram.mdl
i = 1;
f = 0.5;
L = 10/f; % Simulation length = 10 periods

t = [1/fs:1/fs:L]'; % Time vector sampled at Ts
input = 10*sin (2*pi*f*t); %%% Equation for sine wave, f in degrees

TIMESPAN = [Ts L]; % start time = 0.001 (sec), end time = L (sec)
sim ('vor_block_diagram',TIMESPAN);

%Plot the input and its corresponding output.
figure, hold all, plot(t,input),plot(t,simout), title ('Input-Output Response for a VOR');
legend ('input','output'),xlabel ('Time (sec)'), ylabel ('amplitude (deg/s)')

%% Transfer functions and Bode plots
% Write the equivalent transfer function in Matlab to generate the bode
% plots.

% Canal afferent parameters
Z1 = [0 -1/T];
P1 =[-1/Tc -1/T2];
K1 = [T/(Tc*T2)];
LP1=zpk(Z1,P1,K1,'Ts',0);

% Vestibular nuclei parameters
Z2 = [-1/Tc];
P2 =[-1/Tvor];
K2 = [-g];
LP2=zpk(Z2,P2,K2,'Ts',0);

% Neural Integrator parameters
Z3 = [-1*Te1];
P3 =[0];
K3 = [Te1];
LP3=zpk(Z3,P3,K3,'Ts',0);

% Plant parameters
Z4 = [0];
P4 =[-1/Te1 -1/Te2];
K4 = [1/(Te1*Te2)];
LP4=zpk(Z4,P4,K4,'Ts',0);

% Combining the transfer functions
LP = LP1*LP2*LP3*LP4;

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
loglog(fVect,mag) %%% Simulation likes wFrequency, although here it's dFrequency
ylabel('Amplitude');title('Magnitude Response')
subplot(2,1,2)
semilogx(fVect,ph)
ylabel('Phase (deg)');title('Phase Response')
xlabel('Frequency (deg/sec)')

%% Bode plot with a constant physiological delay

fArray=[0.01:0.01:1 1:1:20]; % Array of frequencies to try out
myPhase = zeros(1,length(fArray));
myGain = zeros(1,length(fArray));

for i=1:length(fArray)
f = fArray(i);
L = 10/f;
t = [1/fs:1/fs:L]'; % Simulation length = 10 periods
input = 10*sin (2*pi*f*t);
sim('vor_block_diagram',[Ts L]);

[maxY, maxYIndex]=findpeaks(simout); % Find local maxima

%Calculate phase
myPhase(i)=360*f*(t(maxYIndex(end))-t(round(1/4/f+9*fs/f)));
% 360 * frequency * Time Difference between Last output local maximum and
% Last input local maximum

%Calculate gain
myGain(i)=maxY(end)/10; % 10 = Input's amplitude

end

%plot the gain and phase of output in a similar format to bode plots
figure;
subplot(2,1,1);
loglog(fArray,myGain) %%% Simulation likes wFrequency, although here it's dFrequency
ylabel('Amplitude'); title('Magnitude Response');
subplot(2,1,2);
semilogx(fArray,myPhase)
ylabel('Phase (deg)'); title('Phase Response');
xlabel('Frequency (deg/sec)')

%% Calculate the time constants

% Designing the sine wave input and simulate modified vor_block_diagram_modified.mdl
i = 1;
f = 0.5;
L = 10/f; % Simulation length = 10 periods
t = [1/fs:1/fs:L]'; % Time vector sampled at Ts

% III. use the "sim" function call to simulate vor_block_diagram.mdl
TIMESPAN = [Ts L]; % start time = 0.001 (sec), end time = L (sec)
sim ('vor_block_diagram_modified',TIMESPAN); %%% Simulate the VOR block diagram, tell me sampling rate and how long in time, Will call on SimuLink

%plot the input and its corresponding output.
figure, hold all, plot(t,simout1), plot(t,simout2), plot(t,simoutTotal)
title (['Input-Output Response']);
legend ('After Canal Afferents','After the Vestibular Nuclei','After a VOR');
xlabel ('Time (sec)'), ylabel ('amplitude (deg/s)');