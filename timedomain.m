function [AVNN,SDNN,RMSSD,pNN50] = timedomain (signal_NN)
    %signal_NN=signal_NN*1000; %conversion to milliseconds
    pnn_thresh_ms=50; %threshold for pNN50
    
    AVNN = mean(signal_NN); %average interval values
    SDNN = std(signal_NN); %standard deviation of intervals    
    RMSSD = sqrt(mean(diff(signal_NN).^2)); %square root of the mean squares of differences between successive intervals
    pNN50 = 100 *sum(abs(diff(signal_NN)) > pnn_thresh_ms) / (length(signal_NN)-1); %percentage of differences between intervals exceeding 50 ms[%]
end
