function dataOrganized = organize_byConditionSortParfor(dataOrganized_parfor, indexForCondition, savenameMAT, handles)
        
    % for faster debugging / developing
    if nargin == 0
        handles = init_defaultSettings();
        load(fullfile(handles.path.debugMatFiles, 'inSortAfterParfor.mat'))
        load('tempIndexForCondition.mat')
    else
        if handles.saveTempDebugMATs == 1
            save(fullfile(handles.path.debugMatFiles, 'inSortAfterParfor.mat'))
        end
    end        

    % This small function essentially just matches the output for the
    % required input of the next stage "organize_normalizeToTrialOne"
    % when the internal structure of the organze_byCondition was
    % changed to make it run inside a parfor -loop
        % dataOrganized{1}.subject{1}.bins{1}.trial{1}.period{1}.ch.data
        
    dataOrganized = cell(3,1); % dark/red/white

    % get the field, should be the same for all the files
    fieldsIn = fieldnames(dataOrganized_parfor{1}.bins{1}.ch); % e.g. powerSpectrum, PSD
    statFields = fieldnames(dataOrganized_parfor{1}.bins{1}.ch.(fieldsIn{1})); % e.g. aver, medianValue, SD, etc.

    for i = 1 : length(savenameMAT)
        
        disp([     'sorting the files, file: ', num2str(i), '/', num2str(length(savenameMAT))])

        subjectIndex = dataOrganized_parfor{i}.subject;
        trialIndex   = dataOrganized_parfor{i}.trial;
        periodIndex  = dataOrganized_parfor{i}.period;

        for binsIndex = 1 : length(dataOrganized_parfor{i}.bins) % number of frequency bins
            
            numberOfChannels = length(dataOrganized_parfor{i}.bins{binsIndex}.ch);

            for fieldsInd = 1: length(fieldsIn) 

                for statFieldsInd = 1 : length(statFields)
                    
                    % bins that are averaged over the specified channels
                    if numberOfChannels == 1
                        dataOrganized{indexForCondition(i)}.subject{subjectIndex}.bins{binsIndex}.trial{trialIndex}.period{periodIndex}.ch.(fieldsIn{fieldsInd}).(statFields{statFieldsInd}) = ...
                            dataOrganized_parfor{i}.bins{binsIndex}.ch.(fieldsIn{fieldsInd}).(statFields{statFieldsInd});    
                        
                        
                        % debug for the indices
                        if subjectIndex == 77
                            numberOfChannels
                            [i indexForCondition(i) subjectIndex binsIndex trialIndex periodIndex fieldsInd statFieldsInd]
                            a1 = statFields{statFieldsInd}
                            a2 = fieldsIn{fieldsInd}
                            b1 = dataOrganized_parfor{i}
                            b3 = dataOrganized_parfor{i}.bins{binsIndex}
                            b4 = dataOrganized_parfor{i}.bins{binsIndex}.ch.(fieldsIn{fieldsInd})                            
                            b2 = dataOrganized_parfor{i}.bins{binsIndex}.ch.(fieldsIn{fieldsInd}).(statFields{statFieldsInd})
                        end

                        
                    % for 0.5 Hz and 1 Hz frequency bins
                    else
                        for chIn = 1 : numberOfChannels
                           dataOrganized{indexForCondition(i)}.subject{subjectIndex}.bins{binsIndex}.trial{trialIndex}.period{periodIndex}.ch{chIn}.(fieldsIn{fieldsInd}).(statFields{statFieldsInd}) = ...
                                dataOrganized_parfor{i}.bins{binsIndex}.ch{chIn}.(fieldsIn{fieldsInd}).(statFields{statFieldsInd}); 
                            
                            % debug for the indices
                            if subjectIndex == 77
                                numberOfChannels
                                [i indexForCondition(i) subjectIndex binsIndex trialIndex periodIndex fieldsInd statFieldsInd]
                                a1 = statFields{statFieldsInd}
                                a2 = fieldsIn{fieldsInd}
                                b1 = dataOrganized_parfor{i}
                                b3 = dataOrganized_parfor{i}.bins{binsIndex}
                                b4 = dataOrganized_parfor{i}.bins{binsIndex}.ch{chIn}.(fieldsIn{fieldsInd})                            
                                b2 = dataOrganized_parfor{i}.bins{binsIndex}.ch{chIn}.(fieldsIn{fieldsInd}).(statFields{statFieldsInd})
                            end
                        end
                    end

                end % statFields
            end % fields                
        end % bins
    end % filenames

    %matFileName = 'dataOrg_mat_1stPass.mat';
    %save(fullfile(handles.path.organizeMatFiles, matFileName), 'dataOrganized')


