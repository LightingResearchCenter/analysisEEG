function [alphaPeak, alphaGravity, alphaVectors] = compute_EEG_findIndivAlphaPeak(freqs, psdata, nrOfWindows, handles)

    % for faster debugging / developing
    if nargin == 0
        handles = init_defaultSettings();
        load(fullfile(handles.path.debugMatFiles, 'tempFindAlphaPeak.mat'))
    else
        if handles.saveTempDebugMATs == 1
            save(fullfile(handles.path.debugMatFiles, 'tempFindAlphaPeak.mat'))
        end
    end

    %% GO THROUGH THE WINDOWS (i.e. EPOCHS, e.g. 148 epochs)
    for w = 1 : nrOfWindows
        
        powerSpectrumRaw(:,1) = psdata(1, :, w); % size 1 x 2049 x 148 (1 x frequencies x epochs)
                                                 % at 0.5 Hz resolution, the highest frequency is around 1024 Hz                                         
   
        % trim the vector, manual quick'n'dirty, to have less frequencies
        ind1 = 1;
        ind2 = 110;
        powerSpectrum = powerSpectrumRaw(ind1:ind2);
        freqs = freqs(ind1:ind2);
        
        %% From Klimesh 1999
        
            % Usually, alpha frequency is defined in terms of peak or gravity frequency within the traditional 
            % alpha frequency range (f1 to f2) of about 7.5–12.5 Hz. Peak frequency is that spectral component 
            % within f1 to f2 which shows the largest power estimate (cf. Fig. 1A). Alpha frequency can also be 
            % calculated in terms of gravity (or `mean') frequency which is the weighted sum of spectral estimates, 
            % divided by alpha power: (∑(a(f)×f))/(∑ a(f)). Power spectral estimates at frequency f are denoted a(f). 
            % The index of summation is in the range of f1 to f2. Particularly if there are multiple peaks in the 
            % alpha range (for a classification see e.g., Ref. [39]), 
            %% gravity frequency appears the more adequate estimate of alpha frequency.
        
        
        %% Define alpha range
            
            alphaRange = [7 13]; % thw window where to look for the peak            
            ind1 = find(freqs == alphaRange(1));
            ind2 = find(freqs == alphaRange(2));
            
        %% get the peak            
            
            [peakValue, peakInd] = max(powerSpectrum(ind1:ind2));
            peakInd = peakInd + ind1; % add the offset of ind1            
            alphaVectors.alphaPeak(w) = freqs(peakInd);
        
        %% calculate the gravity        
                
            SpectralEstimates = powerSpectrum(ind1:ind2) .* freqs(ind1:ind2);
            sumOfSpectralEstimates = sum(SpectralEstimates);            
            powerSum = sum(powerSpectrum(ind1:ind2));
            
            % gravity now is the sum of spectral estimates divided by the power
            alphaVectors.alphaGravity(w) = sumOfSpectralEstimates / powerSum;
        
                                         
    end
    
    %% DEBUG PLOT
    
        %hold on
        %plot(alphaVectors.alphaPeak, 'r')
        %plot(alphaVectors.alphaGravity, 'b')
        %hold off
    
    %% get the scalar from vectors (mean, median, whatever)
    
        % maybe median is more robust estimate if there are a lot of outliers        
        alphaPeak.median = nanmedian(alphaVectors.alphaPeak);
        alphaPeak.aver   = nanmean(alphaVectors.alphaPeak);
        alphaPeak.SD   = nanstd(alphaVectors.alphaPeak);
        alphaGravity.median = nanmedian(alphaVectors.alphaGravity);
        alphaGravity.aver = nanmean(alphaVectors.alphaGravity);
        alphaGravity.SD = nanstd(alphaVectors.alphaGravity);

        
    
    