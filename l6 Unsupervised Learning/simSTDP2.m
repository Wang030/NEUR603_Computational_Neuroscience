function g = simSTDP2(corri, corr_time, N, tau_ltp, tau_ltd, A_ltp, A_ltd, gmax, tau_ex, Vrest, Eex, tau_m, Vth, stime, yConst)

    % The switch between clusters is determined by the variable dur, 
    % so that when there are two clusters competing only one of them 
    % is "correlated" within a given dur (this is controled by the variable c)

    V = Vrest;
    dt = 1; %integration timestep (ms)
    
    ratesi = zeros(N,1); % Input neuron rates
    ratesp = zeros(N,1); % Input neuron spiking probabilities
    x = zeros(N,1); %Presynaptic traces (STDP online implementation)    
    y = 0; %Postsynaptic trace (STDP online implementation)    
    tpre = ones(N,1).*-9999999; % Pre neuron spike time    
    g = min(max(rand(N,1).*gmax, 0),gmax); % Initial weights

    dur1 = round(max(1, corr_time + randn()));
    dur2 = round(max(1, corr_time + randn()));

    %Uncorrelated input
    xa = randn(N,1);   
    ratesi(corri==0) = 10.*(1+0.3.*sqrt(2).*xa(corri==0)); % stores the cluster indexes
        
    corr1 = 0;
    if(sum(corri==1)>0) %Init correlated cluster 1
        corr1 = 1;
        xa = randn(N,1);   
        ya = randn();
        ratesi(corri==1) = 10.*(1+0.3.*sqrt(2).*xa(corri==1) + yConst*ya);
    end
    
    corr2 = 0;
    if(sum(corri==2)>0) %Init correlated cluster 2
        corr2 = 1;
        xa = randn(N,1);   
        ya = randn();
        ratesi(corri==2) = 10.*(1+0.3.*sqrt(2).*xa(corri==2) + yConst*ya); 
    end
    
    ratesi = max(ratesi, 0);
    ratesp(corri==0) = 1-exp(-ratesi(corri==0)*0.001);
    ratesp(corri==1) = 1-exp(-ratesi(corri==1)*0.001);
    ratesp(corri==2) = 1-exp(-ratesi(corri==2)*0.001);
    
    h = scatter(1:N, g./gmax, 20, [0 0 0]);
    ylim([0 1]);
    
    %1. Start simulation
    for t=1:stime

        if(mod(t,dur1)==0) %Generate new interval
            xa = randn(N,1);
            ratesi(corri==0) = 10.*(1 + 0.3.*sqrt(2).*xa(corri==0)); %Uncorrelated input
            dur1 = round(max(1, corr_time + randn()));
            
            xa = randn(N,1);
            ya = randn();
            if(corr1)
                ratesi(corri==1) = 10.*(1 + 0.3.*xa(corri==1) + yConst*ya); %Correlated cluster 1
                ratesp(corri==1) = 1-exp(-ratesi(corri==1)*0.001);
            end
            ratesp(corri==0) = 1-exp(-ratesi(corri==0)*0.001);
            ratesi = max(ratesi, 0);
        end
        
        if(corr2 && mod(t,dur2)==0) %Correlated cluster 2
            xa = randn(N,1);
            ya = randn();
            dur2 = round(max(1, corr_time + randn()));
            
            ratesi(corri==2) = 10.*(1 + 0.3.*xa(corri==2) + yConst*ya); 
            ratesp(corri==2) = 1-exp(-ratesi(corri==2)*0.001);
        end    
        
        %Excitatory input kernel
        gex = sum(g.*exp(-(t-tpre)/tau_ex));

        %Integrate-and-fire neuron model (with Euler integration)
        dV = (Vrest - V + gex*(Eex-V))/tau_m;
        V = V + dV*dt;
        
        spost = 0;
        if(V>=Vth) %Spike generation
            V = -60; %Reset potential
            spost = 1;
            g = g + gmax .* A_ltp .* x; %tLTP
        end
        dy = (-y + spost)/tau_ltd;
        
        spikespre = rand(N,1)<=ratesp;
        tpre(spikespre) = t+1;
        dx = (-x + spikespre)./tau_ltp;
        
        %Spike-timing-dependent plasticity
        g(spikespre) = g(spikespre) - gmax .* A_ltd .* (y.*spikespre(spikespre)); %tLTD
        
        %Update traces
        x = x + dx.*dt;
        y = y + dy*dt;

        %Bounds conductances
        g = max(min(g,gmax),0);
        
        if(mod(t,10000)==0)
         set(h,'YData',g./gmax);
         drawnow
         pause(0.0005)
         t
        end 
    end
end    