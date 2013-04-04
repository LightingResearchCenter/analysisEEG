function plot_byIndividualMeans(meanScalar, bandInd, lastLoopIndex, bandOffset, fieldIn, fileOutStr, handles)

    % for faster debugging / developing    
    if nargin == 0
        handles = init_defaultSettings();
        close all
        load(fullfile(handles.path.debugMatFiles, 'tempIndivMeansPlot.mat'))
    else
        if handles.saveTempDebugMATs == 1
            if bandInd == 1 % only for the first figure
                save(fullfile(handles.path.debugMatFiles, 'tempIndivMeansPlot.mat'))
            end
        end
    end
    

    scrsz = handles.scrsz;

    % meanScalar
    % whos
    
    fig = figure('Name', ['EEG Band Means #', num2str(bandInd), '/', num2str(lastLoopIndex)],...
                'Position', [0.05*scrsz(3) 0.05*scrsz(4) 0.85*scrsz(3) 0.80*scrsz(4)], ...
                'Color', 'w');

        rows = 3;
        cols = handles.bandsPerPlot;
        
        % indices for difference
        diffIndices =[1; ... % DARK
                      2; ... % RED
                      3];    % WHITE
        
        diffLabel = {'Dark'; ...
                     'Red'; ...
                     'White'};      
         
        % X axis labels
        xTickLocations = 1:9;
        xTickLabels = {'Period1';' ';' ';'Period2';' ';' ';'Period3';' ';' '};
        
            % Add the second row to the XTick labels
            for columns = 1 : length(xTickLabels)            
                ind = rem(columns,3);
                if ind == 0
                    ind = 3;
                end
                xTick2row{columns} = sprintf('%s%s\n%s', 'T', num2str(ind), xTickLabels{columns});
            end
            
        if strcmp(fileOutStr, 'fixedBands')
            maxBinIndex = handles.indexLastBin_specificBands;
        elseif strcmp(fileOutStr, 'indivAlphaBand')
            maxBinIndex = handles.indexToEndIndivBins;
        elseif strcmp(fileOutStr, 'ratios')
            maxBinIndex = handles.indexToEndRatioBins;
        end        
        maxBinIndex
                 
        %% Go through the conditions (Dark/Red/White)
        for ii = 1 : length(diffIndices)
                 
            for jj = 1 : cols % go through the frequency bands

                % define the eeg frequency band to be plotted (1-20 or how
                % many pre-defined bands you you have in
                % init_defaultSettings.m)
                eegBandIndex = ((bandInd - 1)*cols) + jj + bandOffset;
                index = ((ii-1)*cols) + jj;
                
                if eegBandIndex <= maxBinIndex
                
                    %% init subplot
                    sp(index) = subplot(rows,cols,index);                   

                        % get the data to be plotted from the structure
                        % output from subfunction are now matrices
                        [aver, medianV, SD, N] = plot_getMatrixFromCell(ii,meanScalar{ii},eegBandIndex,index,fieldIn,fileOutStr);

                        % statsOut = plot_calcStatsOfSubplot(aver, medianV, SD, N, eegBandIndex, index, fieldIn, fileOutStr);

                        % then calculate the average of these individual averages
                        [averMean, averSD] = plot_averOfIndidivMeans(aver);

                        
                        
                        %% PLOT
                        hold on                    
                        p2(index) = plot(xTickLocations, averMean, 'ko');
                        p1(index,:) = plot(xTickLocations, aver', 'o');                    
                        hold off

                        %% Annotate/style

                            % title                        
                            try
                                if strcmp(fileOutStr, 'ratios') == 1                                
                                    % str = handles.eegBins.label{eegBandIndex}
                                    titleStr = sprintf('%s\n%s\n', diffLabel{ii}, ...
                                                        handles.eegBins.label{eegBandIndex});
                                else                                
                                    titleStr = sprintf('%s\n%s\n%s\n', diffLabel{ii}, ...
                                                    handles.eegBins.label{eegBandIndex}, ...
                                                    [num2str(handles.eegBins.freqs{eegBandIndex}(1)), '-', num2str(handles.eegBins.freqs{eegBandIndex}(2)), ' Hz']);
                                end

                            catch err
                                % err 
                                disp(['           no title for index: ', num2str(eegBandIndex), ' at figure "', num2str(bandInd), '"'])
                                titleStr = ''; %no band
                            end
                            tit(index) = title(titleStr);
                            
                            % axis limits   
                            setLimits(sp(index), max(averMean), min(averMean), max(xTickLocations), min(xTickLocations))

                            % Labels
                            labY(index) = ylabel('arbit. power');                            

                            % X ticks                            
                            ticks(index,:) = text(xTickLocations, zeros(length(xTick2row),1), xTick2row);
                            
                        %% save to a cell / matrix, to be written to disk
                        whos
                        dataMatOut{jj}.aver(ii,:,:) = aver';
                        dataMatOut{jj}.SD(ii,:,:) = SD';
                        dataMatOut{jj}.title{ii} = titleStr;
                        dataMatOut{jj}.averMean(ii,:) = averMean;
                        dataMatOut{jj}.averSD(ii,:) = averSD;
                else
                   
                    % no data
                    sp(index) = subplot(rows,cols,index);
                    
                        hold on
                        p2(index) = plot(NaN, NaN, 'ko');
                        p1(index,:) = plot(xTickLocations, nan(length(xTickLocations), 1), 'o'); 
                        hold off
                    
                        tit(index) = title(' ');
                        labY(index) = ylabel(' ');  
                        emptyTickRow = cell(length(xTick2row),1);
                        ticks(index,:) = text(xTickLocations, zeros(length(xTick2row),1), emptyTickRow);      
                        
                        axis off
                        box off
                    
                end

            end % number of cols            
        end % number of conditions
        
        %% STYLE
        
            set(sp, 'FontName', handles.style.fontName, 'FontSize', handles.style.fontSizeBase-3)
            set(sp, 'XTick', xTickLocations, 'XTickLabel', '')        
            set(tit, 'FontName', handles.style.fontName, 'FontSize', handles.style.fontSizeBase-1, 'FontWeight', 'bold')
            set(labY, 'FontName', handles.style.fontName, 'FontSize', handles.style.fontSizeBase-2)
            set(ticks, 'FontName', handles.style.fontName, 'FontSize', handles.style.fontSizeBase-2)

            set(p1, 'MarkerSize', 3);
            set(p2, 'MarkerSize', 5, 'MarkerFaceColor', 'k', 'MarkerEdgeColor', [.2 .2 .2]);
        
        %% export to disk
        
            % the figure
            try
                if handles.figureOut_ON == 1      
                    drawnow
                    dateStr = getDateString(); % get current date as string
                    %cd(path.outputFigures)            
                    fileNameOut = sprintf('%s%s%s%s%s', 'EEG-BandMeans-', fileOutStr, '_v', dateStr, '_', num2str(bandInd), '.png');
                    export_fig(fullfile(handles.path.figuresOut, fileNameOut), handles.figureOut_resolution, handles.figureOut_antialiasLevel, fig)
                    %cd(path.code)
                end
            catch err
                err
                str = sprintf('%s\n%s', 'Crashing probably because you have not installed export_fig from Matlab File Exchange!', ...
                              'Download it from: http://www.mathworks.com/matlabcentral/fileexchange/23629-exportfig, and "File -> Set Path -> Add Folder"');
                error(str)
            end
            
            % the data         
                    handles.path.figuresOutData = fullfile(handles.path.mainCode, 'figureData');

            plot_writeMatrixToDisk(dataMatOut, fileNameOut, handles.path.figuresOutData, handles)

        
        
%% SUBFUNCTIONS
        
    function setLimits(sp, maxY, minY, maxX, minX)

        % set(sp, 'YLim', [minY maxY])
        % set(sp, 'YLim', [minY-0.1 maxY+0.1])
        set(sp, 'YLim', [0.2 1.8])   

    function [averMean, averSD] = plot_averOfIndidivMeans(aver);

        averMean = nanmean(aver);
        averSD   = nanstd(aver);
    