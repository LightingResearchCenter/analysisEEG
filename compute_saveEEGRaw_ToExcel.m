% Saves the raw frequency bins to Excel file, previous was inside the
% function "OkamotoPS_func_notrigger"
function compute_saveEEGRaw_ToExcel(ps_bins, identifiers, excelSettings, savename, handles)

    % for faster debugging / developing
    if nargin == 0
        handles = init_defaultSettings();
        load(fullfile(handles.path.debugMatFiles, 'tempExcelPowerSpectra.mat'))
    else
        if handles.saveTempDebugMATs == 1
            save(fullfile(handles.path.debugMatFiles, 'tempExcelPowerSpectra.mat'))
        end
    end
    
    %{
    whos
    a1 = identifiers.sub
    a2 = identifiers.period
    a3 = identifiers.trial
    a4 = identifiers.color    
    %}

    % freqMin - save data from this x Hz, e.g. 1 Hz
    freqMin = excelSettings.freqMin;
    % freqMax - save data until this x Hz, e.g. 40 Hz
    freqMax = excelSettings.freqMax;
    
    
    %% CREATE THE MATRICES
    % inside a cell, so that each cell element corresponds to the 
    % channels
    
    for ch = 1 : length(ps_bins) % no of channels        
        
       rows = handles.indexToEndGeneralBins - handles.indexToStart_05HzBins;
       cols = length(ps_bins{ch}) + 1; % the extra frequency vector in addition to power spectra
       
       xdata{ch}.alldata = zeros(rows,cols);
       offset = handles.indexToStart_05HzBins;
       
       for k = (handles.indexToStart_05HzBins + 1) : handles.indexToEndGeneralBins
           
           % disp(['!!: ', num2str(ps_bins{ch}{1}{k}.freqs), ', ', ps_bins{ch}{1}{k}.label])
           
           freqValue = ps_bins{ch}{1}{k}.powerSpec_frequencies;
           xdata{ch}.freqVector(k-offset,1) =  freqValue; % first frequency (should be the same the second index)
           xdata{ch}.alldata(k-offset,1) = freqValue;           
                     
           for w = 1 : length(ps_bins{ch})
               
               power = ps_bins{ch}{w}{k}.data.powerSpectrum;
               xdata{ch}.powerSpecMatrix(k-offset,w) = power;
               xdata{ch}.alldata(k-offset,1+w) = power;               
               
               if w == 1
                    % disp([freqValue power])
               end
       
               % The structure of the data in the .MAT file is the following

                    % ch - channel index, (e.g. from 1 to 7)
                    % w  - number of epochs (e.g. 149)
                    % k  - number of different frequency bins (e.g. 132)
                    %      see initDefaultSettings.m for definitions

                    % EEG Bin settings
                        % ps_bins{ch}{w}{k}.freqs
                        % ps_bins{ch}{w}{k}.label
                        % ps_bins{ch}{w}{k}.ch

                            % Now note that after the initial run, you can
                            % change the label channels freely, but the
                            % freqs affected on what frequencies were taken
                            % from the full Power Action spectrum.

                    % EEG Freqs (in the bin), and the DATA
                        % ps_bins{ch}{w}{k}.frequencies
                        % ps_bins{ch}{w}{k}.data           
                        
           end
           
       end
       
       % xdata{ch}.alldata
       % pause
                
    end
    
    
    
    %% WRITE TO EXCEL SHEET
    
        for ch = 1 : length(xdata)            
            sheetString = ['Channel',num2str(w)];            
            %xlswrite(fullfile(handles.path.excelPowerSpectra, savename), xdata{ch}.alldata, sheetString);
        end
        
    %% WRITE AS TEXT FILE
    
        for ch = 1 : length(xdata)      
            
            % remove unnecessary garbage from the filename
            savename = strrep(savename, handles.path.excelOutDebug, '');
            savename = strrep(savename, '.xls', '.txt');           
            
            if ch == 1
                dlmwrite(fullfile(handles.path.excelPowerSpectra, savename), xdata{ch}.alldata, 'delimiter', '\t');
                dlmwrite(fullfile(handles.path.excelPowerSpectra, savename), ['Ch', num2str(ch+1)], '-append', 'delimiter', ''); % empty row
            else
                dlmwrite(fullfile(handles.path.excelPowerSpectra, savename), xdata{ch}.alldata, '-append', 'delimiter', '\t');
                
                if ch < length(xdata)
                    dlmwrite(fullfile(handles.path.excelPowerSpectra, savename), ['Ch', num2str(ch+1)], '-append', 'delimiter', ''); % empty row with channel identifier
                end
            end
            
        end
        
        
    %% QUICK'n'DIRTY compare to previous EXCEL SHEET
    quicknDirtyPlot = 0;
    if quicknDirtyPlot == 1
        
        % could do systemically also reading all the excel sheets from
        % Windows Network
        
        fileIn = 'Subject 50_Period 1_Color d_Trial 1_processed_ch3.txt';
        oldData = importdata(fullfile(handles.path.excelOutDebug, fileIn), '\t');
        save('Subject 50_Period 1_Color d_Trial 1_processed_ch3.mat', 'oldData')
        
        ch = 3;
        rows = 4;
        cols = 6;
        
        scrsz = get(0,'ScreenSize'); % get screen size for plotting;
               fig = figure('Color', 'w', ...
                   'Position', [0.1*scrsz(3) 0.1*scrsz(4) 0.8*scrsz(3) 0.8*scrsz(4)]);
               
                handles.figureOut_resolution = '-r300';  
        
        jjCount = 1;
        for w = 1 : length(ps_bins{ch})
            
            jj = w - ((jjCount-1)*rows*cols);
            
                subplot(rows,cols,jj)
                
                    x1 = xdata{ch}.alldata(:,1);
                    x2 = oldData(:,1);                    
                
                    semilogy(x1, xdata{ch}.alldata(:,w+1), 'r', ...
                         x2, oldData(:,w+1), 'b')

                    title(num2str(w))
                    xlabel('Frequency [Hz]')
                    ylabel('Power [\muV^2]')


                    if jj == rows*cols
                        
                        legend('New code', 'Old code')                        
                        
                        % export to disk
                        try
                            if handles.figureOut_ON == 1      
                                drawnow
                                dateStr = getDateString(); % get current date as string
                                %cd(path.outputFigures)            
                                fileNameOut = sprintf('%s%s%s%s', strrep(fileIn, '.csv', ''), '_', num2str(jjCount), '.png');
                                %export_fig(fullfile(handles.path.figuresOutIndiv, fileNameOut), handles.figureOut_resolution, handles.figureOut_antialiasLevel, fig)
                                %cd(path.code)
                            end
                        catch
                            str = sprintf('%s\n%s', 'Crashing probably because you have not installed export_fig from Matlab File Exchange!', ...
                                          'Download it from: http://www.mathworks.com/matlabcentral/fileexchange/23629-exportfig, and "File -> Set Path -> Add Folder"');
                            error(str)
                        end
            
                        jjCount = jjCount + 1;
                        pause
                        
                    end
                    drawnow    

        end
    end