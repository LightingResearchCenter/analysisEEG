% Pasband filter the EEG data
function EEG_filt = compute_filterTheDataEEG(noOfChannels, EEG, Fs, low, high, filterType, filterOrder)

    % Preallocate memory for the FILTERED EEG data, see below how the
    % EEG data is bandpass filtered, now omitting the first two
    % channels that are the reference channels        
    EEG_filt=zeros(noOfChannels, length(EEG));

        for fi = 1: noOfChannels

             % input arguments, defined on initDefaultSettings.m
             
                % low - low-cut frequency for the EEG data
                % high - high-cut frequency for the EEG data

             % Redefine the cutoff frequencies with the Nyquist criterion
             nyq = Fs/2;
             low2 = low/nyq;
             high2 = high/nyq;
             passband = [low2 high2];

             % Design the filter 
             if strcmp(filterType, 'butter')
                 [Bb Ab] = butter(filterOrder, passband);
             elseif strcmp(filterType, 'cheby1')
                 [Bb Ab] = cheby1(filterOrder, ppRipple, passband);            
             else
                 errordlg('Filter type incorrectly defined for EEG')
             end

             % Filter the data
             EEG_1 = filter(Bb,Ab,EEG(fi,:));
             EEG_2 = filter(Bb,Ab,EEG_1);

             % The final filtered EEG data now
             EEG_filt(fi,:)=EEG_2;
                % size the same as with raw data: 7x333824 (rows x columns)
                
        end