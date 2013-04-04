function handles = init_defineFrequencyBins(handles) 

    % adds as many you like, just remember to change    
    % the index inside {} for both new entry of label and freqs
    % or read from text file if this section becomes very large
    
        handles.eegBins.freqs{1} = [8 12];
        handles.eegBins.label{1} = 'alpha'; % on Pz and Oz
        handles.eegBins.ch{1} = [5 6]; % from what channel(s) are calculated

        handles.eegBins.freqs{2} = [10.5 11];
        handles.eegBins.label{2} = 'high alpha'; % on Pz and Oz
        handles.eegBins.ch{2} = [5 6]; 

        handles.eegBins.freqs{3} = [13 30];
        handles.eegBins.label{3} = 'beta'; % Fz and Cz
        handles.eegBins.ch{3} = [3 4]; 

        handles.eegBins.freqs{4} = [5 7];
        handles.eegBins.label{4} = 'theta'; % Fz and Cz
        handles.eegBins.ch{4} = [3 4]; 

        handles.eegBins.freqs{5} = [5 9]; % also from Cajochen et al. (2000)
                                          % http://dx.doi.org/10.1016/S0166-4328(00)00236-9
        handles.eegBins.label{5} = 'alpha-theta'; % on all channels
        handles.eegBins.ch{5} = [3 4 5 6]; 

        handles.eegBins.freqs{6} = [18 21]; 
        handles.eegBins.label{6} = 'high-beta'; % on Fz and Cz
        handles.eegBins.ch{6} = [3 4]; 

        % Bands used in Aeschbach et al. 1999
        % http://www.ncbi.nlm.nih.gov/pubmed/10600925
        handles.eegBins.freqs{7} = [13.25 20];
        handles.eegBins.label{7} = 'beta Aeschbach';
        handles.eegBins.ch{7} = [3 4];

        handles.eegBins.freqs{8} = [4.25 8];
        handles.eegBins.label{8} = 'theta Aeschbach';
        handles.eegBins.ch{8} = [3 4];

        handles.eegBins.freqs{9} = [0.75 4];
        handles.eegBins.label{9} = 'delta Aeschbach';
        handles.eegBins.ch{9} = [3 4]; % ?

        handles.eegBins.freqs{10} = [10.25 13];
        handles.eegBins.label{10} = 'theta-highAlpha Aeschbach';
        handles.eegBins.ch{10} = [5 6];

        handles.eegBins.freqs{11} = [5.25 6];
        handles.eegBins.label{11} = '5.25-6 Hz Aeschbach';
        handles.eegBins.ch{11} = [3 4 5 6]; % ?

        handles.eegBins.freqs{12} = [10.25 11];
        handles.eegBins.label{12} = 'specialBin2 Aeschbach';
        handles.eegBins.ch{12} = [3 4 5 6]; % ?

        handles.eegBins.freqs{13} = [17.25 18];
        handles.eegBins.label{13} = 'specialBin3 Aeschbach';
        handles.eegBins.ch{13} = [3 4 5 6]; % ?

        % Bands used in Lockley et al. 2006 (check abstract)
        % http://www.ncbi.nlm.nih.gov/pubmed/16494083
        handles.eegBins.freqs{14} = [0.5 5.5];
        handles.eegBins.label{14} = 'delta-theta Lockley';
        handles.eegBins.ch{14} = [3 4];

        handles.eegBins.freqs{15} = [9.5 10.5];
        handles.eegBins.label{15} = 'high-alpha Lockley';
        handles.eegBins.ch{15} = [5 6];      

        % Bands used in Strijkstra et al. 2003
        % http://www.ncbi.nlm.nih.gov/pubmed/16494083           
        handles.eegBins.freqs{16} = [4 8];
        handles.eegBins.label{16} = 'theta Strijkstra';
        handles.eegBins.ch{16} = [3 4]; % theta and beta increased at fronto-central
                                        % but was absent
                                        % occipito-parietally

        handles.eegBins.freqs{17} = [15 22];
        handles.eegBins.label{17} = 'beta-1 Strijkstra';
        handles.eegBins.ch{17} = [3 4]; 

        handles.eegBins.freqs{18} = [23 29];
        handles.eegBins.label{18} = 'beta-2 Strijkstra';
        handles.eegBins.ch{18} = [3 4];   

        % Review of Cajochen et al. (2003)
        % http://dx.doi.org/10.1046/j.1446-9235.2003.00041.x
        handles.eegBins.freqs{19} = [1 4.5];
        handles.eegBins.label{19} = 'low-freq Cajochen2003';
        handles.eegBins.ch{19} = [3 4];  
        
        % From Putilov et al. (2013), single site bands
        % http://dx.doi.org/10.1016/j.clinph.2013.01.018
        handles.eegBins.freqs{20} = [9 12];
        handles.eegBins.label{20} = 'alpha Putilov2013 Oz';
        handles.eegBins.ch{20} = [6];
        
        handles.eegBins.freqs{21} = [5 8];
        handles.eegBins.label{21} = 'theta Putilov2013 Oz';
        handles.eegBins.ch{21} = [6];        

        handles.indexLastBin_specificBands = length(handles.eegBins.label);

        %% Generic bins

            handles.eegBins.genericChannels = [3 4 5 6];                       

            % General bins at 1 Hz resolution
            handles.indexToStart_1HzBins = length(handles.eegBins.label) + 1;            
            indexToStart = handles.indexToStart_1HzBins;
            freqRes = 1;
            freqRange = [0.5 40.5];
            lengthOfLoop = ((freqRange(2) - freqRange(1))) / freqRes;
            for i = 1 : lengthOfLoop
                freqMin = freqRange(1) + ((i-1)*freqRes);
                freqMax = freqMin + freqRes;
                stringLabel = [num2str(freqMin),'-',num2str(freqMax),' Hz']; % define the label
                handles.eegBins.freqs{indexToStart} = [freqMin freqMax];
                handles.eegBins.label{indexToStart} = stringLabel;
                indexToStart = indexToStart + 1;
                %disp([freqMin freqMax])
            end

            % General bins at 0.5 Hz resolution
            handles.indexToStart_05HzBins = length(handles.eegBins.label) + 1;
            indexToStart = handles.indexToStart_05HzBins;
            freqRes = 0.5;
            freqRange = [0.5 40.5];
            lengthOfLoop = ((freqRange(2) - freqRange(1))) / freqRes;
            for i = 1 : lengthOfLoop
                freqMin = freqRange(1) + ((i-1)*freqRes);
                freqMax = freqMin; % + freqRes;
                stringLabel = [num2str(freqMin),'-',num2str(freqMax),' Hz']; % define the label
                handles.eegBins.freqs{indexToStart} = [freqMin freqMax];
                handles.eegBins.label{indexToStart} = stringLabel;
                indexToStart = indexToStart + 1;
                %disp([freqMin freqMax])
            end

            handles.indexToEndGeneralBins = length(handles.eegBins.label);

        %% Individual Alpha peak bins

            handles.indexToStartIndivBins = length(handles.eegBins.label) + 1;
            ij = handles.indexToStartIndivBins;                               

            % How is the peak calculated, Klimesch preferred the
            % gravity so we use that
                handles.individualAlphaPeakWhich = 'gravity';
                %handles.individualAlphaPeakWhich = 'peak';

            % now the frequencies are defined in relation to the alpha
            % peak, see Klimesch (1999) for details
            % http://dx.doi.org/10.1016/S0165-0173(98)00056-3
            handles.eegBins.freqs{ij} = [-4 -2];
            handles.eegBins.label{ij} = 'lower alpha 1';
            handles.eegBins.ch{ij} = [5 6];

            handles.eegBins.freqs{ij+1} = [-2 0];
            handles.eegBins.label{ij+1} = 'lower alpha 2';
            handles.eegBins.ch{ij+1} = [5 6];

            handles.eegBins.freqs{ij+2} = [0 2];
            handles.eegBins.label{ij+2} = 'upper alpha';
            handles.eegBins.ch{ij+2} = [5 6];                

            handles.eegBins.freqs{ij+3} = [0 1];
            handles.eegBins.label{ij+3} = 'upper alpha Narrow';
            handles.eegBins.ch{ij+3} = [5 6];

            handles.eegBins.freqs{ij+4} = [-4 0];
            handles.eegBins.label{ij+4} = 'lower alpha';
            handles.eegBins.ch{ij+4} = [5 6];

            handles.eegBins.freqs{ij+5} = [-3.5 0];
            handles.eegBins.label{ij+5} = 'lower alpha Narrow';
            handles.eegBins.ch{ij+5} = [5 6];

            handles.eegBins.freqs{ij+6} = [-0.5 0.5];
            handles.eegBins.label{ij+6} = 'around peak Narrow';
            handles.eegBins.ch{ij+6} = [5 6];

            handles.eegBins.freqs{ij+7} = [-1 1];
            handles.eegBins.label{ij+7} = 'around peak Broad';
            handles.eegBins.ch{ij+7} = [5 6];

            handles.eegBins.freqs{ij+8} = [0 0];
            handles.eegBins.label{ij+8} = 'at Peak';
            handles.eegBins.ch{ij+8} = [5 6];

            handles.eegBins.freqs{ij+9} = [-6 -4.5];
            handles.eegBins.label{ij+9} = 'theta narrow';
            handles.eegBins.ch{ij+9} = [3 4];

            handles.eegBins.freqs{ij+10} = [-7 -5.5];
            handles.eegBins.label{ij+10} = 'theta mid';
            handles.eegBins.ch{ij+10} = [3 4];

            handles.eegBins.freqs{ij+11} = [-8 -4.5];
            handles.eegBins.label{ij+11} = 'theta broad';
            handles.eegBins.ch{ij+11} = [3 4];

            handles.eegBins.freqs{ij+12} = [3 20];
            handles.eegBins.label{ij+12} = 'beta broad';
            handles.eegBins.ch{ij+12} = [3 4];

            handles.eegBins.freqs{ij+13} = [3 10];
            handles.eegBins.label{ij+13} = 'beta narrow';
            handles.eegBins.ch{ij+13} = [3 4];
            
            handles.eegBins.freqs{ij+14} = [0 0];
            handles.eegBins.label{ij+14} = 'alpha Peak Oz';
            handles.eegBins.ch{ij+14} = [6];
            
            handles.eegBins.freqs{ij+15} = [-0.5 0.5];
            handles.eegBins.label{ij+15} = 'around peak Narrow Oz';
            handles.eegBins.ch{ij+15} = [6];

            handles.eegBins.freqs{ij+16} = [-6 -4.5];
            handles.eegBins.label{ij+16} = 'theta narrow Oz';
            handles.eegBins.ch{ij+16} = [6];

            handles.eegBins.freqs{ij+17} = [-7 -5.5];
            handles.eegBins.label{ij+17} = 'theta mid Oz';
            handles.eegBins.ch{ij+17} = [6];

            handles.eegBins.freqs{ij+18} = [-8 -4.5];
            handles.eegBins.label{ij+18} = 'theta broad Oz';
            handles.eegBins.ch{ij+18} = [6];


            % noOfBins = length(handles.eegBins.label)
            handles.indexToEndIndivBins = length(handles.eegBins.label);


        %% "Ratio bins"

            % According to Donskaya et al. (2012), ratio of theta /
            % alpha shows a high correlation with subjective sleepiness
            % than either alpha or theta power alone (end of 4st
            % paragraph), http://dx.doi.org/10.1007/s11818-012-0561-1

            handles.indexToStartRatioBins = length(handles.eegBins.label) + 1;
            ik = handles.indexToStartRatioBins;

            % Now in contrast to previous bin definitions, we don't
            % reference to the frequency ranges but rather than to
            % labels used above (as there are multiple ways to have
            % theta and multiple ways to calculate alpha
            % , i.e. multiple frequency ranges)

                % create first empty bandsUsed entries for previous
                % bins 
                for ijk = 1 : handles.indexToEndIndivBins
                    handles.eegBins.bandsUsed{ijk} = {''; ''};                    
                end

                %% Now define the ratios                
                handles.eegBins.bandsUsed{ik} = {'alpha'; 'theta'};
                handles.eegBins.bandsUsed{ik+1} = {'high alpha'; 'theta'};
                handles.eegBins.bandsUsed{ik+2} = {'around peak Narrow'; 'theta'};
                handles.eegBins.bandsUsed{ik+3} = {'around peak Broad'; 'theta'};
                handles.eegBins.bandsUsed{ik+4} = {'at Peak'; 'theta'};
                
                handles.eegBins.bandsUsed{ik+5} = {'around peak Narrow'; 'theta narrow'};
                handles.eegBins.bandsUsed{ik+6} = {'around peak Broad'; 'theta narrow'};
                handles.eegBins.bandsUsed{ik+7} = {'at Peak'; 'theta narrow'};
                handles.eegBins.bandsUsed{ik+8} = {'around peak Narrow'; 'theta broad'};
                handles.eegBins.bandsUsed{ik+9} = {'around peak Broad'; 'theta broad'};
                
                handles.eegBins.bandsUsed{ik+10} = {'at Peak'; 'theta broad'};
                handles.eegBins.bandsUsed{ik+11} = {'around peak Narrow'; 'theta mid'};
                handles.eegBins.bandsUsed{ik+12} = {'around peak Broad'; 'theta mid'};
                handles.eegBins.bandsUsed{ik+13} = {'at Peak'; 'theta mid'};
                handles.eegBins.bandsUsed{ik+14} = {'high-alpha Lockley'; 'theta mid'};
                
                handles.eegBins.bandsUsed{ik+15} = {'alpha Putilov2013 Oz'; 'theta Putilov2013 Oz'};
                handles.eegBins.bandsUsed{ik+16} = {'alpha Peak Oz'; 'theta narrow Oz'};
                handles.eegBins.bandsUsed{ik+17} = {'alpha Peak Oz'; 'theta broad Oz'};
                handles.eegBins.bandsUsed{ik+18} = {'around peak Narrow Oz'; 'theta narrow Oz'};
                handles.eegBins.bandsUsed{ik+19} = {'around peak Narrow Oz'; 'theta broad Oz'};
                

                %% create the labels for the defined bandsUsed above
                for ikj = handles.indexToStartRatioBins : length(handles.eegBins.bandsUsed)
                    
                    [str1, ind1] = init_generateRatioBinLabels(handles.eegBins.bandsUsed{ikj}{1}, handles.eegBins, ikj, handles);
                    [str2, ind2] = init_generateRatioBinLabels(handles.eegBins.bandsUsed{ikj}{2}, handles.eegBins, ikj, handles);

                    handles.eegBins.freqs{ikj}{1} = handles.eegBins.freqs{ind1};
                    handles.eegBins.freqs{ikj}{2} = handles.eegBins.freqs{ind2}; 

                    handles.eegBins.label{ikj} = sprintf('%s%s\n%s', str1, ' : ', str2);
                    handles.eegBins.indices{ikj}{1} = ind1;
                    handles.eegBins.indices{ikj}{2} = ind2;
                    handles.eegBins.ch{ikj}{1} = handles.eegBins.ch{ind1};
                    handles.eegBins.ch{ikj}{2} = handles.eegBins.ch{ind2};
                    
                    % now we need to add a flag whether we used an
                    % individual alpha (or any other individual band) for
                    % the ratio so that the individual peak can be
                    % correctly added for the relative frequencies on 
                    % "compute_EEG_perFreqBands"                    
                    handles.eegBins.indivFlag{ikj} = logical([0 0]); % preallocate
                    
                    % for the numerator of the ratio, e.g. alpha
                    if ind1 >= handles.indexToStartIndivBins && ind1 <= handles.indexToEndIndivBins
                        handles.eegBins.indivFlag{ikj}(1) = 1;
                    end
                    
                    % for the denominator of the ratio, e.g. theta
                    if ind2 >= handles.indexToStartIndivBins && ind2 <= handles.indexToEndIndivBins
                        handles.eegBins.indivFlag{ikj}(2) = 1;
                    end                    

                end

            handles.indexToEndRatioBins = length(handles.eegBins.label);

            
        %% Finally correct the bin limits
        % correct the indices, e.g. 0.25 Hz resolution does not work
        for k = 1 : handles.indexToEndIndivBins      
            handles.eegBins.freqs{k} = compute_checkFreqLimits(handles.eegBins.freqs{k}, handles.eegBins.freqResolution);    
        end
        
        for k = handles.indexToStartRatioBins : handles.indexToEndRatioBins
            handles.eegBins.freqs{k}{1} = compute_checkFreqLimits(handles.eegBins.freqs{k}{1}, handles.eegBins.freqResolution);    
            handles.eegBins.freqs{k}{2} = compute_checkFreqLimits(handles.eegBins.freqs{k}{2}, handles.eegBins.freqResolution);    
        end
        
        
        %% Precalculate the indices corresponding to the frequency vector
        % (these values are used in compute_EEG_perFreqBands and it is a
        % lot faster to just compute them once rather than inside the loop
        
            Fs = 2048; % note this is constant now, if Fs something else, this will FAIL HERE
            divider = 2; % 2 for one-sided
            freqVectorEnd = (handles.eegSet.wd * Fs * handles.eegBins.freqResolution) / divider; 
            freqVector = 0 : handles.eegBins.freqResolution : freqVectorEnd;
        
            for k = 1 : handles.indexToEndIndivBins      
                handles.eegBins.freqIndices{k} = init_preComputeFrequencyIndices(handles.eegBins.freqs{k}, freqVector, handles);
            end

            for k = handles.indexToStartRatioBins : handles.indexToEndRatioBins
                handles.eegBins.freqIndices{k}{1} = init_preComputeFrequencyIndices(handles.eegBins.freqs{k}{1}, freqVector, handles);
                handles.eegBins.freqIndices{k}{2} = init_preComputeFrequencyIndices(handles.eegBins.freqs{k}{2}, freqVector, handles);
            end        
    
    
          
        
            
    %% LOCAL SUBFUNCTIONS
    function [str, ind] = init_generateRatioBinLabels(bandStr, eegBins, ikj, handles)        

        % find the frequency range of the bandStr
        ind = [];
        for i = 1 : handles.indexToEndIndivBins

            % a = eegBins.label{i}
            if strcmp(bandStr, eegBins.label{i}) == 1
                % we have a match
                freq =  eegBins.freqs{i};            
                ind = i;
                break
            end       
        end

        if isempty(ind)
            % that label not found                
            error(['"', bandStr, '"', '  Error in your ratio (ratioBand = ', num2str(ikj), ') band definition! Check it! Maybe a typo?'])                 
        end        

        str = sprintf('%s%s%s %s%s%s', bandStr, ' (', num2str(freq(1)), ':', num2str(freq(2)), ' Hz)');