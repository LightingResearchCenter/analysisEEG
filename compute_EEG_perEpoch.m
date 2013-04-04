function [ps_bins, psdata, freq] = compute_EEG_perEpoch(ch, w, filteredData, indivPeak, Fs, nrFreqPoints, identifiers, savenameXLS, handles)

    if handles.showDebugMessages == 1
        if ch == 1 && w == 1
            disp('compute_EEG_perEpoch')
            whos
        end
    end
           
    %% Get power spectrum using a subfunction (e.g. FFT)
    % note: no window had been applied for fd unlike 
    % in the previous script, the windowing is being one
    % inside the subfunction
    % handles.ramp = ramp;

       freqVector = linspace(handles.eegSet.lowCut, handles.eegSet.highCut, nrFreqPoints); % create frequency vector for the get_PowerSpectrum.m
       [ps, Hmss] = compute_powerSpectrum(ch, w, filteredData, Fs, freqVector, savenameXLS, handles); % size e.g. 1x4096                  
       psdata = Hmss.Data; % assign to final output
       freq = Hmss.frequencies;

    %% find the indexes corresponding to the different EEG
    % bands (these are defined in initDefaultSettings.m)
    % e.g. http://www.mathworks.com/matlabcentral/answers/53921
       
       ps_bins = cell(length(handles.eegBins.freqs),1);
       
       % For fixed frequency band definitions
       freqBinMode = 'fixed';
       for k = 1 : handles.indexToEndGeneralBins 
           [ps_bins{k}, freqsOut{k}] = compute_EEG_perFreqBands(ch, w, k, Hmss, ps, identifiers, freqBinMode, indivPeak, handles);
       end
        
       % Calculate the "individual alpha peak" bins
       freqBinMode = 'indivAlpha';
       for k = handles.indexToStartIndivBins : handles.indexToEndIndivBins
           [ps_bins{k}, freqsOut{k}] = compute_EEG_perFreqBands(ch, w, k, Hmss, ps, identifiers, freqBinMode, indivPeak, handles);
       end
       
       % Calculate the "ratio bins", for example alpha/theta-ratio
       % See e.g. Donskaya et al. (2012), 
       freqBinMode = 'ratios';
       for k = handles.indexToStartRatioBins : handles.indexToEndRatioBins
           % k
           [ps_bins{k}, freqsOut{k}] = compute_EEG_perFreqBands(ch, w, k, Hmss, ps, identifiers, freqBinMode, indivPeak, handles);
           
            %            if k == 160 % DEBUG
            %                 k
            %                 a = ps_bins{k} 
            %                 whos
            %                 a1 = ps_bins{k}.powerSpec_frequencies{1}
            %                 a2 = ps_bins{k}.data.powerSpectrum{1}
            %                 pause
            %            end
       end
       
              
end
