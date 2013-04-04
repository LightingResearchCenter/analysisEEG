function handles = init_defaultSettings()

    %% Display on command window
    
        % http://www.network-science.de/ascii/, font "rectangle"
        cl = fix(clock); hours = num2str(cl(4)); % get the current time
        if cl(5) < 10; mins = ['0', num2str(cl(5))]; else mins = num2str(cl(5)); end
        disp(' ');
        disp(' _____ _____ _____    _____         _         _      ')
        disp('|   __|   __|   __|  |  _  |___ ___| |_ _ ___|_|___  ')
        disp('|   __|   __|  |  |  |     |   | . | | | |_ -| |_ -| ')
        disp('|_____|_____|_____|  |__|__|_|_|__,|_|_  |___|_|___| ')
        disp('                                     |___|           ')
        disp(['Initiated: ', date, ', ', hours, ':', mins])
        disp('-------'); 
        

    %% SET PATHS  
    
        %% MAIN FOLDERS (change only this if you change the folder locations
        if isunix % UNIX                        
            handles.path.mainCode = mfilename('fullpath'); % Setting the path for the code
            handles.path.mainCode = strrep(handles.path.mainCode,'init_defaultSettings',''); % Removing the filename from the path         
            handles.path.localMatlabFolder = fullfile('/home', 'petteri', 'EEG-Data'); % at home, avoiding to put a alot of data to Dropbox                                     
            
        elseif ispc % Windows                 
            warndlg('Check that the folders/paths are defined correctly!')
            handles.path.mainCode = mfilename('fullpath'); % Setting the path for the code
            handles.path.mainCode = strrep(handles.path.mainCode,'init_defaultSettings',''); % Removing the filename from the path         
            handles.path.localMatlabFolder = fullfile('C:', 'folder1', 'EEG-Data'); 
            
        elseif ismac % MAC
            warndlg('This has not been tested on Mac, but should work as long as you define the paths correctly!')
            handles.path.mainCode = mfilename('fullpath'); % Setting the path for the code
            handles.path.mainCode = strrep(handles.path.mainCode,'init_defaultSettings',''); % Removing the filename from the path         
            handles.path.localMatlabFolder = fullfile('Users', 'username', 'EEG-Data');
            
        else
            errodlg('What platform you have? [Windows/PC/Linux]')
        end
        
        %% Define derived subfolders from the main folders
        % no need to modify unless you knw what you are doing or/and are
        % developing/modfying the code
        handles = init_derivedPathNames(handles);
        
            %% For further customization you could construct conditionals based on
            %  http://www.mathworks.com/matlabcentral/newsreader/view_thread/270638
            %
            % * computer name
            %        computerName = computerName.getHostName()
            % * local host
            %        computerName = java.net.InetAddress.getLocalHost()
            % * user name
            %        userName = java.lang.System.getProperty('user.name')
        
    
    %% SETTINGS      
    
        % EEG Analysis settings
        handles.eegSet.wd = 2; % data length[s], originally 2
        handles.eegSet.rs = 1; % running step[s], originally 1
        handles.eegSet.lr = handles.eegSet.wd * 0.1; % 10% cosine window
        
        handles.eegSet.tukeyR = 0.1; % 10% cosine window for spectrum (Signal Processing)
        handles.eegSet.lowCut = 0.4; % low-cut frequency for the EEG data
        handles.eegSet.highCut = 40; % high-cut frequency for the EEG data
        
        handles.eegSet.filterType = 'butter';
        handles.eegSet.filterOrder = 3;
        handles.eegSet.ppRipple = 0.01; % dB of peak-to-peak ripple
        
        handles.eegSet.binConfP = 0.95; % confidence level (alpha) for confidence intervals
                                        % used when calculating the power
                                        % spectrum (dspdata.msspectrum)
                                        % e.g. http://www.mathworks.com/products/signal/examples.html?file=/products/demos/shipping/signal/spectralanalysisobjsdemo.html#19
                                        
        handles.eegSet.noOfChannelsToOmit = 2; % with "2" we are now getting rid of EX8 (ECG) and Status channels now
                                               % computeMain ->
                                               % compute_subtractReferenceFromChannels
                                               % (so the last two channels)
        % Artifact thresholds        
        handles.eegSet.artifactThr_eFixed = 100; % fixed threshold (mV) of artifacts
        handles.eegSet.artifactThr_eEyeEOG = 40; % fixed threshold for rejecting epochs based on EOG data (mV)
                                                 % i.e. potentials over 40
                                                 % mV are considered to be
                                                 % caused by blinks
                                               
        % for Excel save
        handles.eegSet.excelOut.freqMin = 1; % Hz
        handles.eegSet.excelOut.freqMax = 40; % Hz
        handles.eegSet.excelOut.wd = handles.eegSet.wd; % Hz
        
        % EEG organizing settings
        handles.eegSet.conditionsOnFiles = {'d';'r';'w'};
        
        %% Bins of interest
        
            % CHANNEL LUT
            % NOTE two first channels omitted now, and these correspond to
            % the indices coming out from compute_PSDfromBDF
            
                % ch1&2 - EX1 and EX2 are reference channels (right and left earlobes) 
                handles.eegBins.chName{1} = 'Ref_RightEar'; 
                handles.eegBins.chName{2} = 'Ref_LeftEar'; 
                handles.eegBins.chName{3} = 'Fz'; % ch3 - EX3: Fz
                handles.eegBins.chName{4} = 'Cz'; % ch4 - EX4: Cz
                handles.eegBins.chName{5} = 'Pz'; % ch5 - EX5: Pz
                handles.eegBins.chName{6} = 'Oz'; % ch6 - EX6: Oz
                handles.eegBins.chName{7} = 'EOG'; % ch7 - EX7: EOG (was put below the right eye)
                handles.eegBins.chName{8} = 'HR'; % ch8 - EX8: Heart Rate (was put on the chest)   
                handles.eegBins.chName{9} = 'Status'; % ch9 - "Status"
                
                handles.chsToBeRead = 7; % skips  the 8 and 9 and also all the "dummy channels" all the way up to 32 which
                                         % just take needless CPU time, see
                                         % import_dataFromBDF this in action
                
                handles.eegBins.freqResolution = 0.5;                
                handles.eegBins.includeUpperLimit = 1; % if zero the upper limit frequency is included in the data
                                                       % used in compute_EEG_perFreqBands
                                                       
                handles.eegBins.timingFile = 'recordingTime.txt'; % in "input" folder (see above)
                
            %% Use subfunction to define the bins
            handles = init_defineFrequencyBins(handles);   

    %% Statistical Parameters
    
        globalAlpha_threshold       = 0.05;
        handles.shapWilk_pThreshold = globalAlpha_threshold;
        handles.bartlett_pThreshold = globalAlpha_threshold;
        
        handles.anova_pThreshold    = globalAlpha_threshold;
        handles.wilcox_doPaired     = 0;
        handles.wilcox_pThreshold   = globalAlpha_threshold;
        handles.wilcox_method       = 'approximate'; % will be set automatically by the result from mwwtest.m
        handles.student_pThreshold  = globalAlpha_threshold;
            
    %% PLOT STYLING
    
        handles.style.fontName = 'Latin Modern Roman';
        handles.style.fontSizeBase = 10;
        
        
        