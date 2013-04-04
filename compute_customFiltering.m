% Only R. Hamner I guess now the function of this exactly
function [Trig1, EEG_filtTrim, EOG] = compute_customFiltering(sub, trial, color, period, EEG_filt, Fs, handles)

    % Special conditions for some subjects (Petteri?)
    if(((sub == 75) || (sub == 76)) && (trial == 2))
        recordingLength = 1.5; % length of EEG period [min]
    else
        recordingLength = 2.5;
    end     

    %% rejects the first 5 seconds
    
        % Import the timing range from the text file (fixed for all the
        % recordings of one experiment, added absed on the meeting on 8th
        % March 2013 in the conference room with Mariana, Levent, Geoff and
        % Andy)

            filenameTimes = fullfile(handles.path.cloudInputFiles, handles.eegBins.timingFile);
            fid2 = fopen(filenameTimes,'r');
            timesIn = textscan(fid2, '%s%d%d', 'HeaderLines', 1);
                experimentIdentifier = timesIn{1};
                trimStartTime = cell2mat(timesIn(2)); % in seconds
                trimEndTime   = cell2mat(timesIn(3)); % in seconds, NOT USED at the moment
                                                      % as we had that
                                                      % manual fix for
                                                      % recording length
                                                      % above
                
                % so the idea is to skip the first five seconds and then read
                % the subsequent 150 seconds (2.5 minutes) and ignore the rest.
                % the trimming times could change based on the experiment.     
                
            % for get rid of the first x seconds (specified in the text
            % file)
            trimIndexStart = (trimStartTime * Fs) + 1;            
            EEG_filtTrim_1stPass = EEG_filt(:, trimIndexStart:end); % e.g. 7x323584
            
            % end then get rid of the extra samples at the end of the file
            secondsInMinute = 60;
            trimIndexEnd = recordingLength * secondsInMinute * Fs;
            if trimIndexEnd > length(EEG_filtTrim_1stPass) % if index too large
                trimIndexEnd = length(EEG_filtTrim_1stPass);
                disp(['     subject = ', sub, ', length of data = ', length(EEG_filtTrim_1stPass)])
            end
            EEG_filtTrim = EEG_filtTrim_1stPass(:, 1:trimIndexEnd); % e.g. 7x307200       
                
                % ORIGINAL from R. Hamner
                %{
                if(size(EEG_filt, 2) > 317441) % If the number of data samples is
                more than 317'441, why this limit?

                    EEG_filtT=EEG_filt(:, 10241 : 10241+Fs*60*El-1);
                else
                    EEG_filtT=EEG_filt(:,1:1+Fs*60*El-1);
                end    
                %}

    %% EOG Data, used later for filtering out the artifacts
    
        % This EOG vector is re-defined at the moment in
        % compute_removeArtifacts where it is used to reject data epochs with
        % artifacts
        % EOG = rawEEG(7, rs*Fs*(w-1)+1:rs*Fs*(w-1)+(wd*Fs));
        % EOG=r(7,I(1):I(1)+Fs*60*El-1); (OkamotoPS)
        EOG = EEG_filtTrim(7,:);            
     
        
    %% Get triggers
    
        % This is the STATUS channel now apparently, it is not used in
        % anyway at the moment, what information did it contain (Petteri?)
        % Trig1 = rawEEG(channels,:);
        Trig1 = [];
            % size, e.g. 1x333824

    %% If you want to plot each of the channels
    % does not work atm (Petteri)
    if handles.saveIndivivEEGsAsFigures == 1
        
        % from R. Hamner
        
        % Create time vector
        t = 0 : length(EEG_filtTrim(1,:))-1;
        T = t ./ Fs; % correct with the sampling rates so that units are seconds
        
        for z = 1:length(EEG_filtTrim(:,1)); % z is now the channel
            figure()
            plot(T,EEG_filtTrim(z,:))
            axis([0,150,-100,100]);
            title(['Subject ', num2str(sub), ' _ Period ', num2str(period), ' _ Trial ', num2str(trial), ' _ Color ', num2str(color), ' - Channel ', num2str(z)])
            pathTmp = ['C:\LRC\2012_FALL\EEG_ONR_DAY\HAMNER\EEG figures\Subject ', num2str(sub), '_Period ', num2str(period), '_Color ', color, '_Trial ', num2str(trial), '_Channel ', num2str(z), '.png'];
            saveas(gcf, pathTmp)
        end
    end