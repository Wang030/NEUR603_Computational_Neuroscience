function g = simSTDP(corri, corr_time, N, tau_ltp, tau_ltd, A_ltp, A_ltd, gmax, tau_ex, Vrest, Eex, tau_m, Vth, stime, yConst)

    V = Vrest;
    dt = 1; %integration timestep (ms)
    
    ratesi = zeros(N,1); % Input neuron rates
    ratesp = zeros(N,1); % Input neuron rates
    x = zeros(N,1); %Presynaptic traces (STDP online implementation)    
    y = 0; %Postsynaptic traces (STDP online implementation)    
    tpre = ones(N,1).*-9999999; % Pre neuron spike time    
    g = min(max(rand(N,1).*gmax, 0),gmax); % Initial weights

    xa0 = randn(N,1);
    xa1 = randn(N,1);
    xa2 = randn(N,1);
    y1 = randn();
    y2 = randn();
    dur = round(max(1, corr_time + randn()));
    c = 0;
    corr2 = 0;
    if(sum(corri==2)>0)
        corr2 = 1;
        c = 1;
    end   

    ratesi(corri==0) = 10.*(1+0.3.*sqrt(2).*xa0(corri==0)); %Uncorrelated input
    ratesi(corri==1) = 10.*(1+0.3.*sqrt(2).*xa1(corri==1) + yConst*y1); %Correlated cluster 1
    ratesi(corri==2) = 10.*(1+0.3.*sqrt(2).*xa2(corri==2) + yConst*y2); %Correlated cluster 2
    ratesi = max(ratesi, 0);
    ratesp(corri==0) = 1-exp(-ratesi(corri==0)*0.001);
    ratesp(corri==1) = 1-exp(-ratesi(corri==1)*0.001);
    ratesp(corri==2) = 1-exp(-ratesi(corri==2)*0.001);
    
    h = scatter(1:N, g./gmax, 20, [0 0 0]);
    ylim([0 1]);
    
    %1. Start simulation
    for t=1:stime

        if(mod(t,dur)==0) %Set new interval for cluster 2
            xa0 = randn(N,1);
            ratesi(corri==0) = 10.*(1 + 0.3.*sqrt(2).*xa0(corri==0)); %Uncorrelated input
            dur = round(max(1, corr_time + randn()));
            
            xa1 = randn(N,1);
            y1 = randn();
            if(c)
                ratesi(corri==2) = 10.*(1 + 0.3.*xa1(corri==2) + yConst*y1); %Correlated cluster 2
                ratesp(corri==2) = 1-exp(-ratesi(corri==2)*0.001);
             
                c = 0;
            else                
                ratesi(corri==1) = 10.*(1 + 0.3.*xa1(corri==1) + yConst*y1); %Correlated cluster 1
                ratesp(corri==1) = 1-exp(-ratesi(corri==1)*0.001);
                
                if(corr2)
                    c = 1;
                end    
            end
            ratesp(corri==0) = 1-exp(-ratesi(corri==0)*0.001);
            ratesi = max(ratesi, 0);
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