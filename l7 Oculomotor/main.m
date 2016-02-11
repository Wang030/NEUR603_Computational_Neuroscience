close all
clear all

%Parameters----------------------------------------------------------------
p.R  = 0.22;        %g.sec/deg: viscous element
p.K  = 1.25;        %g/deg:     spring stiffness
p.dt = 0.005;       %sec:       sampling time
p.t  = 0:p.dt:0.3;  %time:      time vector
sac_dur = 110e-3;   %sec:       saccade duration
sac_mag = 40;       %deg:       saccade magnitude
%--------------------------------------------------------------------------

%% Part I==================================================================
%% Question 1b: Find F
t = 0.110; % 0.045 0.068 0.110
theta = 40; % 10 20 40
F=p.K*theta/(1-exp(-p.K*t/p.R));
display(F);

%% Question 1d: Plot the pulse-steps

% Initiate Figures
%plotEye = figure;

% For different saccade sizes and time
pAfter = 40; % 10 20 40, Eye Final Position in degrees
tDuring = 110; % 45 68 110, Saccade Time in msec
plotColor = 'g'; % b r g

pDuring = pAfter/tDuring; % Step position per time
tBefore = 10; % Time in msec
tAfter = 141 - tBefore - tDuring;
fBefore = 0; % Force in grams
fDuring = p.K*pAfter/(1-exp(-p.K*tDuring/1000/p.R));
fAfter = p.K * pAfter;

t = 0:140;
F = [ones(1,tBefore)*fBefore ones(1,tDuring)*fDuring ones(1,tAfter)*fAfter];
eyePosition = [zeros(1,tBefore) 0:pDuring:pAfter ones(1,tAfter-1)*pAfter];

% Plotting
figure(plotEye); subplot(2,1,1); plot(t,eyePosition,plotColor); hold on;
title('Eye Position as a function of time');
xlabel('Time (in msec)');
ylabel('Eye Position (in degrees)');
legend('10 degrees', '20 degrees', '40 degrees');

figure(plotEye); subplot(2,1,2); plot(t,F,plotColor); hold on;
title('Force as a function of time');
xlabel('Time (in msec)');
ylabel('Force (in grams)');
legend('10 degrees', '20 degrees', '40 degrees');

%% Part II=================================================================
%%Question 2cd
[posdelta,veldelta,F] = run_ControlSys(sac_mag,sac_dur,p);    %***TODO***: modify the content of this function
figure; plot(p.t,posdelta,p.t,veldelta,p.t,F);
title('Estimated eye position, BG output and Force versus time for a 40 degrees saccade');
xlabel('Time (s)');
ylabel('Amplitude');
legend('Eye Position (deg)','Velocity (deg/s)','Force (g)');
[plantT,plantEye] = ode45(@(t,y)odefunc(t,y,F,p),p.t,0);      %***TODO***: modify the function odefunc
figure; plot(plantEye,F')
title('Force as a function of eye position');
xlabel('Eye Position (deg)');
ylabel('Force (g)');

%% Question 2e
figure; plot(plantT,plantEye,p.t,posdelta);
title('Observed vs Expected Position');
xlabel('time (s)');
ylabel('eye position (deg)');
legend('Observed Position','Expected Position','Location','NorthWest');

%% Question 2f
p.K = p.K/2;
[posdelta,veldelta,F] = run_ControlSys(sac_mag,sac_dur,p);    %***TODO***: modify the content of this function
p.K = p.K*2;
[plantTLesion,plantEyeLesion] = ode45(@(t,y)odefunc(t,y,F,p),p.t,0);      %***TODO***: modify the function odefunc
figure; plot(plantTLesion,plantEyeLesion,plantT,plantEye);
title('Lesioned vs Unlesioned Saccade');
xlabel('time (s)');
ylabel('eye position (deg)');
legend('Lesioned Saccade','Unlesioned Saccade','Location','NorthWest');