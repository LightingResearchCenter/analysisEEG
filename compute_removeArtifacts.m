function filteredDataSegment = compute_removeArtifacts(ch, EEG_filt, EOG, artifactThr_eFixed, artifactThr_eEOG, nrFreqDataPoints, noOfChannels, rs, wd, Fs, w, handles)

    if handles.showDebugMessages == 1
        if ch == 1 && w == 1
            disp('compute_removeArtifacts')
            % plot(EEG_filt)
            whos
        end
    end
        
    % filteredDataSegment is temporary vector (?) for the data to be checked for 
    % artifacts (ee = ???), size e.g. 1x4096
    ind1 = rs*Fs*(w-1) + 1; % e.g. 1
    ind2 = rs*Fs*(w-1) + (wd*Fs); % e.g. 4096    
    filteredDataSegment = EEG_filt(ind1:ind2);
               
    % find the artifacts (positive voltage | negative voltage)
    artifacts_eFixed = find(filteredDataSegment >artifactThr_eFixed | filteredDataSegment < -1*artifactThr_eFixed);   
            
    % Fq is ???, size e.g. 1x4096, or 1x2049
    Fq = 0 : nrFreqDataPoints - 1;
    ff = Fq * (Fs ./ nrFreqDataPoints);    
   
    % bd is temporary vector (?) for the data to be checked for 
    % artifacts (ee = ???)
    % size e.g. 1x4096    
    ind1 = rs*Fs*(w-1) + 1; % e.g.
    ind2 = rs*Fs*(w-1) + (nrFreqDataPoints); % e.g. 2049            
    eogSegment = EOG(ind1:ind2);
    
    % find the artifacts (positive voltage | negative voltage)
    artifacts_eEOG = find(eogSegment > artifactThr_eEOG | eogSegment < -1*artifactThr_eEOG);
    
    % Change the data corresponding to the indices for
    % artifacts to NaN
    
        if artifacts_eFixed>=1 % ee threshold, e.g. 100 uV
           filteredDataSegment = NaN;           

        elseif artifacts_eEOG>=1 % EOG threshold, e.g. 40 uV
           filteredDataSegment = NaN;            

        else           

        end
        