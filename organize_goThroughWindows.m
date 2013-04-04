function [aver, medianValue, SD, N] = organize_goThroughWindows(i,k,kj,lj,numberOfWindows,startInd,endInd,ps_bins,fieldIn,handles)
  

    % calculate the number of data points (can't be
    % read necessarily from data if its empty)    
    try 
        ch = 1;
        freqMax = ps_bins{ch}{1}{k}.freqs(2);        
    catch err              
        err        
        error('Some error with the input, see above!')
    end
    freqMin = ps_bins{1}{1}{k}.freqs(1);
    freqRes = handles.eegBins.freqResolution;

    % Round for the frequency resolution used, i.e. we can't have bins
    % starting from 2.25 Hz as the resolution is 0.5 Hz, so the values are
    % forced either two 2 or 2.5 Hz, check inside the subfunction for
    % details, and change the contents of it if you wanna modify this
    % behavior
    % freqs = compute_checkFreqLimits([freqMin freqMax], freqRes);
    % freqMin = freqs(1);
    % freqMax = freqs(2);
    
    %% EXAMPLE OF DATA
         
        % ps_bins{1}{1}{1} =  freqs: [8 12]
        %                     label: 'alpha'
        %     powerSpec_frequencies: [9x1 double]
        %                      data: [1x1 struct]
        %              ConfInterval: []
        %                  filename: '/home/petteri/EEG-Data/EEG_bdf_files/WEEK_1/MONDAY_06_04_12/TRIAL1_7AM/50_1.bdf'
        %            fileNameWoPath: '50_1.mat'
        %                       sub: 50
        %                    period: 1
        %                     trial: 1
        %                     color: 'd'
        % 
        % ps_bins{1}{1}{1}.data = powerSpectrum: [9x1 double]
        %                                 dummy: []
        % 
        % ps_bins{1}{1}{1}.data.powerSpectrum =
        %     0.3928
        %     0.5272
        %     0.1679
        %     0.1225
        %     0.0368
        %     0.0402
        %     0.0472
        %     0.0175
        %     0.0265
        % 
        % ps_bins{1}{1}{1}.data.dummy = []

    % Whether the upper limit is included in the range or not, by default
    % it is (as it was in the code of Rob Hamner)
    
        if k < handles.indexToStartRatioBins
            if handles.eegBins.includeUpperLimit == 1
                numberOfDataPoints = ((freqMax - freqMin) / freqRes) + 1;
            else
                numberOfDataPoints = (freqMax - freqMin) / freqRes;
            end    
            numberOfChannelsPerBin = (endInd-startInd)+1;
            
        else
            % ratio ones
            numberOfDataPoints = 1;
                %Now we have situation that the alpha and theta band (or
                %any ratio of bands) might have different amoun of data
                %points per frequency band and it is just easier to
                %calculate mean of those data points (9 data points between
                %8-12 Hz for exmaple) than to do it vectorially as for
                %other bands
            numberOfChannelsPerBin = (endInd(1)-startInd(1))+1;
        end
    
        % preallocate        
        dataMatrix = zeros(numberOfChannelsPerBin*numberOfDataPoints, numberOfWindows);                 
        dataMatrixPerWindow = zeros(numberOfChannelsPerBin, numberOfDataPoints);    
        
       
        
    %% GO THROUGH THE WINDOWS
    for m = 1 : numberOfWindows % 149 different time windows for example         

        %% Extract data vector (human-readable variable name)     
        % contains the power of the frequency bins (k) given as input
        % arguments to this function per each time window (m), and
        % the channels (n) defined above
        if k >= handles.indexToStartRatioBins          
         
            % preallocate maybe perWindow1 and perWindow2
            
            % we might have 2 channels for alpha and 4 channels for theta
            % for example
            for n1 = startInd(1) : endInd(1)           
                           
                % now we have as many rows (n) as we have recording sites for the given band            
                indToMat = (n1 - startInd(1)) + 1; % correcting for offset as otherwise this would be 5 for Ch5 and 6 for Ch6            

                % vec 1 and vec 2 most likely have different lengths so
                % we cannot put them to the same matrix
                try
                    vec1 = ps_bins{n1}{m}{k}.data.(fieldIn){1}';
                catch
                    % REMOVE WHEN RUNNING IMPORT AGAIN
                    vec1 = ps_bins{n1}{m}{k}.data.(fieldIn)'; % for dummy
                end
                perWindow1(indToMat,:) = vec1;
               
            end
               
            for n2 = startInd(2) : endInd(2)
                
                indToMat = (n2 - startInd(2)) + 1;

                try
                    vec2 = ps_bins{n2}{m}{k}.data.(fieldIn){2}';
                catch
                    % REMOVE WHEN RUNNING IMPORT AGAIN
                    vec2 = ps_bins{n2}{m}{k}.data.(fieldIn)'; % for dummy
                end
                perWindow2(indToMat,:) = vec2;
                
            end           

        else

            for n = startInd : endInd
            
                % now we have as many rows (n) as we have recording sites for the given band            
                indToMat = (n - startInd) + 1; % correcting for offset as otherwise this would be 5 for Ch5 and 6 for Ch6            
                    % indToMat is 1 for Ch5 for Alpha (for example)
                    % indToMat is 2 for Ch6 for Alpha (for example)              

                    dataVector = ps_bins{n}{m}{k}.data.(fieldIn);
                    dataMatrixPerWindow(indToMat,:) = dataVector;
                    
            end
            
        end                
        
        % FOR RATIOs
        if k >= handles.indexToStartRatioBins                   
            
            matToVec1 = perWindow1(:);
            matToVec2 = perWindow2(:);
            
            % calculate the stats here
            [aver(m), medianValue(m), SD(m), N(m)] = organize_calcRatioStats(matToVec1, matToVec2);
            
            %             if k == 159
            %                 k1 = k
            %                 matToVec1
            %                 matToVec2
            %             end
            
        % For all the other bin definitions
        else
            
            % create a vector from the n-row matrix
            dataInVectorFromMatrix = dataMatrixPerWindow(:);

            % assign to the matrix
            dataMatrix(:,m) = dataInVectorFromMatrix;        

            % now the dataMatrix contains all the data points
            % for the given band definition, and could be saved
            % to the output structure if you wanted, but we
            % only save the stat calculation to get smaller MAT
            % files as output    
            % disp(['window:', num2str(m), ', freqBin: ', num2str(j)])

        end
       
    end % m    

    
    %% Compute the stats of the matrix accumulated above
    % for non-ratio bins

        % This part actually consumes the most CPU time of the loop

        % now the matrix has rows equaling the number of noOfChannelsPerBin
        % multiplied with the amount of samples per that bin, e.g. alpha is
        % taken between 8-12 Hz (9 samples at 0.5 Hz resolution) from two
        % scalp locations, so the number of rows for Alpha is 18.

        % the number of columns equals now to the number of time window, so
        % we want to calculate stats so that we have the number of columns
        % the same as noOfWindows with only one row (dim = 1)

        % dataMatrix    
        if k < handles.indexToStartRatioBins

            dim = 1;
            [aver, medianValue, SD, N] = organize_calcMatrixStats(dataMatrix, dim);    
            % aver
            % pause
        end
    
    
        
        
        
        