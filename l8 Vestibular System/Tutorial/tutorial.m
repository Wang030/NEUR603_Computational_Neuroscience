clear all

fs = 1000; % Sampling Frequency
Ts = 1/fs; % Sampling period

% I. Define the simulink parameters
g = 1; % gain %%% Play with it
T= 0.016; % time constant;
fc = 1/(2*pi*T); % the corresponding cutoff frequency

% II. Designing the sine wave input
f = 20; % fundamental frequency of the sine wave % Input 
L = 10/f; % Simulation length = 10 periods

t = [1/fs:1/fs:L]'; % Time vector sampled at Ts
input = 10*sin (2*pi*f*t); %%% Equation for sine wave, f in degrees

% III. use the "sim" function call to simulate LP_filter.mdl
TIMESPAN = [Ts L]; % start time = 0.001 (sec), end time = L (sec)
sim ('LP_filter',TIMESPAN); %%% Simulate the low-time filter, tell me sampling rate and how long in time, Will call on SimuLink

%plot the input and its corresponding output.
figure, hold all, plot(t,input),plot(t,simout), title ('Input-Output Response')
legend ('input','output'),xlabel ('Time (sec)'), ylabel ('amplitude (deg/s)')

% Write the equivalent transfer function in Matlab to generate the bode
% plots.
Z = [];
P =[-1/T];
K = [g/T];
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
loglog(fVect,mag) %%% Simulation likes wFrequency, although here it's dFrequency
ylabel('Amplitude');title('Magnitude Response')
subplot(2,1,2)
semilogx(fVect,ph)
ylabel('Phase (deg)');title('Phase Response')
xlabel('Frequency (deg/sec)')

%%% Click on plot, yellow icon.
%%% Look at peaks and trophs
%%% Initial condition, transient response, only want steady-state response
%%% Peak-to-peak Amplitude, there is sometimes an offset with
%%% High-pass filter gives you leads, low-pass filter gives you lags.
%%% Adam Schneider, adam.schneider@mail.mcgill.ca
%%% A lot of it provided, Room 1224, McIntyre