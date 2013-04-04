function [dataField, headers] = stat_createPermutations(dataMatrix, colHeaders)

    % input size
    % dataMatrix
    [rows, cols] = size(dataMatrix);
    
    % manual combinatorics
    if cols == 1
        colIndex = [1 1];
    elseif cols == 2
        colIndex = [1 2];
    elseif cols == 3
        colIndex = [1 2; 1 3; 2 3];
    elseif cols == 4
        % colIndex = [1 2; 1 3; 1 4; 2 3; 2 4; 3 4];
        error('too many columns, modify the code to make this work!')
    elseif cols == 5
        %colIndex = [1 2; 1 3; 1 4; 2 3; 2 4; 2 5; 3 4; 3 5; 4 5];
        error('too many columns, modify the code to make this work!')
    else
        error('too many columns, modify the code to make this work!')
    end
    
    % define how many combinations there are
    [noOfCombinations, endPoints] = size(colIndex);    
    % colHeaders
    
    % individual columns, as they are
    for ik = 1 : noOfCombinations
       
        if colIndex(ik,1) ~= colIndex(ik,2)
            column1(:,1) = dataMatrix(:, colIndex(ik,1));
                column1(:,2) = ones(length(dataMatrix),1);
            column2(:,1) = dataMatrix(:, colIndex(ik,2));
                column2(:,2) = 2 * ones(length(dataMatrix),1);
            
            %column1 
            %column2
                
            dataField.concatenated{ik} = [column1; column2];
            dataField.x1{ik} = column1;
            dataField.x2{ik} = column2;
        else
            column1(:,1) = dataMatrix(:, colIndex(ik,1));
                column1(:,2) = ones(length(dataMatrix),1);
             dataField.concatenated{ik} = column1;
             dataField.x1{ik} = column1;
             dataField.x2{ik} = dataField.x1{ik};
        end
       
        %         colIndex(ik,1)
        %         colIndex(ik,2)
        %         colHeaders
        
        headers{ik} = sprintf('%s%s%s%s', '  ', colHeaders{colIndex(ik,1)}, '-', colHeaders{colIndex(ik,2)});
        
    end