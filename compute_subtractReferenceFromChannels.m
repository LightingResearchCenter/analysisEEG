function EEG = compute_subtractReferenceFromChannels(Ref, eegDataRaw, noOfChannels)

    % Now make a MATRIX of the RAW EEG data so that:
    % SUBTRACT THE REFERENCE
    % rows - each data channel (7 with BDF)
    % columns - nSamples * nTrials
    % e.g. size for Levent: 7x333824
    
    EEG = zeros(noOfChannels,length(eegDataRaw));
    for c = 1: noOfChannels
        EEG(c,:) = eegDataRaw(c,:)-Ref;
    end