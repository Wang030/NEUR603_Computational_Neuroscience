function myBin = spiketrainBinary(spiketimes,timeaxis,dt)
     indices = round(spiketimes./dt);
     numBins = timeaxis(end)/dt;
     myBin = zeros(1,numBins); % Initiate Spike Train Binary Array
     myBin(indices) = 1; % Record 1 if spike occured within a time step, 0 if not
     display(length(find(myBin == 1))/numBins); % To check the percentage of spikes over the time course
end