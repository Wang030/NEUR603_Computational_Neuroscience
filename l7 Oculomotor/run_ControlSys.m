function [posdelta,veldelta,F] = run_ControlSys(sac_mag,sac_dur,p)

desdelta = sac_mag;                 %deg:   desired saccade magnitude
posdelta = zeros(1,length(p.t));    %deg:   Eye Position 
veldelta = zeros(1,length(p.t));    %deg/s: Eye Velocity
F        = zeros(1,length(p.t));    %g:     force
BG       = sac_mag/sac_dur;         %deg/s: Burst generator output in deg/s

for n=2:length(p.t)
    error = desdelta - posdelta(n-1);
    if error > 0
        veldelta(n) = BG;
    else
        veldelta(n) = 0;
    end
    posdelta(n) = trapz(1:n,veldelta(1:n).*p.dt);
    %fun = @(t) veldelta(t)*p.dt;
    %posdelta(n) = integral(fun,1,n);

    F(n) = p.K * posdelta(n) + p.R * veldelta(n);
end

%IMPLEMENT THE BURST GENERATOR HERE
%TURN THE PSEUDOCODE INTO MATLAB
%
%       error = Desired Eye Position - Eye Position(n-1)
%
%       if error >0
%           Eye Velocity(n) = BG
%       otherwise
%           Eye Velocity(n) = 0;
%       end
%
%       Eye Position(n) = Integral of Eye Velocity for n=1 to current n 
%                         (NOTE: recall that eye velocity is in deg/sec,
%                         this is a control system that increments by clock
%                         tick.  Each clock tick is p.dt sec)
%
%       Force(n) = K*Eye Position(n) + R*Eye Velocity(n)