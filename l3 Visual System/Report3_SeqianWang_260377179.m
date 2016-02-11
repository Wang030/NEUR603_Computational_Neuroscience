% Report 3 Neural Encoding
% Seqian Wang, 260377179

%%% Part 1: Reverse Correlation

%%% Recovering the Filter

%% Generate the stimulus and response
input = rand(1000,1)*2-1; % Vector, length 1000, random values between -1 and 1
output_observed = oned(input); % Input fed into model neuron

%% Recover the linear filter
crossCorr = xcorr(output_observed,input); % Cross-correlation between input and output
crossCorr = crossCorr./length(input)./std(input)^2; % Normalization by duration and sd^2
filter = crossCorr(1050:1100);
figure('visible','off'); plot(filter); title('Predicted Filter'); saveas(gcf,'Filter.jpg');

%% Compare the predicted output of my filter with the observed output
output_predicted = conv(filter,input); % Applying the filter to the white noise input
figure('visible','off'); hold all; plot(output_predicted); plot(output_observed); hold off;
title('Predicted Output vs Observed Output');
legend('Predicted Output','Observed Output');
saveas(gcf,'pOvsrO.jpg');

%% Make a scatter plot 
figure('visible','off'); scatter(output_predicted,output_observed);
title('Predicted Output vs Observed Output Scatter Plot');
xlabel('Predicted Output');
ylabel('Observed Output');
saveas(gcf,'pOvsrOScatter.jpg');

%%% Testing the Filter

% Find static nonlinearity parameters
%% Nonlinearity Parameters estimated by eye (g1 and L1/2) 
output_predicted_nl = max(output_observed)./(1+exp(0.2*(25-output_predicted)));
figure('visible','off'); hold all; plot(output_predicted_nl); plot(output_observed); hold off;
title('Predicted Output with nonlinearity correction vs Observed Output');
legend('Predicted Output','Observed Output');
saveas(gcf,'pOnlvsrO.jpg');

%% Compute the mean squared error between the estimated and observed responses at various vector lengths, before and after nonlinearity correction
for trial_duration = [100 500 1000 2000 5000]
    [total_mse, total_mse_nl] = deal(zeros(1,50));
    for i = 1:50 % Compute a mean square error 50 times
        input = rand(trial_duration,1)*2-1;
        output_observed = oned(input);
        output_predicted = conv(filter,input);
        output_predicted_nl = max(output_observed)./(1+exp(0.2*(25-output_predicted)));
        mse = mean((output_predicted-output_observed).^2); % Mean Squared Error
        mse_nl = mean((output_predicted_nl-output_observed).^2);
        total_mse(i) = mse;
        total_mse_nl(i) = mse_nl;
    end
    display([trial_duration,mean(total_mse),mean(total_mse_nl)]);
end

%%% Part 2: Spike-triggered averaging with a three-dimensional input

%% Recovering the filter
input_visual = rand([20 20 12000]);
output = threed(input_visual);

% Determining the peak and trough of the temporal response
[~,index_maxValue] = max(filter); % Index = 8, peak
[~,index_minValue] = min(filter); % Index = 16, trough

spikeIndexes = find(output == 1); % Find indexes of spikes
spikeIndexes_peak = spikeIndexes - index_maxValue; % To find indexes of stimulus
spikeIndexes_trough = spikeIndexes - index_minValue;

sta_peak = input_visual(:,:,spikeIndexes_peak);
sta_peak = mean(sta_peak,3);
figure('visible','off'); imagesc(sta_peak); colorbar;
title('Spatial Receptive Field corresponding to the Temporal Response Peak');
saveas(gcf,'rfPeak.jpg');

sta_trough = input_visual(:,:,spikeIndexes_trough);
sta_trough = mean(sta_trough,3);
figure('visible','off'); imagesc(sta_trough); colorbar;
title('Spatial Receptive Field corresponding to the Temporal Response Trough');
saveas(gcf,'rfTrough.jpg');