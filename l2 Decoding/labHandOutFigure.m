    load decodingLabData;

    figure(1);
    clf;
    
    subplot(2,2,3);
    plot(gaussSmooth(mean(neuron1 * 1000,1), 15), 'k')
    set(gca, 'Box', 'off')
    xlabel('Time (ms)');
    ylabel('Spikes / Sec');
    
    subplot(2,2,1);
    plotRaster(neuron1);
    title('Neuron 1');
    ylabel('Trial number');
    
    subplot(2,2,4);
    plot(gaussSmooth(mean(neuron2 * 1000,1), 15), 'k')
    set(gca, 'Box', 'off')
    xlabel('Time (ms)');
    
    
    subplot(2,2,2);
    plotRaster(neuron2);
    title('Neuron 2');
    
    
    