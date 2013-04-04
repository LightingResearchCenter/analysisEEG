% Calculates mean, SD, etc. here 
function statOut = stat_statTestCollection(vecConc, x1, x2, colHeader, statOut, statFuncPath, shapWilk_pThr, bartlett_pThr, handles)

    % modify the code if you start feeding matrices here instead of vectors
    currDir = cd;
    
    % get the size of the input
    %     vecConc
    %     colHeader
    %     statOut     
    vecConc_nonNan = vecConc(~isnan(vecConc));
    n = length(vecConc_nonNan); % length of non-NaN value vector
    sizeIn = size(vecConc);
    
    x1 = x1(~isnan(x1));
    x2 = x2(~isnan(x2));
    
    %% BASIC ONES
    
        % just add lines here and store it to the structure if you want to
        % calculate something more
        statOut.mean = nanmean(vecConc);
        statOut.median = nanmedian(vecConc);
        statOut.SD   = nanstd(vecConc);
    
        % We use mainly 3rd party implementations of the statistical tests
        cd(statFuncPath)
        vecConc_nonNan = vecConc(~isnan(vecConc));    
          
    %% STATISTICAL TESTS
            
        %% ANOVA
        
            % If Data are normal (Gaussian) and deviations are homogeneous then you can do an ANOVA 
            % --> significant if p < 0.05
            if statOut.shapWilk_W(1) < 1 && statOut.btestOut_P <= bartlett_pThr                

                % The ANOVA test makes the following assumptions about the data in X:
                    % All sample populations are normally distributed.
                    % All sample populations have equal variance.
                    % All observations are mutually independent.                
                                        
                % the Matlab Statistics Toolbox                
                alpha  = handles.anova_pThreshold;                
                X      = vecConc;
                [statOut.anovaP, statOut.anovaTable, statOut.anovaStats] = anova1(X, [], 'off');
                    % Notches in the boxplot provide a test of group medians 
                    % (see boxplot) different from the F test for means in
                    % the ANOVA table             '
            else         
                
                statOut.anovaP     = NaN;
                statOut.anovaTable = NaN;
                statOut.anovaStats = NaN;
            end              
        
        
        %% t-Test
        
            alpha  = handles.student_pThreshold;       
            [statOut.tTest_h, statOut.tTest_p, statOut.tTest_ci, statOut.tTest_stats] = ttest2(x1,x2,alpha);            

            % statOut.tTest_h = [];
            % statOut.tTest_p = [];        
        
        
        %% Kruskal-Wallis test
        
            X = vecConc;
            [statOut.kruskWallisP, statOut.kruskWallisTable, statOut.kruskWallisStats] = kruskalwallis(X, [], 'off');

        %% Wilcoxon-Mann-Whithney Test, unpaired sample
        
            % --> significant if p < 0.05

            % We use Giuseppe Cardillo's code for this, same as RANKSUM
            % in MATLAB,  % http://www.mathworks.com/matlabcentral/fileexchange/25830            
            dispFullResultsFlag = 0;
            statOut.mww_Stats = mwwtest(x1,x2,dispFullResultsFlag);                                

            % In mwwtest the method is determined automatically, so we
            % use the same method for the ransum -function as well
            if strcmp(statOut.mww_Stats.method, 'Normal approximation') == 1
                handles.wilcox_method = 'approximate';
            else
                handles.wilcox_method = 'exact';
            end

            % RANKSUM (Matlab Statistics Toolbox)
            [statOut.rankSum_P, statOut.rankSum_H, statOut.rankSumStats] = ranksum(x1,x2,'alpha',handles.wilcox_pThreshold,'method',handles.wilcox_method);
            
                % check why NaNs are coming out


    cd(currDir)