function g = simSTDPlatencies(lat, burstdur, burstrate, N, tau_ltp, tau_ltd, A_ltp, A_ltd, gmax, tau_ex, Vrest, Eex, tau_m, Vth, ttimes)

    %V = Vrest;
    dt = 1; %integration timestep (ms)
    g = ones(N,1).*0.0125;
    x = zeros(N,1); %Presynaptic traces (STDP online implementation)
    y = 0; %Postsynaptic traces (STDP online implementation)   
    firingp = 1-exp(-burstrate*0.001);
    
    subplot(2,2,1)
    h = scatter(lat, g./gmax, 20, [0 0 0]);
    
    ylim([0 1]);
    xlim([-55 55]);
    ylabel('g/g_{max}');
    xlabel('Relative Latency');
    
    int = -50:50;
    Vs = zeros(length(int),1);
    
    %1. Start simulation    
    for xx=1:ttimes
        if(mod(xx,100)==0)
            disp(['Iteration ' num2str(xx) '/' num2str(ttimes)]);
        end    
        
        i=1;
        tpre = ones(N,1).*-9999999; % Pre neuron spike time
        V = Vrest;
        for t=int

            %Excitatory input kernel
            gex = sum(g.*exp(-(t-tpre)/tau_ex));

            %Integrate-and-fire neuron model (with Euler integration)
            dV = (Vrest - V + gex*(Eex-V))/tau_m;
            V = V + dV*dt;
            Vs(i) = V; %Storage voltage

            spost = 0;
            if(V>=Vth) %Spike generation
                V = -60; %Reset potential
                Vs(i) = 0;
                spost = 1;
                g = g + gmax .* A_ltp .* x; %tLTP
            end
            dy = (-y + spost)/tau_ltd;

            spikespre = rand(N,1)<=firingp & t>=lat & t<(lat+burstdur);
            tpre(spikespre) = t+1;
            dx = (-x + spikespre)./tau_ltp;

            %Spike-timing-dependent plasticity
            g(spikespre) = g(spikespre) - gmax .* A_ltd .* (y.*spikespre(spikespre)); %tLTD

            %Update traces
            x = x + dx.*dt;
            y = y + dy*dt;

            %Bound conductances
            g = max(min(g,gmax),0);
            i=i+1;
        end

        if(xx==1)
            subplot(2,2,2)
            plot(int, Vs, '-k');
            ylabel('Voltage (mV)');
            xlabel('t (ms)');
        end  
        
    end
    
    subplot(2,2,3)
    scatter(lat, g./gmax, 20, [0 0 0]);
    ylim([0 1]);
    xlim([-55 55]);
    ylabel('g/g_{max}');
    xlabel('Relative Latency');
    
    subplot(2,2,4)
    plot(int, Vs, '-k');
    ylabel('Voltage (mV)');
    xlabel('t (ms)');
end    