% normalizes the power to the first trial 
function norm = organize_normalizeToTrialOne(dataOrganized, handles)

    % PT (12 March 2013), some repetition on this, put inside functions

    % for faster debugging / developing
    if nargin == 0
        handles = init_defaultSettings();
        load(fullfile(handles.path.debugMatFiles, 'tempToNormalize.mat'))
    else
        if handles.saveTempDebugMATs == 1
            save(fullfile(handles.path.debugMatFiles, 'tempToNormalize.mat'))
        end
    end
    
    % get data fields stored to the bins
    % e.g. (fieldsIn{fieldsInd})trum, (fieldsIn{fieldsInd})tralDensity, "dummy"
    try
        fieldsIn = fieldnames(dataOrganized{1}.subject{1}.bins{1}.trial{1}.period{1}.ch);
    catch err
        err        
        dataOrganized{1}.subject{1}.bins{1}.trial{1}.period{1}
        dataOrganized{1}.subject{1}.bins{1}.trial{1}.period{1}.ch
        dataOrganized{1}.subject{1}.bins{1}.trial{1}.period{1}.ch.powerSpectrum
    end

    %% INSPECT the INPUT DATA
    
        % dataOrganized
        % dataOrganized
        % dataOrganized.subject{1}
        % dataOrganized.subject{1}.bins{1}
        % dataOrganized.subject{1}.bins{1}.trial{1}
        % dataOrganized.subject{1}.bins{1}.trial{1}.period{1}
        % dataOrganized.subject{1}.bins{1}.trial{1}.period{1}.ch

        if handles.showDebugMessages == 1
            disp('NORMALIZE: (1st subject, 1st condition, bin 1, trial 1, period 1')
            dataOrganized{1}.subject{1}.bins{1}.trial{1}.period{1}.ch.(fieldsIn{fieldsInd})
        end

        % now here you have for example 148 data points corresponding to the
        % "epochs" or time windows, so power spectrum as a function of time for
        % the given frequency range
        % A = dataOrganized{1}.subject{1}.bins{1}.trial{1}.period{1}.ch.(fieldsIn{1}).aver
        
        % assign the input to the output
        % now the only change to the input in this functions happens to the
        % mean power spectra (.aver) and the standard deviation (.SD)
        norm = dataOrganized;
    
    %% NORMALIZE THE DATA
        
        % In the previous implementation (data was normalized to the first
        % trial, RUN_BASIC_EEG.m)

        % So go again through the data, note now referring to the first {1}
        % cell element of each structure, this should be correct if the
        % previous code works as planned. So if the code starts crashing here,
        % it is a good way to debug the previous code as well. As the data
        % lengths should be the same

        
        for i = 1 : length(dataOrganized) % no of conditions, i.e. 3 with WHITE / RED / DARK                                 
            norm{i} = organize_normParforLoop(i, norm{i}, fieldsIn, handles);
        end
        
            % actually the parfor jams the MATLAB, so just your ordinary
            % FOR here
        
        
    %% SUBFUNCTION FOR PAR LOOP    
    function norm = organize_normParforLoop(i, norm, fieldsIn, handles)
    
        if i == 1; disp(' '); end
        disp(['        normalizing data for condition = ',  handles.colorConditionCell{i}])

        for fieldsInd = 1 : length(fieldsIn)

            for ij = 1 : length(norm.subject) % number of different subjects tested

                for j = 1 : length(norm.subject{1}.bins) % so as many frequency bins there were

                    for k = 1 : length(norm.subject{1}.bins{1}.trial) % number of trials                 

                        for l = 1 : length(norm.subject{1}.bins{1}.trial{1}.period) % number of different periods 
                            
                            %% check if there is some channels saved at all
                            % (when some period is not for example done for
                            % the subject, the .ch could be empty)
                            try
                                containsChannels = ~isempty(norm.subject{ij}.bins{j}.trial{k}.period{l});
                            catch err
                                err
                                [i fieldsInd ij j k l] % debug indices
                            end

                                if containsChannels == 1
                                    nrOfChannelsIn = length(norm.subject{ij}.bins{j}.trial{k}.period{l}.ch);
                                else
                                    warning(['No channels for subject index=', num2str(ij), ', trial = ', num2str(k), ', period = ', num2str(l)])
                                    nrOfChannelsIn = NaN;
                                end


                            %% GET THE NORMALIZATION VALUE

                                %% for first trial (k == 1)
                                if k == 1 

                                    % for the "defined" bands such as alpha,
                                    % beta, etc. we know from which channels
                                    % average the response from, thus the size
                                    % of the .ch is 1, whereas for "generic
                                    % bins" (see initDefaultSettings.m) there
                                    % are more channels (for example Oz, Pz,
                                    % etc.), thus we need a condition to take
                                    % care of that                               

                                    if nrOfChannelsIn == 1 % the "defined bands"
                                           % (fieldsIn{fieldsInd}) here already is a mean
                                           % of Pz and Oz locations, depends on
                                           % the definitions on
                                           % init_defaultSettings.m

                                        % mean
                                        averVector = norm.subject{ij}.bins{j}.trial{k}.period{l}.ch.(fieldsIn{fieldsInd}).aver;
                                        normValueAver = nanmean(averVector);

                                        % median
                                        medianVector = norm.subject{ij}.bins{j}.trial{k}.period{l}.ch.(fieldsIn{fieldsInd}).medianValue;
                                        normValueMedian = nanmean(medianVector);

                                        % assign to structure                                        
                                        normFactorAver = normValueAver;
                                        normFactorMedian = normValueMedian;
                                        
                                        % disp(l)
                                        % a1 = norm.subject{ij}.bins{j}.trial{k}.period{l}.ch.(fieldsIn{fieldsInd})
                                            % get the mean of the vector
                                            % containing the data points (different
                                            % time points), of the first trial
                                            % so that mean of all the data points of first trial 
                                            % should be 1 (the previous code by
                                            % R. Hamner)

                                    elseif nrOfChannelsIn > 1 % many channels                   

                                        % nrOfDataPoints = length(norm.subject{ij}.bins{j}.trial{k}.period{l}.ch{1}.(fieldsIn{fieldsInd}).aver);

                                        % go through the channels
                                        for ki = 1 : nrOfChannelsIn

                                            % mean
                                            averVector = norm.subject{ij}.bins{j}.trial{k}.period{l}.ch{ki}.(fieldsIn{fieldsInd}).aver;
                                            normValueAver = nanmean(averVector);

                                            % median
                                            medianVector = norm.subject{ij}.bins{j}.trial{k}.period{l}.ch{ki}.(fieldsIn{fieldsInd}).medianValue;                                                                                                                                    
                                            normValueMedian = nanmean(medianVector);

                                            % assign to structure
                                            normFactorAverCh{ki} = normValueAver;
                                            normFactorMedianCh{ki} = normValueMedian;

                                        end

                                    else

                                        norm.subject{ij}.bins{j}.trial{k}.period{l}.normFactor = NaN;
                                        warning('no norm factor')

                                    end

                                    % DEBUG
                                    if handles.showDebugMessages == 1 && l == 1 && j == 1 && k == 3 && nrOfChannelsIn == 1
                                       % for first period (l), and for first band (j)
                                       disp(['Trial = ', num2str(k-2), ', NormAver: ', num2str(normValueAver), ...
                                              ', Mean = ', num2str(nanmean(norm.subject{ij}.bins{j}.trial{k-2}.period{l}.ch.(fieldsIn{fieldsInd}).aver))])
                                       disp(['Trial = ', num2str(k-2), ', NormAver: ', num2str(normValueAver), ...
                                              ', Mean = ', num2str(nanmean(norm.subject{ij}.bins{j}.trial{k-1}.period{l}.ch.(fieldsIn{fieldsInd}).aver))])
                                       disp(['Trial = ', num2str(k-2), ', NormAver: ', num2str(normValueAver), ...
                                              ', Mean = ', num2str(nanmean(norm.subject{ij}.bins{j}.trial{k}.period{l}.ch.(fieldsIn{fieldsInd}).aver))])
                                    end


                                %% for trial 2 and 3, etc.        
                                elseif k > 1 

                                    % save the normFactor for all the
                                    % different bins using the value
                                    % computed for "k == 1"
                                    indexForNormValue = 1; % first trial

                                    if nrOfChannelsIn == 1 % the "defined bands"                                                                                                      
                                        
                                        % a3 = norm.subject{ij}.bins{j}.trial{indexForNormValue}.period{l}.ch.(fieldsIn{fieldsInd})

                                        %normValueAver = norm.subject{ij}.bins{j}.trial{indexForNormValue}.period{l}.ch.(fieldsIn{fieldsInd}).normFactorAver;
                                        %normValueMedian = norm.subject{ij}.bins{j}.trial{indexForNormValue}.period{l}.ch.(fieldsIn{fieldsInd}).normFactorMedian;

                                        %norm.subject{ij}.bins{j}.trial{k}.period{l}.ch.(fieldsIn{fieldsInd}).normFactorAver = normValueAver;
                                        %norm.subject{ij}.bins{j}.trial{k}.period{l}.ch.(fieldsIn{fieldsInd}).normFactorMedian = normValueMedian;

                                    elseif nrOfChannelsIn > 1 % many channels (like                                   

                                        % go through the channels
                                        for ki = 1 : nrOfChannelsIn

                                            %normValueAver = norm.subject{ij}.bins{j}.trial{indexForNormValue}.period{l}.ch{ki}.(fieldsIn{fieldsInd}).normFactorAver{ki};
                                            %normValueMedian = norm.subject{ij}.bins{j}.trial{indexForNormValue}.period{l}.ch{ki}.(fieldsIn{fieldsInd}).normFactorMedian{ki};

                                            %norm.subject{ij}.bins{j}.trial{k}.period{l}.ch{ki}.(fieldsIn{fieldsInd}).normFactorAver{ki} = normValueAver;
                                            %norm.subject{ij}.bins{j}.trial{k}.period{l}.ch{ki}.(fieldsIn{fieldsInd}).normFactorMedian{ki} = normValueMedian;

                                        end

                                    end

                                    % DEBUG
                                    if handles.showDebugMessages == 1 && l == 1 && j == 1 && k == 3 && nrOfChannelsIn == 1
                                       % for first period (l), and for first band (j)
                                       disp(['Trial = ', num2str(k-2), ', NormAver: ', num2str(normValueAver), ...
                                              ', Mean = ', num2str(nanmean(norm.subject{ij}.bins{j}.trial{k-2}.period{l}.ch.(fieldsIn{fieldsInd}).aver))])
                                       disp(['Trial = ', num2str(k-2), ', NormAver: ', num2str(normValueAver), ...
                                              ', Mean = ', num2str(nanmean(norm.subject{ij}.bins{j}.trial{k-1}.period{l}.ch.(fieldsIn{fieldsInd}).aver))])
                                       disp(['Trial = ', num2str(k-2), ', NormAver: ', num2str(normValueAver), ...
                                              ', Mean = ', num2str(nanmean(norm.subject{ij}.bins{j}.trial{k}.period{l}.ch.(fieldsIn{fieldsInd}).aver))])
                                    end

                                end


                            %% NORMALIZE THE DATA THEN USING THE VALUE COMPUTED ABOVE

                                if nrOfChannelsIn == 1 % the "defined bands"

                                    % normFactorAver   = norm.subject{ij}.bins{j}.trial{k}.period{l}.ch.(fieldsIn{fieldsInd}).normFactorAver;
                                    % normFactorMedian = norm.subject{ij}.bins{j}.trial{k}.period{l}.ch.(fieldsIn{fieldsInd}).normFactorMedian;

                                    % use subfunction
                                    norm.subject{ij}.bins{j}.trial{k}.period{l}.ch ...
                                        = organize_normalizeLowLevel(norm.subject{ij}.bins{j}.trial{k}.period{l}.ch, normFactorAver, normFactorMedian, fieldsIn{fieldsInd});

                                elseif nrOfChannelsIn > 1

                                    % go through the channels
                                    for ki = 1 : nrOfChannelsIn

                                        % normFactorAver   = norm.subject{ij}.bins{j}.trial{k}.period{l}.ch{ki}.(fieldsIn{fieldsInd}).normFactorAver{ki};
                                        % normFactorMedian = norm.subject{ij}.bins{j}.trial{k}.period{l}.ch{ki}.(fieldsIn{fieldsInd}).normFactorMedian{ki};

                                        % use subfunction
                                        norm.subject{ij}.bins{j}.trial{k}.period{l}.ch{ki} ...
                                            = organize_normalizeLowLevel(norm.subject{ij}.bins{j}.trial{k}.period{l}.ch{ki}, normFactorAver, normFactorMedian, fieldsIn{fieldsInd});                                       

                                    end

                                else
                                    norm.subject{ij}.bins{j}.trial{k}.period{l}.ch.(fieldsIn{fieldsInd}).aver        = NaN;
                                    norm.subject{ij}.bins{j}.trial{k}.period{l}.ch.(fieldsIn{fieldsInd}).SD          = NaN;
                                    norm.subject{ij}.bins{j}.trial{k}.period{l}.ch.(fieldsIn{fieldsInd}).medianValue = NaN;
                                    norm.subject{ij}.bins{j}.trial{k}.period{l}.ch.(fieldsIn{fieldsInd}).SD          = NaN;
                                    norm.subject{ij}.bins{j}.trial{k}.period{l}.ch.(fieldsIn{fieldsInd}).SDmedian    = NaN;
                                    norm.subject{ij}.bins{j}.trial{k}.period{l}.ch.(fieldsIn{fieldsInd}).N           = Nan;
                                    norm.subject{ij}.bins{j}.trial{k}.period{l}.ch.(fieldsIn{fieldsInd}).normFactorAver   = NaN;
                                    norm.subject{ij}.bins{j}.trial{k}.period{l}.ch.(fieldsIn{fieldsInd}).normFactorMedian = Nan;                                    
                                    warning('no norm factor')
                                end

                        end % l        
                    end % k                                       

                end % j
            end % ij
        end % fieldInd


    %% Subfunctions for normalization     
    function structureOut = organize_normalizeLowLevel(structureIn, normFactorAver, normFactorMedian, fieldIn)

        % use more human-readable variable
        % names for input data
        averPower_in = structureIn.(fieldIn).aver; 
        medianPower_in = structureIn.(fieldIn).medianValue;
        sdPower_in   = structureIn.(fieldIn).SD;       
        
        structureOut = structureIn;

        % normalize
        averPower_out = averPower_in / normFactorAver;
        medianPower_out = medianPower_in / normFactorMedian; 
        sdPower_out   = sdPower_in   / normFactorAver;
        sdPower_outMedian   = sdPower_in   / normFactorMedian;

        % and now assign to the output cell/structure "monster"
        structureOut.(fieldIn).aver = averPower_out;
        structureOut.(fieldIn).medianValue = medianPower_out;
        structureOut.(fieldIn).SD = sdPower_out;
        structureOut.(fieldIn).SDmedian = sdPower_outMedian;
        structureOut.(fieldIn).N = structureIn.(fieldIn).N;

