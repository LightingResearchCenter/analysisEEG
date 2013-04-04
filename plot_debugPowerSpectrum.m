function plot_debugPowerSpectrum(fd, cosineWindow, Hmss, Fs, handles)        

        fileName = 'Subject 50_Period 1_Color d_Trial 1_processed_ch3.txt';
        oldData = importdata(fileName);
            % rows are frequencies
            % cols are time epochs

            % OLD CODE
            % alpha is 8 - 12 Hz on Pz and Oz
            % dalpha(sub(s) - 49, period(s) + 3*(trial(s) - 1)) = mean([ps(335:343);ps(415:423)]);

            % 335-343 rows of Excel sheet, 8 - 12 Hz Ch5 Pz
            % 415-423 rows of Excel sheet, 8 - 12 Hz Ch6 Oz

        % original lines
        X1 = abs(fft(cosineWindow .* fd)); % absolute values
        % X1 = X1(1:length(fd)/2+1); % one-sided DFT (added by Petteri)

        ps1 = X1 ./ (length(X1) / 2); % e.g. ps / 2048, why dividing by 2
        ps1 = ps1 .^ 2;

        % matlab demo
        X2 = (fft(fd .* cosineWindow) / length(fd));
        X2 = X2(1:length(fd)/2+1); % one-sided DFT

        ps2 = abs(X2).^2; % Compute the mean-square power
        ps2(2:end-1) = 2*ps2(2:end-1); % Factor of two for one-sided estimate

        % 
        % % calculate PSD using the Welch method
        % 
        %    % Parameters
        %    overlapPercent = 0; % the overlapping has been done in compute_PSDfromBDF
        %    segmentLength = length(fd);
        % 
        %    % Construct the PSD Estimator
        %    Hs = spectrum.welch({'tukey',handles.eegSet.tukeyR}, segmentLength, overlapPercent);            
        %    xWelch = psd(Hs,fd,'Fs',Fs);

       rows = 2;
       cols = 2;               

       scrsz = get(0,'ScreenSize'); % get screen size for plotting;
       fig = figure('Color', 'w', ...
           'Position', [0.1*scrsz(3) 0.1*scrsz(4) 0.8*scrsz(3) 0.8*scrsz(4)]);

       % frequency vector           
       f = Fs/2*linspace(0,1,length(fd)/2+1);

       % time-domain data
       subplot(rows,cols,1)

           hold on
                plot(fd, 'b')
                plot(fd .* cosineWindow, 'r')
           hold off

           title('Time-Domain data (EEG Voltage)')
           xlabel('Sample #')
           ylabel('y(t)') 
           xlim([0 length(fd)])

           legend('Raw', 'Windowed')
                legend('boxoff')

           Str1 = fileName;

           % whos

       % Plot single-sided amplitude spectrum.         
       subplot(rows,cols,2)

           indices = [(4096-2049+1):4096];
           ps1trim = ps1(1:length(ps1)/2+1); % one-sided DFT

           semilogy(Hmss.frequencies, Hmss.Data, 'b', f, ps1trim, 'r', f, ps2, 'g', oldData(:,1), oldData(:,w+1), 'k') 

           title('Single-Sided Amplitude Spectrum of y(t)')
           xlabel('Frequency (Hz)')
           ylabel('|Y(f)|')           
           xlim([handles.eegSet.lowCut handles.eegSet.highCut])
           grid on                              

           Str2 = ['Ch = ', num2str(ch), ', Epoch = ', num2str(w)];         

           legend('dspdata.msspectrum', 'Okamoto', 'Matlab FFT demo', 'Okamoto XLS file')
           legend('boxoff')


       % Original two-sided amplitude spectrum
       subplot(rows,cols,3)

            semilogy(ps1)
            title('Double-Sided Amplitude Spectrum of y(t)')

       subplot(rows,cols,4)               

            t(1) = text(0.1, 0.9, Str1);
            t(2) = text(0.1, 0.7, Str2);
            t(3) = text(0.1, 0.5, 'One channel copy+pasted from "Subject 50_Period 1_Color d_Trial 1_processed.xls"');
            axis off
            set(t, 'Interpreter', 'none')


       % export to disk
       try
            if handles.figureOut_ON == 1      
                drawnow
                dateStr = getDateString(); % get current date as string
                %cd(path.outputFigures)            
                fileNameOut = sprintf('%s%s%s%s', Str1, '_Epoch-', num2str(w), '.png');
                export_fig(fullfile(handles.path.figuresOutIndiv, fileNameOut), handles.figureOut_resolution, handles.figureOut_antialiasLevel, fig)
                %cd(path.code)
            end
       catch
            str = sprintf('%s\n%s', 'Crashing probably because you have not installed export_fig from Matlab File Exchange!', ...
                          'Download it from: http://www.mathworks.com/matlabcentral/fileexchange/23629-exportfig, and "File -> Set Path -> Add Folder"');
            error(str)

       end

       pause
       close all

  

