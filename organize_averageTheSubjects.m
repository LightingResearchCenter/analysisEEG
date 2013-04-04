function subjAve = organize_averageTheSubjects(dataIn, handles)

    % for faster debugging / developing
    if nargin == 0
        handles = init_defaultSettings();
        load(fullfile(handles.path.debugMatFiles, 'tempAverageSubjects.mat'))
    else
        if handles.saveTempDebugMATs == 1
            save(fullfile(handles.path.debugMatFiles, 'tempAverageSubjects.mat'))
        end
    end
    
    % get data fields stored to the bins
    % e.g. (fieldsIn{fieldsInd})trum, (fieldsIn{fieldsInd})tralDensity, "dummy"
    try
        fieldsIn = fieldnames(dataIn{1}.subject{1}.bins{1}.period{1}.ch);
        statFields = fieldnames(dataIn{1}.subject{1}.bins{1}.period{1}.ch.(fieldsIn{1})); % e.g. aver, medianValue, SD, etc.
    catch err
        err        
    end

   
     %% INSPECT the INPUT DATA
    
        % the input data is now in the same format as in for the
        % subfunction organize_normalizeToTrialOne(), now the power spectra
        % have only been scaled to unity for the first trial
     
        %         dataIn
        %         dataIn{1}.subject{1}
        %         dataIn{1}.subject{1}.bins{1}
        %         dataIn{1}.subject{1}.bins{1}.period{1}
        %         dataIn{1}.subject{1}.bins{1}.period{1}.ch
        %         dataIn{1}.subject{1}.bins{1}.period{1}.ch.powerSpectrum

        % now here you have for example 149 data points corresponding to the
        % "epochs" or time windows, so power spectrum as a function of time for
        % the given frequency range
        % A = dataIn{1}.subject{1}.bins{1}.period{1}.ch.(fieldsIn{1})
        
        
    %% Go through the data
        
        for i = 1 : length(dataIn) % no of conditions, i.e. 3 with WHITE / RED / DARK           
           
            disp(['        averaging subjects for condition = ',  handles.colorConditionCell{i}])

            for j = 1 : length(dataIn{1}.subject{1}.bins) % so as many frequency bins there were

                for l = 1 : length(dataIn{1}.subject{1}.bins{1}.period) % number of different periods                    
                    
                    for ij = 1 : length(dataIn{1}.subject) % number of different subjects tested
                        
                        for fieldsInd = 1 : length(fieldsIn)

                            % for statFieldsInd = 1 : length(statFields) % not used atm, update the code maybe at some point

                                %% INPUT CHECK

                                % check if there is some channels saved at all
                                % (when some period is not for example done for
                                % the subject, the .ch could be empty)
                                containsChannels = ~isempty(dataIn{i}.subject{ij}.bins{j}.period{l});

                                    if containsChannels == 1
                                        nrOfChannelsIn = length(dataIn{i}.subject{ij}.bins{j}.period{l}.ch);
                                    else
                                        warning(['No channels for subject index=', num2str(ij), ', period = ', num2str(l)])
                                        nrOfChannelsIn = NaN;
                                    end

                                %% ACCUMULATE
                                if nrOfChannelsIn == 1 % the "defined bands"

                                    % human readable variable names
                                    averVector = dataIn{i}.subject{ij}.bins{j}.period{l}.ch.(fieldsIn{fieldsInd}).aver;
                                    sdVector   = dataIn{i}.subject{ij}.bins{j}.period{l}.ch.(fieldsIn{fieldsInd}).SD;
                                    
                                    
                                    % accumulate these to a matrix
                                    meanMatrixAccum.(fieldsIn{fieldsInd})(ij,:) = averVector;
                                    sdMatrixAccum.(fieldsIn{fieldsInd})(ij,:)   = sdVector;

                                elseif nrOfChannelsIn > 1       

                                    % go through the channels
                                    for ki = 1 : nrOfChannelsIn
                                        powerMatrix_meanCh{ki}.(fieldsIn{fieldsInd})(ij,:) = dataIn{i}.subject{ij}.bins{j}.period{l}.ch{ki}.(fieldsIn{fieldsInd}).aver;
                                        powerMatrix_SDCh{ki}.(fieldsIn{fieldsInd})(ij,:) = dataIn{i}.subject{ij}.bins{j}.period{l}.ch{ki}.(fieldsIn{fieldsInd}).SD;
                                    end

                                else

                                end
                            % end
                        end % fieldsInd

                    end % subjects

                    %% AVERAGE & STATS
                    
                     for fieldsInd = 1 : length(fieldsIn)

                        for statFieldsInd = 1 : length(statFields) % not used atm, update the code maybe at some point

                            % after going through all the trials and
                            % accumulating those matrices, we can calculate the
                            % new stats for the power spectrum

                            % the "defined bands"
                            if nrOfChannelsIn == 1 

                                meanVector = nanmean(meanMatrixAccum.(fieldsIn{fieldsInd}));
                                sdOfMeans  = nanstd(meanMatrixAccum.(fieldsIn{fieldsInd}));

                                % calculate the square root of summed
                                % squared SDs
                                sqrtOfSquareSum = organize_sqrtSumOfSDs(sdOfMeans, sdMatrixAccum.(fieldsIn{fieldsInd}));

                                % Assign to output
                                subjAve{i}.bins{j}.period{l}.ch.(fieldsIn{fieldsInd}).aver = ...
                                    meanVector;

                                subjAve{i}.bins{j}.period{l}.ch.(fieldsIn{fieldsInd}).SD   = ...
                                    sqrtOfSquareSum;

                                subjAve{i}.bins{j}.period{l}.ch.(fieldsIn{fieldsInd}).N    = ...
                                    dataIn{i}.subject{ij}.bins{j}.period{l}.ch.(fieldsIn{fieldsInd}).N;
                                
                                %% LACKING MEDIANS


                            % generic bins
                            elseif nrOfChannelsIn > 1  

                                % go through the channels
                                for ki = 1 : nrOfChannelsIn

                                    % powerMatrix_meanCh
                                    meanVectorCh{ki}  = nanmean(powerMatrix_meanCh{ki}.(fieldsIn{fieldsInd}));
                                    sdOfMeansCh{ki}   = nanstd(powerMatrix_meanCh{ki}.(fieldsIn{fieldsInd}));

                                    % calculate the square root of summed
                                    % squared SDs
                                    sqrtOfSquareSum = organize_sqrtSumOfSDs(sdOfMeansCh{ki}, powerMatrix_SDCh{ki}.(fieldsIn{fieldsInd}));

                                    % Assign to output
                                    subjAve{i}.bins{j}.period{l}.ch{ki}.(fieldsIn{fieldsInd}).aver = ...
                                        meanVectorCh;

                                    subjAve{i}.bins{j}.period{l}.ch{ki}.(fieldsIn{fieldsInd}).SD   = ...
                                        sqrtOfSquareSum;

                                    subjAve{i}.bins{j}.period{l}.ch{ki}.(fieldsIn{fieldsInd}).N    = ...
                                        dataIn{i}.subject{ij}.bins{j}.period{l}.ch{ki}.(fieldsIn{fieldsInd}).N;
                                    
                                    %% LACKING MEDIANS


                                end                                

                            else

                            end
                        end
                     end                        
                end
            end
        end