% SUBFUNCTION to calculate the STATs
function [aver, medianValue, SD, N] = organize_calcMatrixStats(dataMatrix, dim)

    % sizeIn = size(dataMatrix); % rows * cols         

    % concenate all the matrix values into a single vector
    
    % i.e. if there are two scalp positions for the given band, there will
    % be 2 rows of data and when combining them to one row it is easier to
    % compute the mean and we can avoid the mean(mean())-
    
    % there is slight computational overhead during the redundancy of
    % some operations, but it seems maybe more flexible if further
    % changes need to be added to the code    
    % dataVector = dataMatrix(:);
    
    % no concenation atm
    
    % remove NaNs
    N = length(dataMatrix(~isnan(dataMatrix)));
    
    % whos

    % compute stats, add variables here if you need
    aver = nanmean(dataMatrix, dim);
    medianValue = nanmedian(dataMatrix, dim);
    SD = nanstd(dataMatrix, 1, dim);
    % N = length(dataVector); % number of non-NaN points

    % pause