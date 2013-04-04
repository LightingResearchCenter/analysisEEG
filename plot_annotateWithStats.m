function plot_annotateWithStats(statOut, handles)

    % for faster debugging / developing    
    if nargin == 0
        handles = init_defaultSettings();
        close all        
        load(fullfile(handles.path.debugMatFiles, 'tempStatAnnotation.mat'))        
    else
        if handles.saveTempDebugMATs == 1            
            save(fullfile(handles.path.debugMatFiles, 'tempStatAnnotation.mat'))                            
        end        
    end

    axis off
    
    % Debug display of input data
    statOut;
    tests = statOut{1}{1}.tests;
    header = statOut{1}{1}.header;
    header = statOut{1};
    
        % e.g.
        %     tests = 
        % 
        %                 mean: [0.9293 1.5000]
        %               median: [0.9060 1.5000]
        %                   SD: [0.2049 0.5013]
        %           shapWilk_H: 0
        %           shapWilk_p: 0.4834
        %           shapWilk_W: 0.9932
        %         btestOut_var: 0.0420
        %           btestOut_v: 0
        %           btestOut_P: NaN
        %          btestOut_X2: NaN
        %           btestOut_F: NaN
        %           btestOut_H: 0
        %               anovaP: NaN
        %           anovaTable: NaN
        %           anovaStats: NaN
        %              tTest_h: []
        %              tTest_p: []
        %             tTest_ci: [2x1 double]
        %          tTest_stats: [1x1 struct]
        %         kruskWallisP: 1.3001e-27
        %     kruskWallisTable: {4x6 cell}
        %     kruskWallisStats: [1x1 struct]
        %            mww_Stats: [1x1 struct]
        %            rankSum_P: 0.1303
        %            rankSum_H: 0
        %         rankSumStats: [1x1 struct]
        
        %         statOut{1}{1}.tests.shapWilk_p
        %         statOut{1}{1}.tests.btestOut_P
        %         statOut{1}{1}.tests.anovaP
        %         statOut{1}{1}.tests.tTest_p
        %         statOut{1}{1}.tests.kruskWallisP
        %         statOut{1}{1}.tests.rankSum_P
    
    %% ANNOTATE
    
        emptyValue = 9999;
        
        % testHeaders = {'Shapiro-Wilk'; 'Bartlett'; 'Anova'; 'Mann-Whitney'; 'Kruskal-Wallis'; 'Student t-test'};
        testHeaders = {'Shapiro-Wilk'; 'Bartlett'; 'Anova'; 'Mann-Whitney'; 'Student t-test'};
        % testFieldnames = {'shapWilk_p';'btestOut_P';'anovaP';'rankSum_P';'kruskWallisP';'tTest_p'};
        testFieldnames = {'shapWilk_p';'btestOut_P';'anovaP';'rankSum_P'; 'tTest_p'};
        noOfDataColumns = length(statOut) + 1; % one extra for the column
        
        indicesToBold = [];
        howManyHeaders = 0;
        
        for ij = 1 : length(statOut) +1 % e.g. 3 +1 (header)
            if ij == 1
                noOfDiffCombinationsVector(ij) = 1;
            else
                noOfDiffCombinationsVector(ij) = length(statOut{ij-1});
            end
        end
        sumOfCombinations = sum(noOfDiffCombinationsVector);
        
        for i = 1 : length(testHeaders) % e.g. 6
            
            iCount = ((i-1) * sumOfCombinations);
            ijCount = 0;
            
            for ij = 1 : noOfDataColumns % e.g. 3 + 1         
                    
                noOfDiffCombinations = noOfDiffCombinationsVector(ij);
                if ij == 1
                    noOfDiffCombinationsPrevious = 0;
                else
                    noOfDiffCombinationsPrevious = noOfDiffCombinationsVector(ij-1);
                end
                % cell index                    
                ijCount = ijCount + noOfDiffCombinationsPrevious;                   
                    
                for ik = 1 : noOfDiffCombinations % e.g. 3 for LIGHTS, 3 for PERIODS, 1 for TRIALS
                    ind = iCount + ijCount + ik;                 

                    % DEBUG
                    %{
                    disp(['i=', num2str(i), ', ij=',  num2str(ij), ', iC=', num2str(iCount), ...
                          ', ijC=', num2str(ijCount), ', ind=', num2str(ind), ', prev=', num2str(noOfDiffCombinationsPrevious), ', comb=',  num2str(noOfDiffCombinations)])
                    %}
                    
                    % for the statistical test header
                    if ij == 1                                             
                        statHeaderBox{ind} = testHeaders{i};
                        howManyHeaders = howManyHeaders + 1;
                        indToBold(howManyHeaders) = ind;
                        statValuesBox1(ind) = emptyValue;                    
                    
                    % for the actual data
                    else                     
                        statHeaderBox{ind} = statOut{ij-1}{ik}.header; % header                        
                        value = statOut{ij-1}{ik}.tests.(testFieldnames{i}); % the p-value
                        if ~isempty(value)
                            statValuesBox1(ind) = value;                   
                        else
                            statValuesBox1(ind) = NaN;                   
                        end                        
                    end
                    
                end
            end
        end
        
        %         ind
        %         indToBold
        %         statHeaderBox
        %         statValuesBox1

        % define the positions
        xoffs = 0; yoffset = 0.94;
        y_int = 1 / length(statValuesBox1); 
        xPoint = [0 0.6]; % four column as the first one is the header
        lgth = length(statValuesBox1);

        statBox1_text = zeros(lgth, 2); % preallocate memory
        numPrecision = 2;      % numerical precision for values
        
            % put the text, for loop                
            for k = 1 : lgth      
                statBox1_text(k,1) = text(xPoint(1)+xoffs, yoffset - ((k-1)*y_int), statHeaderBox{k});
                if statValuesBox1(k) == emptyValue
                    statBox1_text(k,2) = text(xPoint(2)+xoffs, yoffset - ((k-1)*y_int), '');
                else
                    statBox1_text(k,2) = text(xPoint(2)+xoffs, yoffset - ((k-1)*y_int), num2str(statValuesBox1(k), numPrecision));
                end
            end            

        set(statBox1_text, 'FontName', 'Arial', 'FontSize', handles.style.fontSizeBase-3)     
        set(statBox1_text(indToBold), 'FontWeight', 'bold') 