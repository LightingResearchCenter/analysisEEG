function indivPeak = compute_EEG_IndivAlphaPeakPerSubject(sub, handles)

    if nargin == 0
        handles = init_defaultSettings();
        load(fullfile(handles.path.debugMatFiles, 'indivPeakStats.mat'))
    else
        if handles.saveTempDebugMATs == 1
            save(fullfile(handles.path.debugMatFiles, 'indivPeakStats.mat'))
        end
    end
    
    fileName = 'alphaPeakStatsOfAllSubjects.mat';    
    if handles.recalculateAlphaPeaksFromMATfiles == 1
        % Go through the MAT files on the disk
        [alphaPeak, alphaGravity] = compute_EEG_indivAlphaStats(handles.path.matFilesAlphaPeaks, handles);             
        save(fullfile(handles.path.matFiles, fileName), 'alphaPeak', 'alphaGravity') % save to disk
    else        
        load(fullfile(handles.path.matFiles, fileName)) % load from disk
    end
    
    % subtract the offset from the subject index
    sub = sub - handles.subjectOffset;
        
    % Get the individual peak (or gravity 
    if strcmp(handles.individualAlphaPeakWhich, 'peak')
        indivPeak = alphaPeak.IndivMeanOfMedians(sub);
        
    elseif strcmp(handles.individualAlphaPeakWhich, 'gravity')
        indivPeak = alphaGravity.IndivMeanOfMedians(sub);
        
    else
        error('How did you wanted to calculate the alpha peak?')
        
    end        
    
    % debugPlot
    debugPlot = 0;
    if debugPlot == 1
       plot_alphaPeakPlot(alphaPeak, alphaGravity, handles)
    end        
    
    
    %% SUBFUNCTIONS (LOCAL)
    

        %% go through the saved .MAT files for each recording (i.e. 432
        % different files)
        function [alphaPeak, alphaGravity] = compute_EEG_indivAlphaStats(path, handles)

            dirListing = dir(fullfile(path, 'IAF*.mat'));     

            % init, number of values found
            valuesFound = zeros(handles.numberOfSubjects, 1);

            % how many values can be found for each subject
            noOfTrials = 3; noOfPeriods = 3; noOfConditions = 3;
            valuesPerSubject = noOfTrials * noOfPeriods * noOfConditions;

            % preallocate the matrices
            alphaPeak.Mean = zeros(handles.numberOfSubjects, valuesPerSubject);
            alphaPeak.Median = alphaPeak.Mean;
            alphaPeak.SD = alphaPeak.Mean;
            alphaGravity.Mean = alphaPeak.Mean;
            alphaGravity.Median = alphaPeak.Mean;        
            alphaGravity.SD = alphaPeak.Mean;

            % go through all the files in that folder (path)
            for i = 1 : length(dirListing)

                % specify the input file 
                fileNameIn = dirListing(i).name;
                inputData{i} = load(fullfile(path, fileNameIn));

                % get the identifiers from the filename            
                [sub(i), period(i), condition(i), trial(i)] = getIdentifiers(fileNameIn, handles);

                    % remove the offset so it can be used for indexing
                    subjIndex = sub(i) - handles.subjectOffset;

                % correct the index
                valuesFound(subjIndex) = valuesFound(subjIndex) + 1;

                    % accumulate the peak values based on the subject (these
                    % matrices have 27 columns corresponding to each
                    % experimental condition for each subject)

                        % PEAK
                        alphaPeak.Mean(subjIndex, valuesFound(subjIndex))        = inputData{i}.alphaPeak.aver;
                        alphaPeak.Median(subjIndex, valuesFound(subjIndex))      = inputData{i}.alphaPeak.median;

                        % GRAVITY
                        alphaGravity.Mean(subjIndex, valuesFound(subjIndex))     = inputData{i}.alphaGravity.aver;
                        alphaGravity.Median(subjIndex, valuesFound(subjIndex))   = inputData{i}.alphaGravity.median;

                        % SDs (give you an indication which estiamte, peak or
                        % gravity is more robust)
                        alphaPeak.SD(subjIndex, valuesFound(subjIndex))          = inputData{i}.alphaPeak.SD;
                        alphaGravity.SD(subjIndex, valuesFound(subjIndex))       = inputData{i}.alphaGravity.SD;            

            end

            % calculate the stats of the accumulated matrices (brute force)

                % PEAK

                    [alphaPeak.IndivMeanOfMeans, alphaPeak.IndivMedianOfMeans, alphaPeak.IndivSDofMeans] = ...
                        statsOfAlphaMatrix(alphaPeak.Mean);

                    [alphaPeak.IndivMeanOfMedians, alphaPeak.IndivMedianOfMedians, alphaPeak.IndivSDofMedians] = ...
                        statsOfAlphaMatrix(alphaPeak.Median);

                    [alphaPeak.IndivMeanOfSDs, alphaPeak.IndivMedianOfSDs, alphaPeak.IndivSDofSDs] = ...
                        statsOfAlphaMatrix(alphaPeak.SD);

                % GRAVITY

                    [alphaGravity.IndivMeanOfMeans, alphaGravity.IndivMedianOfMeans, alphaGravity.IndivSDofMeans] = ...
                        statsOfAlphaMatrix(alphaGravity.Mean);

                    [alphaGravity.IndivMeanOfMedians, alphaGravity.IndivMedianOfMedians, alphaGravity.IndivSDofMedians] = ...
                        statsOfAlphaMatrix(alphaGravity.Median);

                    [alphaGravity.IndivMeanOfSDs, alphaGravity.IndivMedianOfSDs, alphaGravity.IndivSDofSDs] = ...
                        statsOfAlphaMatrix(alphaGravity.SD);           



        %% stats 
        function [aver, median, SD] = statsOfAlphaMatrix(matrix)

            index = 2; % rows are subject so we want stats for each subject        
            aver = nanmean(matrix,index);
            median = nanmedian(matrix,index);
            SD = nanstd(matrix,1,index);

        %% get identifiers from the filename
        function [sub, period, condition, trial] = getIdentifiers(fileNameIn, handles)

            % e.g. IAF_Subject 65_Period 3_Color w_Trial 3_processed.mat
            fields = textscan(fileNameIn, '%s%s %s%s %s%s', 'delimiter', '_');

                sub = str2double(cell2mat(strrep(fields{2}, 'Subject', '')));
                period = str2double(cell2mat(strrep(fields{3}, 'Period', '')));         
                trial = str2double(cell2mat(strrep(fields{5}, 'Trial', '')));

                condition = strrep(fields{4}, 'Color', '');
                condition = cell2mat(strrep(condition, ' ', '')); % remove whitespace

                    % convert to integer
                    colorLUT = ['d'; 'r'; 'w'];
                    condition = find(condition == colorLUT);






