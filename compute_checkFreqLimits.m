% correct the input frequencies to match the possible frequency resolution
function freqs = compute_checkFreqLimits(freqs, freqResolution)

    % disp([freqs])
    % to use the get integer multiplies of resolution
    multiplier = 1 / freqResolution;

    %% Check lower limits
    % now if the lower limits is e.g. 0.75 Hz, the first frequency found
    % with spectral resolution of 0.5 Hz is 1.0 Hz
    
        freqMin = round(multiplier * freqs(1)) / multiplier;
            % e.g. round(2 x 0.75) = 2, 2 / multiplier(@0.5Hz) = 1 Hz
            % e.g. round(2 x 1.0) = 2, 2 / multiplier(@0.5Hz) = 1 Hz
            % e.g. round(2 x 1.25) = 3, 3 / multiplier(@0.5Hz) = 1.5 Hz
    
    %% Check upper limits
    % now if the lower limits is e.g. 0.75 Hz, the last frequency found
    % with spectral resolution of 0.5 Hz is 0.50 Hz
    
        freqMax = floor(multiplier * freqs(2)) / multiplier;
                % e.g. floor(2 x 0.75) = 1, 1 / multiplier(@0.5Hz) = 0.5 Hz
                % e.g. floor(2 x 1.0) = 2, 2 / multiplier(@0.5Hz) = 1 Hz
                % e.g. floor(2 x 0.25) = 0, 0 / multiplier(@0.5Hz) =  0 Hz
    

    freqs = [freqMin freqMax];
    % disp([freqs])