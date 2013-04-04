function SD = organize_sqrtSumOfSDs(sdOfMeans, matrixOfSDs)

    if nargin == 0
        load('tempSqrtSd.mat')
    else
        % save('tempSqrtSd.mat')
    end
    
    % Attempt to estimate combined standard deviations as during the code,
    % a lot of values are just averaged and averaged
    % see e.g. http://en.wikipedia.org/wiki/Standard_deviation#Combining_standard_deviations
    
        % PSEUDOCODE
        % sqrt( sum ( (SD of MEANS)^2 + (sqrt(sum(SD_Trial1^2 +
        % SD_Trial2^2)))^2)       

    % sdOfMeans - the SD of all the means (differenct subjects)
    
        %               columns correspond to the amount of time points in
        %               the data, i.e. how pany data points in the time
        %               epoch, typically the amount of column is 149
        
        %               there should be only one row 
    
    % matrixOfSDs - all the SDs of individual time points of all the
    %               subjects
    
        %               rows correspond to the trials (excluded the first trial
        %               if trialstartIndex = 2 in organize_averageTheTrials)

        %               columns correspond to the amount of time points in
        %               the data, i.e. how pany data points in the time
        %               epoch, typically the amount of column is 149
    
    % whos
    % sdOfMeans
    % matrixOfSDs
    
    % calculate new SDs taking into
    % consideration the original SDs as well as
    % the newly calculated mean of SDs
  
         % accumulate the other SD vectors from
         % the Matrix (2 vectors if there are 2 trials)
         [rows,cols] = size(matrixOfSDs);
         
         sumOfSDs = zeros(1, length(sdOfMeans));
         
         for k = 1 : rows
            SD_vector = (matrixOfSDs(k,:)).^2;
            sumOfSDs = sumOfSDs + SD_vector;
         end

    % now we can take the square root of the
    % squared sum of the SDs
    
%     sdOfMeans
%     matrixOfSDs
%     sumOfSDs
    SD = sqrt(sumOfSDs.^2 + sdOfMeans.^2);
    
    % pause