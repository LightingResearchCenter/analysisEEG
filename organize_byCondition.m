% Organize the processed data BY CONDITION
function dataOrganized = organize_byCondition(savenameMAT, alldata_LUT, handles)    
    
    % for faster debugging / developing
    if nargin == 0
        localExec = 1;
        handles = init_defaultSettings();
        load(fullfile(handles.path.debugMatFiles, 'organizedCondition_temp.mat'))
        load(fullfile(handles.path.debugMatFiles, 'tempAfterParfor.mat'))
    else
        localExec = 0;
        if handles.saveTempDebugMATs == 1
            save(fullfile(handles.path.debugMatFiles, 'organizedCondition_temp.mat'))
        end
        dataOrganized_parfor = cell(length(savenameMAT), 1);        
        indexForCondition = zeros(length(savenameMAT),1);
    end    
    
    handles.colorConditionCell = {'Dark'; 'Red'; 'White'};
    
    %% Background information
    
        % The structure of the data in the .MAT file is the following

            % ch - channel index, (e.g. from 1 to 7)
            % w  - number of epochs (e.g. 148)
            % k  - number of different frequency bins (e.g. 169)
            %      see initDefaultSettings.m for definitions

            % EEG Bin settings
                % ps_bins{ch}{w}{k}.freqs
                % ps_bins{ch}{w}{k}.label
                % ps_bins{ch}{w}{k}.ch

                    % Now note that after the initial run, you can
                    % change the label channels freely, but the
                    % freqs affected on what frequencies were taken
                    % from the full Power Action spectrum.

            % EEG Freqs (in the bin), and the DATA
                % ps_bins{ch}{w}{k}.frequencies
                % ps_bins{ch}{w}{k}.data                    

            % IDENTIFIERS for the filename
                % ps_bins{ch}{w}{k}.filename
                % ps_bins{ch}{w}{k}.fileNameWoPath
                % ps_bins{ch}{w}{k}.sub
                % ps_bins{ch}{w}{k}.period
                % ps_bins{ch}{w}{k}.trial
                % ps_bins{ch}{w}{k}.color                 

            % ps_bins{1}{1}{1}
            %              freqs: [8 10.5]
            %              label: 'alpha'
            %        frequencies: [6x1 double]
            %               data: [0.3695 0.4152 0.1676 0.0630 0.0201 0.0566]
            %       ConfInterval: []
            %          confLevel: 0.9500
            %           filename: '/home/petteri/EEG_bdf_files/WEEK_1/MONDAY_06_04_12/TRIAL1_7AM/50_1.bdf'
            %     fileNameWoPath: '50_1.mat'
            %                sub: 50
            %             period: 1
            %              trial: 1
            %              color: 'd'

            % use subfunction to group the data by the condition,
            % as the idea is to compare the difference between
            % different lighting conditions        
            
    % Filenames defined in "alldata_lookup_table.xlsx"
    % Get the fields for organizing the data, MOVE AT SOME POINT, 
    % OR RE-DEFINE
    [sub, period, color, condition, trial, session, path, q, numberOfSubjects, subjectOffset] = import_getAllDataLookupFields(alldata_LUT);      
    eegSet = handles.eegSet;    
    
  
    %% Go through the files
    for i = 1 : length(savenameMAT)

            % init the parfor loop execution (i.e. read data from MAT file)
            [ps_bins, indexForCondition(i)] = organize_initDataForPARFORLoop(savenameMAT, i, condition, eegSet, sub, session, period, trial, handles);           

            % the actual processing algorithm
            dataOrganized_parfor{i} = organize_byConditionProcessFile(i, ps_bins, dataOrganized_parfor{i}, sub, period, color, condition, trial, session, path, handles);    

                % Note the inside of the ProcessFile could be further optimized
                % at some point as it was now bruteForcified inside the  parfor
                % loop
    
    end
    
     
    %% Sort the dataOrganized now based on the indexForCondition, 
    % cannot be put inside parfor due to the indexing used
    dataOrganized = organize_byConditionSortParfor(dataOrganized_parfor, indexForCondition, savenameMAT, handles);
    
    
    
    