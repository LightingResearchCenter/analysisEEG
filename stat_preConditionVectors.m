% Calculates the means of the different variables stored in the output
% matrix (each matrix for one "analysis date"
function statOut = stat_preConditionVectors(checkupMatrix, aver_Period, handles)

    % for faster debugging / developing    
    if nargin == 0
        handles = init_defaultSettings();
        close all        
        load(fullfile(handles.path.debugMatFiles, 'tempLeventStats.mat'))        
    else
        if handles.saveTempDebugMATs == 1            
            save(fullfile(handles.path.debugMatFiles, 'tempLeventStats.mat'))                            
        end        
    end
    
    % "depack" the needed variables from handles structure
    % defined in 
    statFuncPath = handles.path.statFuncPath;
    shapWilk_pThr = handles.shapWilk_pThreshold;       
    bartlett_pThr = handles.bartlett_pThreshold;

    % create the data vectors so that they are pushed for statistical
    % evaluation in a for-loop, the vectors should correspond to the
    % analyses done with Excel/SPSS previously
    
        % LIGHT
        % TRIAL
        % PERIOD
        % LIGHT * TRIAL
        % LIGHT * PERIOD
        % TRIAL * PERIOD
        % LIGHT * TRIAL * PERIOD

    % call a subfunction
    dataVectors = stat_createDataVectors(checkupMatrix, handles);  
    
    % preallocate
    dataPermutations = cell(length(dataVectors),1);
    statOut = cell(length(dataVectors),1);
    
    %% Test all different combinations
    % created with the subfunction above
    for ij = 1 : length(dataVectors) % the size of this should be 7 for the "original analysis"
                                     % of Levent, see the combinations
                                     % above

        fieldIn = 'mean';        
        [dataPermutations{ij}.data.(fieldIn), dataPermutations{ij}.colHeaders] = stat_createPermutations(dataVectors{ij}.data.(fieldIn), dataVectors{ij}.colHeaders);
    
        % check different permutations for given matrix
        [noOfDataPoints, numberOfCols] = size(dataPermutations{ij}.data.(fieldIn));
        numberOfCombinations = length(dataPermutations{ij}.data.(fieldIn).concatenated);
        
        for ik = 1 : numberOfCombinations
            
            % [ij ik]            
            % number of columns equals to number of different combinations that you can have 
        
            % check if the input data meets the criteria for the following tests    
            indexForPowers = 1; % the second column is just a "group index"
            indexForSample = 2;
            statOut{ij}{ik}.tests = stat_statPreTests(dataPermutations{ij}.data.(fieldIn).concatenated{ik}(:,indexForPowers), ...
                                                      dataPermutations{ij}.data.(fieldIn).concatenated{ik}(:,indexForSample), ...
                                                      dataVectors{ij}.colHeaders{ik}, statFuncPath, shapWilk_pThr, bartlett_pThr);            
            
            % do the actual tests         
            statOut{ij}{ik}.tests = stat_statTestCollection(dataPermutations{ij}.data.(fieldIn).concatenated{ik}, ...
                                                          dataPermutations{ij}.data.(fieldIn).x1{ik}(:,indexForPowers), ...
                                                          dataPermutations{ij}.data.(fieldIn).x2{ik}(:,indexForPowers), ...
                                                          dataPermutations{ij}.colHeaders{ik}, ...
                                                          statOut{ij}{ik}.tests, statFuncPath, shapWilk_pThr, bartlett_pThr, handles);
            
            % save the header
            statOut{ij}{ik}.header = dataPermutations{ij}.colHeaders{ik};
            
            % Debug display, can be commented away if needed/wanted (both lines)
            % disp([ij ik])
            % dispStats = statOut{ij}{ik}.tests
            % header = statOut{ij}{ik}.header
            
                                                  
        end    
    end
    
    
    

    
