% Funciton that processes individual .bdf containing the data from the EEG
% recording
function ps_bins = computeMain(filename, sub, period, trial, color, eegSet, s, savenameMAT, savenameXLS, handles)
     
    %% Unwrap the settings from eegSet structure
    
        dataLengthSec = eegSet.wd; % data length[s], originally 2
        runningStepSec = eegSet.rs; % running step[s], originally 1
        lr = eegSet.lr; % dataLengthSec*0.1; %10% cosine window      
        low = eegSet.lowCut;
        high = eegSet.highCut;
        filterType = eegSet.filterType; % string, butter, bessel, etc.
        filterOrder = eegSet.filterOrder;
        ppRipple = handles.eegSet.ppRipple;
        
        % remove the path from filename
        fid = filename;
        if isunix
            a = textscan(fid, '%s', 'Delimiter', '/');
        elseif ispc
            a = textscan(fid, '%s', 'Delimiter', '\');
        end
        fileNameWoPath = cell2mat(a{1}(length(a{1})));
        fileNameWoPath = strrep(fileNameWoPath, '.bdf', '.mat');
        
        % save to an identifiers structure that is eventually used when
        % saving the output
        identifiers.filename = filename;
        identifiers.fileNameWoPath = fileNameWoPath;
        identifiers.sub = sub;
        identifiers.period = period;
        identifiers.trial = trial;
        identifiers.color = color;        
        %disp(['        ', identifiers.filename])
        
        
    %% IMPORT THE DATA from the FILE        
        
        % Check first if the results can be directly loaded from the disk
        if handles.processBdfFiles == 0 % from MAT files
            try
                load(fullfile(handles.path.BDFsAsMAT, fileNameWoPath));
            catch % if that specified MAT file did not exist
                warning('You have not yet saved any MAT for imported BDFs. Importing the BDF file')
                handles.processBdfFiles = 1;
            end
        end
            
        if handles.processBdfFiles == 1
            % [rawEEG_orig, data] = import_dataFromBDF_Orig(filename);
            % [rawEEG1, data1] = import_dataFromBDF(filename);        
            channelsToBeRead = [1 2 3 4 5 6 7];
            [data, rawEEG] = import_AndyReadBDFrev2(filename, channelsToBeRead);
            
                %% MANUAL FIX
                data.sampleRate = 2048;
            
            % transpose the rawEEG to match old code
            rawEEG = rawEEG';
            
            %             whos
            %             hold on
            %             plot(rawEEG, 'b')
            %             plot(rawEEG1, 'r')
            %             hold off            
            %             pause
        end

    %% SUBTRACT THE REFERENCE
    
        % disp('            filtering and computing power spectrum')
        
        % Re-define the number of channels to be analyzed as the last two
        % channels [EX8 (ECG) and Status] are not of an interest to us
        noOfChannels = length(channelsToBeRead);
        
        % call the subfunction 
        % Reference Voltage, mean of the Channels 1 and 2
        Ref = (rawEEG(1,:) + rawEEG(2,:)) /2;
        EEG = compute_subtractReferenceFromChannels(Ref, rawEEG, noOfChannels);        

    %% FILTER THE DATA   
    
        % Bandpass filter the data using a subfunction
        EEG_filt = compute_filterTheDataEEG(noOfChannels, EEG, data.sampleRate, low, high, filterType, filterOrder);
        

    %% CUSTOM FILTERING (Trigger, EOG, subject
        
        % PETTERI: Not really understanding everything that happened here
        % (thus, the name "custom filtering"
        [Trig1, EEG_filtT, EOG] = compute_customFiltering(sub, trial, color, period, EEG_filt, data.sampleRate, handles);
        

    %% COMPUTE THE PARAMETERS from the filtered EEG Data now
    
        % input arguments, defined on initDefaultSettings.m
        % dataLengthSec - data length[s], default 2
        % rs - running step[s], default 1
        % lr - e.g. dataLengthSec*0.1; %10% cosine window        
        Fs = data.sampleRate;
        nrOfWindows = 1 + (length(EEG_filtT(1,:))-(dataLengthSec*Fs)) / (runningStepSec*Fs);  % e.g. 1 + (333824 - (2*2048)) / (1*2048) = 1 + 148 = 149
        nrFreqPoints = ((dataLengthSec*Fs) / 2)+1;
        noOfChannels = length(EEG_filtT(:,1));               

            % Preallocate the matrix        
            psdata = zeros(noOfChannels, nrFreqPoints, nrOfWindows);
                % e.g. size: 7 x 2049 x 148 for one-sided spectrum

            % Preallocate the cell for bins to be returned as output argument
            % from this whole computeMain        
            ps_bins = cell(noOfChannels, 1);                
        
        %% Get the individual Alpha peak of this subject        
        indivPeak = compute_EEG_IndivAlphaPeakPerSubject(identifiers.sub, handles);  
        
            %% manual fix
            indivPeak = round(indivPeak * 2);
            indivPeak = indivPeak / 2;
            % disp(['           indivPeak = ', num2str(indivPeak)])
        
        %% Go throught the channels
        % number of rows, i.e. number of channels (e.g. 7)
        for ch = 1 : noOfChannels            
            
            % THE MAIN COMPUTATIONS take place inside this
            [ps_bins{ch}, psdata(ch,:,:)] = compute_EEG_perChannel(ch, EEG_filtT(ch,:), psdata(ch,:,:), EOG, indivPeak, runningStepSec, dataLengthSec, data.sampleRate, nrOfWindows, nrFreqPoints, noOfChannels, identifiers, savenameXLS, handles);
            
                % Note: Inside the subfunction you have additional
                % subfunctions to go through the data per TIME EPOCHS and
                % per FREQUENCY BINS
                
        end        
        
        %% EXCEL SAVE                       
        if handles.saveToExcelFiles == 1
            compute_saveEEGRaw_ToExcel(ps_bins, identifiers, handles.eegSet.excelOut, savenameXLS, handles)            
        end
