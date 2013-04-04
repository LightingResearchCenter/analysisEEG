function trialAve = organize_averageTheTrials(dataIn, handles)

    % for faster debugging / developing
    if nargin == 0
        handles = init_defaultSettings();
        load(fullfile(handles.path.debugMatFiles, 'tempToAverageTrials.mat'))
    else
        if handles.saveTempDebugMATs == 1
            save(fullfile(handles.path.debugMatFiles, 'tempToAverageTrials.mat'))
        end
    end

    % get data fields stored to the bins
    % e.g. (fieldsIn{fieldsInd})trum, (fieldsIn{fieldsInd})tralDensity, "dummy"
    try
        fieldsIn = fieldnames(dataIn{1}.subject{1}.bins{1}.trial{1}.period{1}.ch);
        statFields = fieldnames(dataIn{1}.subject{1}.bins{1}.trial{1}.period{1}.ch.(fieldsIn{1})); % e.g. aver, medianValue, SD, etc.
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
        %         dataIn{1}.subject{1}.bins{1}.trial{1}
        %         dataIn{1}.subject{1}.bins{1}.trial{1}.period{1}
        %         dataIn{1}.subject{1}.bins{1}.trial{1}.period{1}.ch.(fieldsIn{1})

        % now here you have for example 149 data points corresponding to the
        % "epochs" or time windows, so power spectrum as a function of time for
        % the given frequency range
        A = dataIn{1}.subject{1}.bins{1}.trial{1}.period{1}.ch.powerSpectrum;
        
        % This refers to the trial index to start accumulating for
        % calculating the average. And now when the first trial is the
        % "dark baseline", only the 2nd and 3rd trial are averaged
        trialstartIndex = 2;
        
        % for some subjects, there is not 2.5 minutes of recording
        hardCodedNoOfWindows = 149;
        NaNVector = zeros(hardCodedNoOfWindows,1);
        NaNVector(:) = NaN;
        
    %% Go through the data
    
        trialAve = cell(length(handles.colorConditionCell),1);
        
        for i = 1 : length(dataIn) % no of conditions, i.e. 3 with WHITE / RED / DARK           
           
            if i == 1; disp(' '); end
            disp(['        averaging trials for condition = ',  handles.colorConditionCell{i}])
            
            for ij = 1 : length(dataIn{1}.subject) % number of different subjects tested

                for j = 1 : length(dataIn{1}.subject{1}.bins) % so as many frequency bins there were
                    
                    for l = 1 : length(dataIn{1}.subject{1}.bins{1}.trial{1}.period) % number of different periods                    
                        
                        for k = trialstartIndex : length(dataIn{1}.subject{1}.bins{1}.trial) % number of trials
                            
                            ind = k - (trialstartIndex - 1);
                            
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

                                    %% ACCUMULATE

                                        if nrOfChannelsIn == 1 % the "defined bands"

                                            % accumulate the values from different
                                            % trials to a matrix
                                            averVector = dataIn{i}.subject{ij}.bins{j}.trial{k}.period{l}.ch.(fieldsIn{fieldsInd}).aver;
                                            medianVector = dataIn{i}.subject{ij}.bins{j}.trial{k}.period{l}.ch.(fieldsIn{fieldsInd}).medianValue;
                                            sdVector   = dataIn{i}.subject{ij}.bins{j}.trial{k}.period{l}.ch.(fieldsIn{fieldsInd}).SD;
                                            
                                            lengthOfVector = length(averVector);
                                            
                                            if lengthOfVector == hardCodedNoOfWindows
                                                powerMatrix_mean.(fieldsIn{fieldsInd})(ind,:) = averVector;
                                                powerMatrix_median.(fieldsIn{fieldsInd})(ind,:) = medianVector;
                                                powerMatrix_SD.(fieldsIn{fieldsInd})(ind,:) = sdVector;
                                            else
                                                if j == 1
                                                    disp(['          .. only ', num2str(length(averVector)), ' data samples! Padding with NaN values'])
                                                    disp(['                i=', num2str(i), ', j=', num2str(j), ', k=', num2str(k), ', l=', num2str(l), ', j=', num2str(ind)])
                                                end
                                                
                                                meanNaNPadded = NaNVector;
                                                    meanNaNPadded(1:length(averVector)) = averVector;
                                                medianNaNPadded = NaNVector;
                                                    medianNaNPadded(1:length(averVector)) = medianVector;
                                                sdNaNPadded = NaNVector;
                                                    sdNaNPadded(1:length(averVector)) = sdVector;
                                                    
                                                powerMatrix_mean.(fieldsIn{fieldsInd})(ind,:) = meanNaNPadded;
                                                powerMatrix_median.(fieldsIn{fieldsInd})(ind,:) = medianNaNPadded;
                                                powerMatrix_SD.(fieldsIn{fieldsInd})(ind,:) = sdNaNPadded;
                                                
                                            end

                                            % pause
                                            
                                        elseif nrOfChannelsIn > 1       

                                            % go through the channels
                                            for ki = 1 : nrOfChannelsIn
                                                
                                                lengthOfVector = length(dataIn{i}.subject{ij}.bins{j}.trial{k}.period{l}.ch{ki}.(fieldsIn{fieldsInd}).aver);
                                                
                                                if lengthOfVector == hardCodedNoOfWindows
                                                    powerMatrix_meanCh{ki}.(fieldsIn{fieldsInd})(ind,:) = dataIn{i}.subject{ij}.bins{j}.trial{k}.period{l}.ch{ki}.(fieldsIn{fieldsInd}).aver;
                                                    powerMatrix_medianCh{ki}.(fieldsIn{fieldsInd})(ind,:) = dataIn{i}.subject{ij}.bins{j}.trial{k}.period{l}.ch{ki}.(fieldsIn{fieldsInd}).medianValue;
                                                    powerMatrix_SDCh{ki}.(fieldsIn{fieldsInd})(ind,:) = dataIn{i}.subject{ij}.bins{j}.trial{k}.period{l}.ch{ki}.(fieldsIn{fieldsInd}).SD;
                                                else
                                                                                                        
                                                    % a = dataIn{i}.subject{ij}.bins{j}.trial{k}.period{l}.ch{ki}.(fieldsIn{fieldsInd}).aver
                                                    
                                                    % only one value for
                                                    % the multiple channels
                                                    if lengthOfVector > 100
                                                        if j == 1
                                                            disp(['          .. only ', num2str(lengthOfVector), ' data samples! MultipChannels, Padding with NaN values'])
                                                            disp(['                i=', num2str(i), ', j=', num2str(j), ', k=', num2str(k), ', l=', num2str(l), ', ind=', num2str(ind)])
                                                        end
                                                    end

                                                    meanNaNPadded = NaNVector;
                                                        meanNaNPadded(1:lengthOfVector) = dataIn{i}.subject{ij}.bins{j}.trial{k}.period{l}.ch{ki}.(fieldsIn{fieldsInd}).aver;
                                                    medianNaNPadded = NaNVector;
                                                        medianNaNPadded(1:lengthOfVector) = dataIn{i}.subject{ij}.bins{j}.trial{k}.period{l}.ch{ki}.(fieldsIn{fieldsInd}).medianValue;
                                                    sdNaNPadded = NaNVector;
                                                        sdNaNPadded(1:lengthOfVector) = dataIn{i}.subject{ij}.bins{j}.trial{k}.period{l}.ch{ki}.(fieldsIn{fieldsInd}).SD;

                                                    powerMatrix_meanCh{ki}.(fieldsIn{fieldsInd})(ind,:) = meanNaNPadded;
                                                    powerMatrix_medianCh{ki}.(fieldsIn{fieldsInd})(ind,:) = medianNaNPadded;
                                                    powerMatrix_SDCh{ki}.(fieldsIn{fieldsInd})(ind,:) = sdNaNPadded;
                                                    
                                                    %pause
                                                end
                                            end

                                        else

                                        end                
                                        
                            end
                            
                        end
                        
                        for fieldsInd = 1 : length(fieldsIn)
                                
                            % for statFieldsInd = 1 : length(statFields) % not used atm, update the code maybe at some point
                        
                                %% AVERAGE

                                % after going through all the trials and
                                % accumulating those matrices, we can calculate the
                                % new stats for the power spectrum

                                % the "defined bands"
                                if nrOfChannelsIn == 1 

                                    % powerMatrix_mean
                                    %fieldsInd
                                    meanOfMatrix = nanmean(powerMatrix_mean.(fieldsIn{fieldsInd}));
                                    medianMatrix = nanmean(powerMatrix_median.(fieldsIn{fieldsInd}));
                                    sdOfMatrix   = nanstd(powerMatrix_mean.(fieldsIn{fieldsInd}));

                                        %pause

                                    % calculate the square root of summed
                                    % squared SDs
                                    sqrtOfSquareSum = organize_sqrtSumOfSDs(sdOfMatrix, powerMatrix_SD.(fieldsIn{fieldsInd}));           

                                    N = length(powerMatrix_mean);

                                    % MANUAL CHECK
                                    % if the mean of trials is 1.000, then it
                                    % is apparently an outlier, correct laster
                                    % the []
                                    [meanOfMatrix, medianMatrix, sqrtOfSquareSum, SD, N] = organize_manualSubjectReject(i, ij, k, j, l, meanOfMatrix, medianMatrix, sqrtOfSquareSum, sdOfMatrix, N);

                                    % Assign to output
                                    trialAve{i}.subject{ij}.bins{j}.period{l}.ch.(fieldsIn{fieldsInd}).aver = meanOfMatrix;
                                    trialAve{i}.subject{ij}.bins{j}.period{l}.ch.(fieldsIn{fieldsInd}).medianValue = medianMatrix; 
                                    trialAve{i}.subject{ij}.bins{j}.period{l}.ch.(fieldsIn{fieldsInd}).SD = SD;
                                        trialAve{i}.subject{ij}.bins{j}.period{l}.ch.(fieldsIn{fieldsInd}).SD_rms = sqrtOfSquareSum;
                                    trialAve{i}.subject{ij}.bins{j}.period{l}.ch.(fieldsIn{fieldsInd}).N = N;                                

                                % generic bins
                                elseif nrOfChannelsIn > 1  

                                    % go through the channels
                                    for ki = 1 : nrOfChannelsIn

                                        % powerMatrix_meanCh
                                        meanOfMatrixCh{ki} = nanmean(powerMatrix_meanCh{ki}.(fieldsIn{fieldsInd}));
                                        medianOfMatrixCh{ki} = nanmean(powerMatrix_medianCh{ki}.(fieldsIn{fieldsInd}));
                                        sdOfMatrixCh{ki}   = nanstd(powerMatrix_meanCh{ki}.(fieldsIn{fieldsInd}));

                                        % calculate the square root of summed
                                        % squared SDs
                                        sqrtOfSquareSum = organize_sqrtSumOfSDs(sdOfMatrixCh{ki}, powerMatrix_SDCh{ki}.(fieldsIn{fieldsInd}));

                                        N = length(powerMatrix_meanCh{ki});

                                        % MANUAL CHECK
                                        % if the mean of trials is 1.000, then it
                                        % is apparently an outlier
                                        [meanOfMatrix, medianMatrix, sqrtOfSquareSum, SD, N] = organize_manualSubjectReject(i, ij, k, j, l, meanOfMatrixCh{ki}, medianOfMatrixCh{ki}, sqrtOfSquareSum, sdOfMatrixCh{ki}, N);

                                        % Assign to output
                                        trialAve{i}.subject{ij}.bins{j}.period{l}.ch{ki}.(fieldsIn{fieldsInd}).aver = meanOfMatrix;
                                        trialAve{i}.subject{ij}.bins{j}.period{l}.ch{ki}.(fieldsIn{fieldsInd}).medianValue = medianMatrix;
                                        trialAve{i}.subject{ij}.bins{j}.period{l}.ch{ki}.(fieldsIn{fieldsInd}).SD = SD;
                                            trialAve{i}.subject{ij}.bins{j}.period{l}.ch{ki}.(fieldsIn{fieldsInd}).SD_rms = sqrtOfSquareSum;
                                        trialAve{i}.subject{ij}.bins{j}.period{l}.ch{ki}.(fieldsIn{fieldsInd}).N = N;                                   

                                    end                                

                                else
                                    error('why goes here, how many channels?')

                                end

                           % end % statsFieldInd     
                           
                        end % fieldsInd
                        
                        % DEBUG
                        % ind
                        % trialAve{i}.subject{ij}.bins{j}.period{l}.ch
                        % trialAve{i}.subject{ij}.bins{j}.period{l}.ch.powerSpectrum.aver                                               
                        % pause
                        
                    end % l - period
                end % j - frequency bins 
            end % ij - subjects
        end % i - condition 