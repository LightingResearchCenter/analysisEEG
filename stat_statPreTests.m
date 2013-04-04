% Calculates mean, SD, etc. here 
function statOut = stat_statPreTests(dataVectorIn, sample, colHeaders, statFuncPath, shapWilk_pThr, bartlett_pThr)

    % modify the code if you start feeding matrices here instead of vectors
    
    % get the size of the input
    % dataVectorIn = dataVectorIn'
    dataVectorIn_nonNan = dataVectorIn(~isnan(dataVectorIn));
    n = length(dataVectorIn_nonNan); % length of non-NaN value vector
    sample = sample(~isnan(dataVectorIn));
    [rowsIn, colsIn] = size(dataVectorIn);
 
    
    %% BASIC ONES
    
        % just add lines here and store it to the structure if you want to
        % calculate something more
        statOut.mean = nanmean(dataVectorIn);
        statOut.median = nanmedian(dataVectorIn);
        statOut.SD   = nanstd(dataVectorIn);
    
        % We use mainly 3rd party implementations of the statistical tests
        currDir = cd;
        cd(statFuncPath)
        dataVectorIn_nonNan = dataVectorIn(~isnan(dataVectorIn));

    %% "PRE-STATISTICAL" TESTS
        
        %% Shapiro-Wilk normality test
        % ---> ok if p > 0.05

            % IMPLEMENTATION by: Ahmed Ben Saïda
            % http://www.mathworks.com/matlabcentral/fileexchange/13964
            % Shapiro-Wilk parametric hypothesis test of composite normality, for sample size 3<= n <= 5000. 
            % Based on Royston R94 algorithm. 
            % This test also performs the Shapiro-Francia normality test for platykurtic samples.
           
            alpha = shapWilk_pThr;
            tail = 1; % default value, check swtest.m for explations
            
            % call the subfunction
            if n >= 3 
                try
                    % dataVectorIn
                    [statOut.shapWilk_H, statOut.shapWilk_p, statOut.shapWilk_W] = swtest(dataVectorIn_nonNan, alpha, tail);
                    % a = statOut.shapWilk_p
                    % b = statOut.shapWilk_H
                catch
                    % fails if all the values are the same
                    warning(['"n check" faulty?'])
                    statOut.shapWilk_H = NaN;
                    statOut.shapWilk_p = NaN;
                    statOut.shapWilk_W = NaN;                
                end
            else
                statOut.shapWilk_H = NaN;
                statOut.shapWilk_p = NaN;
                statOut.shapWilk_W = NaN;
            end

            % NULL hypothesis is that the distribution is NOT Gaussian so
            % if the p-value is higher than your alpha, then the
            % distribution is Gaussian, i.e. if W < 1
            
        %% Bartlett's K-squared test for "homogeneity of distribution of the deviation"
        % --> ok if p > 0.05

            % statOut.shapWilk_p
        
            % if the distribution is indeed GAUSSIAN
            if statOut.shapWilk_p <= shapWilk_pThr 
                
                % here1 = 2
                
                % Use the subfunction provided by Antonio
                % Trujillo-Ortiz to reduce dependency on additional
                % toolboxes such as Statistics Toolbox that has the
                % function "barttest" (?)
                % http://www.mathworks.com/matlabcentral/fileexchange/3314-btest
                % sample = ones(length(dataVectorIn_nonNan),1);
                % whos
                try 
                    X = [dataVectorIn_nonNan sample];                    
                catch err
                    err;
                    X = [dataVectorIn_nonNan' sample]; % transpose
                end
                alpha  = bartlett_pThr;

                % first with Trujillo-Ortiz's subfunction
                btestOut = Btest(X,alpha);
                
                    % take out from the structure
                    statOut.btestOut_var = btestOut.var;
                    statOut.btestOut_v   = btestOut.v;
                    statOut.btestOut_P   = btestOut.P;
                    statOut.btestOut_X2  = btestOut.X2;
                    statOut.btestOut_F   = btestOut.F;
                    statOut.btestOut_H   = btestOut.H;                    
            
            % If not GAUSSIAN distribution, just return NaN
            else                
                statOut.btestOut_var = NaN;
                statOut.btestOut_v   = NaN;
                statOut.btestOut_P   = NaN;
                statOut.btestOut_X2  = NaN;
                statOut.btestOut_F   = NaN;  
                statOut.btestOut_H   = 0;
            end
          
            
        %% Mauchly's sphericity test for "homogeneity of distribution of the deviation"
        % --> ok if p > 0.05
            
            % implementation?
            % e.g. http://www.mathworks.com/matlabcentral/fileexchange/3694
            
            % R implementation
            % http://stat.ethz.ch/R-manual/R-patched/library/stats/html/mauchly.test.html
            
            % R in MATLAB
            % http://neurochannels.blogspot.com/2010/05/how-to-run-r-code-in-matlab.html
            
                % Matlab R-Link
                % http://www.mathworks.com/matlabcentral/fileexchange/5051
                
        cd(currDir)
        % pause
    