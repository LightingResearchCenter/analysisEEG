function trialMean = organize_averageForScalars(dataIn, handles)

    % for faster debugging / developing
    if nargin == 0
        handles = init_defaultSettings();
        load(fullfile(handles.path.debugMatFiles, 'tempToAverageScalars.mat'))
        whos
    else
        if handles.saveTempDebugMATs == 1
            save(fullfile(handles.path.debugMatFiles, 'tempToAverageScalars.mat'))
        end
    end
    
    % get data fields stored to the bins
    % e.g. (fieldsIn{fieldsInd})trum, (fieldsIn{fieldsInd})tralDensity, "dummy"
    try
        fieldsIn = fieldnames(dataIn{1}.subject{1}.bins{1}.trial{1}.period{1}.ch)
        statFields = fieldnames(dataIn{1}.subject{1}.bins{1}.trial{1}.period{1}.ch.(fieldsIn{1})); % e.g. aver, medianValue, SD, etc.
    catch err
        err        
    end
    
     %% INSPECT the INPUT DATA
    
        % the input data is now in the same format as in for the
        % subfunction organize_normalizeToTrialOne(), now the power spectra
        % have only been scaled to unity for the first trial
     
        % dataIn
        % dataIn{1}.subject{1}
        % dataIn{1}.subject{1}.bins{1}
        % dataIn{1}.subject{1}.bins{1}.trial{1}
        % dataIn{1}.subject{1}.bins{1}.trial{1}.period{1}
        % dataIn{1}.subject{1}.bins{1}.trial{1}.period{1}.ch
        % dataIn{1}.subject{1}.bins{1}.trial{1}.period{1}.ch.powerSpec

        % now here you have for example 149 data points corresponding to the
        % "epochs" or time windows, so power spectrum as a function of time for
        % the given frequency range
        % A = dataIn{1}.subject{1}.bins{1}.trial{1}.period{1}.ch.powerSpec.aver;      
        
        % prellocate
        trialMean = cell(length(dataIn),1);
        
    %% Go through the data
        
        for i = 1 : length(dataIn) % no of conditions, i.e. 3 with WHITE / RED / DARK           
           
            if i == 1; disp(' '); end
            disp(['        averaging to scalars, for condition = ',  handles.colorConditionCell{i}])
            
            for ij = 1 : length(dataIn{1}.subject) % number of different subjects tested

                for j = 1 : length(dataIn{1}.subject{1}.bins) % so as many frequency bins there were              
                    
                    for l = 1 : length(dataIn{1}.subject{1}.bins{1}.trial{1}.period) % number of different periods                    
                        
                        for k = 1 : length(dataIn{1}.subject{1}.bins{1}.trial) % number of trials
                            
                            for fieldsInd = 1 : length(fieldsIn)

                                % for statFieldsInd = 1 : length(statFields) % not used atm, update the code maybe at some point
                            
                                    %% INPUT CHECK

                                        % check if there is some channels saved at all
                                        % (when some period is not for example done for
                                        % the subject, the .ch could be empty)
                                        containsChannels = ~isempty(dataIn{i}.subject{ij}.bins{j}.trial{k}.period{l});

                                            if containsChannels == 1
                                                nrOfChannelsIn = length(dataIn{i}.subject{ij}.bins{j}.trial{k}.period{l}.ch);
                                            else
                                                warning(['No channels for subject index=', num2str(ij), ', trial = ', num2str(k), ', period = ', num2str(l)])
                                                nrOfChannelsIn = NaN;
                                            end                           


                                    %% AVERAGE

                                        % after going through all the trials and
                                        % accumulating those matrices, we can calculate the
                                        % new stats for the power spectrum

                                        % the "defined bands"
                                        if nrOfChannelsIn == 1 

                                            % Get scalar stats from structure
                                                [aver, medianValue, sdOfMean, sdSqrtRMS, SD_rms, SD, N] = organize_averLowLevelStats(dataIn{i}.subject{ij}.bins{j}.trial{k}.period{l}.ch.(fieldsIn{fieldsInd}), fieldsIn{fieldsInd});    

                                                    % sdOfMean, sdSqrtRMS are
                                                    % intermediate results, and
                                                    % unused at the moment

                                                % MANUAL CHECK, if the mean of trials is 1.000, then it is apparently an outlier
                                                [aver, medianValue, SD_rms, SD, N] = organize_manualSubjectReject(i, ij, k, j, l, aver, medianValue, SD_rms, SD, N);

                                                % Assign to output
                                                trialMean{i}.subject{ij}.bins{j}.trial{k}.period{l}.ch.(fieldsIn{fieldsInd}) = organize_averLowLevelAssign(aver, medianValue, SD_rms, SD, N);


                                        % generic bins
                                        elseif nrOfChannelsIn > 1  

                                            % go through the channels
                                            for ki = 1 : nrOfChannelsIn

                                                % Get scalar stats from structure
                                                [aver, medianValue, sdOfMean, sdSqrtRMS, SD_rms, SD, N] = organize_averLowLevelStats(dataIn{i}.subject{ij}.bins{j}.trial{k}.period{l}.ch{ki}.(fieldsIn{fieldsInd}), fieldsIn{fieldsInd});    

                                                    % sdOfMean, sdSqrtRMS are
                                                    % intermediate results, and
                                                    % unused at the moment

                                                % MANUAL CHECK, if the mean of trials is 1.000, then it is apparently an outlier
                                                [aver, medianValue, SD_rms, SD, N] = organize_manualSubjectReject(i, ij, k, j, l, aver, medianValue, SD_rms, SD, N);

                                                % Assign to output
                                                trialMean{i}.subject{ij}.bins{j}.trial{k}.period{l}.ch{ki}.(fieldsIn{fieldsInd}) = organize_averLowLevelAssign(aver, medianValue, SD_rms, SD, N);

                                            end                                

                                        else

                                            warning('why are we here? how many EEG channels recorded?')

                                        end
                                % end
                            end
                        end                        
                    end
                end
            end
        end
        
        %         matFileName = 'dataOrg_mat_scalarAveraged.mat';
        %         disp(['          saving "', matFileName, '"'])
        %         save(fullfile(handles.path.organizeMatFiles, matFileName), 'trialMean')
        
        
                
    %% LOCAL SUBFUNCTIONS        
        
        % to get the scalars out from structure
        function [mean, medianValue, sdOfMean, sdSqrtRMS, SD_rms, SD, N] = organize_averLowLevelStats(structureIn, fieldIn)

            % structureIn
            
            mean = nanmean(structureIn.aver);
            medianValue = nanmedian(structureIn.medianValue);

            sdOfMean = nanstd(structureIn.aver);                                
            sdSqrtRMS = sqrt(sum((structureIn.SD).^2));

            SD_rms = sqrt(sum(sdOfMean^2 + sdSqrtRMS^2));  
            SD = sdOfMean;
            
            N = length(structureIn.aver(~isnan(structureIn.aver))); % remove NaNs
            
            
        % assign the scalars to structure
        function structureOut = organize_averLowLevelAssign(aver, medianValue, SD_rms, SD, N)
                                        
            structureOut.aver = aver;
            structureOut.medianValue = medianValue;

            structureOut.SD = SD;
            structureOut.SD_rms = SD_rms; % in practice, these SDs are huge

            structureOut.N = N;
           
           