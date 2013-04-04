function indices = init_preComputeFrequencyIndices(freqsIn, freqVector, handles)
           
        if handles.eegBins.includeUpperLimit == 1

            indices ...
                   = find((freqVector >= freqsIn(1)) ... % lower limit included in the bin >=
                          & (freqVector <= freqsIn(2))); % upper limit included in the bin <=
        else
            indices ...
                   = find((freqVector >= freqsIn(1)) ... % lower limit not included in the bin >=
                          & (freqVector < freqsIn(2)));  % upper limit NOT included in the bin <
        end  