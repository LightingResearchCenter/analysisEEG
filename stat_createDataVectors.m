function dataVectors = stat_createDataVectors(checkupMatrix, handles)

    header = {'WT1', 'WT2', 'WT3', 'WT4', 'WT5', 'WT6', 'WT7', 'WT8', 'WT9',...
              'RT1', 'RT2', 'RT3', 'RT4', 'RT5', 'RT6', 'RT7', 'RT8', 'RT9',...
              'DT1', 'DT2', 'DT3', 'DT4', 'DT5', 'DT6', 'DT7', 'DT8', 'DT9'};

             % Period 1 (Trial1, Trial2, Trial3), Period 2 (Trial1, Trial2,
             % Trial3), Period 3 (Trial1, Trial2, Trial3)
             
    inputSize = size(checkupMatrix.mean);
   
    % first get rid of the first trials (that are all zeroes)
    columnsToExclude = [1 4 7 10 13 16 19 22 25];
    columnBooleanInclude = ones(inputSize(2),1);
    columnBooleanInclude(columnsToExclude) = 0;
    columnBooleanInclude = logical(columnBooleanInclude);
       
    % now use these indices for input data
    checkupWoNorms.mean = checkupMatrix.mean(:, columnBooleanInclude);
    checkupWoNorms.SD = checkupMatrix.SD(:, columnBooleanInclude);
    
    %% Create the light vector
    
        ij = 1;
        dataVectors{ij}.label = 'LIGHT';
        noOfSamples = 6;
        for i = 1 : 3 % number of conditions            
            matrixTempMean = zeros(inputSize(1), noOfSamples);
            matrixTempSD = zeros(inputSize(1), noOfSamples);
            
            for j = 1 : noOfSamples % number of samples per light (9 - 3 Trial 1s)
                colIndex = ((i-1)*j + j);
                matrixTempMean(:,j) = checkupWoNorms.mean(:, colIndex);
                matrixTempSD(:,j) = checkupWoNorms.SD(:, colIndex);
            end            
            % transform the matrix into a vector
            dataVectors{ij}.data.mean(:,i) = matrixTempMean(:);
            dataVectors{ij}.data.SD(:,i) = matrixTempSD(:);
        end
        
        dataVectors{ij}.colHeaders = {'White'; 'Red'; 'Dark'};
        lightDebug = dataVectors{ij}.data.mean;
        
    %% Create the trial vector
    
        ij = 2;
        dataVectors{ij}.label = 'TRIAL';
        noOfSamples = 9;
        for i = 1 : 2 % number of trials (Trial 2 and Trial 3)
            
            matrixTempMean = zeros(inputSize(1), noOfSamples);
            matrixTempSD = zeros(inputSize(1), noOfSamples);
            
            for j = 1 : noOfSamples % number of samples per light (9 - 3 Trial 1s)
                colIndex = (2*j)-(2-i);
                matrixTempMean(:,j) = checkupWoNorms.mean(:, colIndex);
                matrixTempSD(:,j) = checkupWoNorms.SD(:, colIndex);
            end            
            % transform the matrix into a vector
            dataVectors{ij}.data.mean(:,i) = matrixTempMean(:);
            dataVectors{ij}.data.SD(:,i) = matrixTempSD(:);
            
        end
        
        dataVectors{ij}.colHeaders = {'Trial2'; 'Trial3'};
        trialDebug = dataVectors{ij}.data.mean;
    
  %% Create the period vector
    
        ij = 3;
        dataVectors{ij}.label = 'PERIOD';
        noOfSamples = 3; % fuse trial 2 and trial 3
        for i = 1 : 3 % number of periods (7am, 11am, 3pm)
            
            matrixTempMean = zeros(inputSize(1), noOfSamples);
            matrixTempSD = zeros(inputSize(1), noOfSamples);
            
            for j = 1 : noOfSamples % number of samples per light (9 - 3 Trial 1s)
                colIndex = (2*j)-(2-i);
                matrixTempMean(:,j) = checkupWoNorms.mean(:, colIndex);
                matrixTempSD(:,j) = checkupWoNorms.SD(:, colIndex);
            end            
            % transform the matrix into a vector
            dataVectors{ij}.data.mean(:,i) = matrixTempMean(:);
            dataVectors{ij}.data.SD(:,i) = matrixTempSD(:);
            
        end
        
        dataVectors{ij}.colHeaders = {'Period1'; 'Period2'; 'Period3'};
        periodDebug = dataVectors{ij}.data.mean;
        