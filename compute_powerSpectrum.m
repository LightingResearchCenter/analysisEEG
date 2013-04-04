% Subfunction to calculate the PSD from voltage samples
function [ps,Hmss] = compute_powerSpectrum(ch, w, fd, Fs, freqVector, savenameXLS, handles)

       % OUTs
       % ps    - mean-square power spectrum
       % Hmss  - handle for the MeanSquareS object/structure       
       
           % for quick debugging, if no input arguments are given, this
           % function can be tested directly from here without having to run
           % the analysis from the start
           if nargin == 0
               handles = init_defaultSettings();
               load(fullfile(handles.path.debugMatFiles, 'powerSpectrumTemp.mat'))
           else
               if handles.saveTempDebugMATs == 1
                    save(fullfile(handles.path.debugMatFiles, 'powerSpectrumTemp.mat'))
               end
           end
       
       if handles.showDebugMessages == 1
            %disp('compute_powerSpectrum')
            %whos
       end
       
       % create synthetic data just to test the algorithms
       useSynthetic = 0;       
       if useSynthetic == 1
           T = 1/Fs;                     % Sample time
           L = length(fd);               % Length of signal
           t = (0:L-1)*T;                % Time vector
           % Sum of a 4 Hz sinusoid and a 12 Hz sinusoid
           x = 0.7*sin(2*pi*4*t) + sin(2*pi*12*t); 
           fd = x + 2*randn(size(t));     % Sinusoids plus noise
       end
       
       % Previous Circadian EEG studies have used 10% Cosine Window 
           % * Aeschbach et al. (1999); http://www.ncbi.nlm.nih.gov/pubmed/10600925
           % * Cajochen et al. (2005); http://dx.doi.org/10.1210/jc.2004-0957
           % * Lockley et al. (2006); http://www.ncbi.nlm.nih.gov/pubmed/16494083
           
       % which is the same as r = 0.1 for Tukey window
           % http://www.mathworks.com/help/signal/ref/tukeywin.html
           
           % Parameters            
           r = handles.eegSet.tukeyR; % Tukey window with r=0.10 is 10% cosine window            
           cosineWindow = (tukeywin(length(fd),r))';
           
           % original implementation (OkamotoPS_func_notrigger.m)
           ps = abs(fft(fd .* cosineWindow));
           ps = ps./(length(ps)/2);
           ps = ps.^2;           
           
       %% Calculate Power Spectrum (mean-square power spectrum)       
            
            % X = fft(fd .* cosineWindow);    % taper with a cosine window
            X = fft(fd);    % taper with a cosine window
            X = X(1 : (length(fd)/2 + 1));  % one-sided DFFT
            ps2 = (abs(X) / length(fd)) .^2; % Compute the mean-square power
            ps2(2:end-1) = 2 * ps2(2:end-1);  % Factor of two for one-sided estimate
            
            % Estimate Pms at all frequencies except zero and the Nyquist
            Hmss = dspdata.msspectrum(ps2, 'Fs', Fs, 'spectrumtype', 'onesided'); % , 'ConfLevel', handles.eegSet.binConfP);

            
            %         Hmss =
            % 
            %                Name: 'Mean-Square Spectrum'
            %                Data: [2049x1 double]
            %        SpectrumType: 'Onesided'
            % NormalizedFrequency: false
            %                  Fs: 2048
            %         Frequencies: [2049x1 double]
            %           ConfLevel: 0.9500
            %        ConfInterval: []            
    
            
       %% DEBUG PLOT
       
           debugFFT = 0;       
           if debugFFT == 1 && ch == 3 % Fz               
               plot_debugPowerSpectrum(fd, cosineWindow, Hmss, Fs, handles)             
           end
               
               