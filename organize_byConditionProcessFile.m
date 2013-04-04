% go through the files, wrapped for PARFOR LOOP
function dataOrganizedPerFile = organize_byConditionProcessFile(i, ps_bins, dataOrganizedPerFile, sub, period, color, condition, trial, session, path, handles)

    %% go through the different frequency bins stored to that
    
    % numberOfFreqBins = length(handles.eegBins.label); % won't work until alpha peaks are not fixed
    numberOfFreqBins = handles.indexToEndRatioBins;   
       
        
    %% indices for trial and period, are stored as numeric values in
    % the input "ps_bins"
    % k = ps_bins{1}{1}{1}.trial;
    % l = ps_bins{1}{1}{1}.period;
    kj = trial(i);
    lj = period(i);
    
    % get data fields stored to the bins
    % e.g. powerSpectrum, powerSpectralDensity, "dummy"
    try
        fieldsIn = fieldnames(ps_bins{1}{1}{1}.data);
    catch err % debug, should not go here with a working code
        err
        ch = 1; ps_bins{ch}{1}{1}
    end
    
    % assign the identifiers of the file
    subjectIndex = (sub(i) - min(sub)) + 1; 
    dataOrganizedPerFile.subject = subjectIndex;
    dataOrganizedPerFile.subjectLUT = sub;
    dataOrganizedPerFile.trial = kj;
    dataOrganizedPerFile.period = lj; 
    
    for fieldsInd = 1 : length(fieldsIn)

        for k = 1 : numberOfFreqBins % as many frequency bins as there were
                                     % defined in init_defaultSettings                         

            % different kind of processing now for general bins (that have
            % are meant to contain all the channels when being outputted),
            % and then for the traditional alpha / delta / theta / etc.
            % which are calculated from defined recording sites

            % Now do data reduction and compute the EEG band parameters
            % either for defined recording sites ("classical alpha / beta /
            % delta approach) or keep all recording sites for generic
            % frequency bins.
                % ch3 - EX3: Fz
                % ch4 - EX4: Cz
                % ch5 - EX5: Pz
                % ch6 - EX6: Oz

            % for different time windows
            numberOfWindows = max(size(ps_bins{1}));            

            %% ONLY ONE EEG CHANNEL (fixed bands % individual alpha)
            % Whereas here we have fixed freqency bands, individual bands,
            % ratio bands that only have one channel left (for example Fz and
            % Oz are averaged already to one channel
            if k < handles.indexToStart_1HzBins || (handles.indexToEndGeneralBins < k && k < handles.indexToStartRatioBins)

                % k1 = k % debug
                
                startInd = handles.eegBins.ch{k}(1);
                endInd = handles.eegBins.ch{k}(end);
             
                try
                    [aver, medianValue, SD, N] = organize_goThroughWindows(i,k,kj,lj,numberOfWindows,startInd,endInd,ps_bins,...
                                                            fieldsIn{fieldsInd},handles);                    
                    % vector in would be
                    % ps_bins{i}{j}{k}.data.(fieldsIn{fieldsInd}) 
                    % (j is now the epoch / window index which is used inside of a for loop)
                    
                    % aver
                    % pause
                    
                catch err
                    err
                    err.message
                    ch = 1; j = 1; 
                    [i k kj lj]                                        
                    ps_bins{ch}{j}{kj}
                end                
                    

                % After going through all the data windows (epochs) we
                % can assign the resulting vectors to the output cell
                % structure               
                dataOrganizedPerFile.bins{k}.ch.(fieldsIn{fieldsInd}).aver = aver;
                dataOrganizedPerFile.bins{k}.ch.(fieldsIn{fieldsInd}).medianValue = medianValue;
                dataOrganizedPerFile.bins{k}.ch.(fieldsIn{fieldsInd}).SD = SD;
                dataOrganizedPerFile.bins{k}.ch.(fieldsIn{fieldsInd}).N = N;       
                
                % dataOrganizedPerFile.bins{k}.ch
                % pause


            %% MULTIPLE EEG CHANNELS (0.5 and 1 Hz resolution general bins)
            % now for the general 0.5 Hz / 1 Hz bins we have all the 4 scalp
            % locations saved so we have to process them differentially        
            elseif k >= handles.indexToStart_1HzBins && handles.indexToEndGeneralBins >= k

                % k2 = k % debug
                % Now omit some channels for data reduction, you can change
                % this if later on you need these omitted channels
                % somewhere
                startInd = handles.eegBins.genericChannels(1);
                endInd = handles.eegBins.genericChannels(end);   

                    % now we have to check if the time bin for these
                    % indices actually contain some data, might not contain
                    % any data if the data was rejected as being full of
                    % artifacts                    
                    for o = startInd : endInd

                        % now feed the subfunction channel by channel
                        % so we never average channels with each other,
                        % but within the channel we get an average
                        [aver, medianValue, SD, N] = organize_goThroughWindows(i,k,kj,lj,numberOfWindows,startInd,endInd,ps_bins,...
                                                            fieldsIn{fieldsInd},handles);

                            %% PETTERI: Computational efficiency
                            % NOTE, THE CALL ABOVE TAKES MOST of the
                            % computation time as it called multiple times
                            % during the execution and especially nanstd and
                            % nanmedian are relatively quite slow. One option
                            % would be to accumulate the values to a matrix
                            % before computing the stats, but the problem is
                            % that the frequency bins are not the same size, so
                            % one would need to program some NaN-padding to
                            % compensate for this, check at some point if you
                            % tend to get annoyed for long computation time

                        channelIndex = o - startInd + 1;                      

                        dataOrganizedPerFile.bins{k}.ch{channelIndex}.(fieldsIn{fieldsInd}).aver = aver;
                        dataOrganizedPerFile.bins{k}.ch{channelIndex}.(fieldsIn{fieldsInd}).medianValue = medianValue;
                        dataOrganizedPerFile.bins{k}.ch{channelIndex}.(fieldsIn{fieldsInd}).SD = SD;
                        dataOrganizedPerFile.bins{k}.ch{channelIndex}.(fieldsIn{fieldsInd}).N = N;
                        dataOrganizedPerFile.bins{k}.ch{channelIndex}.chName = handles.eegBins.chName{o};                      

                    end % o

            %% FOR THE RATIO BINS
            elseif k >= handles.indexToStartRatioBins && k <= handles.indexToEndRatioBins
                
                % k3 = k % debug
                % now we have two "channels" for the EEG frequency ratio,
                % for example the channel 1 is ALPHA and the channel 2 is
                % THETA, so there are always only two channels as the
                % individual channels are calculated either from fixed
                % frequency bins or from individual alpha freq bins, for
                % details see "init_defineFrequencyBins" and
                % "compute_EEG_perFreqBands"
                
                ind = 1; % numerator (e.g. alpha)
                startInd(ind) = handles.eegBins.ch{k}{ind}(1);
                endInd(ind) = handles.eegBins.ch{k}{ind}(end);
                
                ind = 2; % denominator (e.g. theta)
                startInd(ind) = handles.eegBins.ch{k}{ind}(1);
                endInd(ind) = handles.eegBins.ch{k}{ind}(end);
                
                % a = fieldsIn{fieldsInd}
                [aver, medianValue, SD, N] = organize_goThroughWindows(i,k,kj,lj,numberOfWindows,startInd,endInd,ps_bins,...
                                                        fieldsIn{fieldsInd},handles);
                                                    
                %                 if k == 159
                %                     aver(1:10)
                %                     N(1:10)
                %                     pause
                %                 end                                                    

                dataOrganizedPerFile.bins{k}.ch.(fieldsIn{fieldsInd}).aver = aver;
                dataOrganizedPerFile.bins{k}.ch.(fieldsIn{fieldsInd}).medianValue = medianValue;
                dataOrganizedPerFile.bins{k}.ch.(fieldsIn{fieldsInd}).SD = SD;
                dataOrganizedPerFile.bins{k}.ch.(fieldsIn{fieldsInd}).N = N;                
             
                
            end % if j            
        end % k       
    end % fieldsIn
    