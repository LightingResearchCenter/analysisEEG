function [ps_bins, psdata] = compute_EEG_perChannel(ch, EEG_filt, psdata, EOG, indivPeak, rs, wd, Fs, nrOfWindows, nrFreqPoints, noOfChannels, identifiers, savenameXLS, handles)

    % NOTE:
    % if you want do some time-frequency analysis you should do it
    % here before the loop with w for the whole data set without
    % splitting it into these time windows
    ps_bins = cell(nrOfWindows, 1);
    
    if handles.showDebugMessages == 1
        if ch == 1
            disp('compute_EEG_perChannel')
            whos
        end
    end
    
    numberOfSamples = wd*Fs; % epoch length [s] * sampling rate [samples/s]     
    filteredDataSegments = zeros(nrOfWindows, numberOfSamples);
    
    %% Reject epoch (convert to NaN) if there are artifacts
    % Goes through the windows (i.e. time epochs)
    for w = 1 : nrOfWindows
        
        % remove artifacts, based on fixed thresholds (uV)        
        filteredDataSegments(w,:) = compute_removeArtifacts(ch, EEG_filt, EOG, handles.eegSet.artifactThr_eFixed, handles.eegSet.artifactThr_eEyeEOG, nrFreqPoints, noOfChannels, rs, wd, Fs, w, handles);      
        
    end
    
    %% Compute power spectrum per epoch
    % Goes through the windows (i.e. time epochs)
    for w = 1 : nrOfWindows
        
        [ps_bins{w}, psdata(1,:,w), freq] = compute_EEG_perEpoch(ch, w, filteredDataSegments(w,:), indivPeak, Fs, nrFreqPoints, identifiers, savenameXLS, handles);
        
            % note, the 1 refers now to the channel of the 3-dimensional
            % data matrix, but its dimension is always 1 inside this loop,
            % and the channels are fed to this loop from computeMain
            % one-by-one            
    end
    
    % determine the alpha peak
    
        % From Robert Hamner
        % ==================
        % In order to determine the peak alpha power, all power spectra on the Oz channel were analyzed for
        % each subject for each trial.  The frequency between 7 and 13 Hz with the highest power was marked as the
        % peak-alpha frequency (fα) for that trial.  For each subject, the median fα from
        % all trials was marked as the fα for that subject.  
        
        % Based on this frequency, the frequencies were split into the following bins: 
        % theta (fα – 5.5 Hz to fα – 2.5 Hz), alpha (fα – 2.5 Hz to fα + 2.5 Hz), low alpha (fα
        % – 2.5 Hz to fα), and high alpha (fα Hz to fα + 2.5 Hz).  All four channels (Fz, Cz, Pz,
        % and Oz) were averaged for each of these bins.

        %% Go through the psdata matrix computed above
        [alphaPeak, alphaGravity, alphaVectors] = compute_EEG_findIndivAlphaPeak(freq, psdata(1,:,:), nrOfWindows, handles);
        
            % save these to disk            
            % remove unnecessary garbage from the filename, non-elegant
            % brute-force way
            savename = strrep(savenameXLS, handles.path.excelOutDebug, '');
            savename = strrep(savename, '/', '');
            savename = strrep(savename, '\', '');
            savename = strrep(savename, '.xls', '.mat');
            savename = sprintf('%s%s', 'IAF_', savename);
            
            save(fullfile(handles.path.matFilesAlphaPeaks, savename), 'alphaPeak', 'alphaGravity', 'alphaVectors')
           
        
        % indivPeak

        % compute_EEG_perEpoch_withIndivAlphaPeak(ch, w, psdata(1,:,w), EEG_filt, EOG, handles.eegSet.artifactThr_eFixed, handles.eegSet.artifactThr_eEyeEOG, nrFreqPoints, noOfChannels, rs, wd, Fs, identifiers, handles)
        

