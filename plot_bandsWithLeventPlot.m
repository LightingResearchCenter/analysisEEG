function plot_bandsWithLeventPlot(meanScalar, bandInd, binsToPlot, lastLoopIndex, bandOffset, fieldIn, fileOutStr, handles)

    % for faster debugging / developing    
    if nargin == 0
        handles = init_defaultSettings();
        close all
        %load(fullfile(handles.path.debugMatFiles, 'tempIndivMeansLeventPlot.mat'))
        load(fullfile(handles.path.debugMatFiles, 'tempLeventHandles.mat'))
        handles.figureOut_ON = 0;
        localRun = 1;
    else
        if handles.saveTempDebugMATs == 1
            if bandInd == 1 % only for the first figure
                save(fullfile(handles.path.debugMatFiles, 'tempIndivMeansLeventPlot.mat'), 'meanScalar')
                save(fullfile(handles.path.debugMatFiles, 'tempLeventHandles.mat'), 'handles', 'bandInd', 'lastLoopIndex', 'bandOffset', 'fieldIn', 'fileOutStr')
            end
        end
        localRun = 0;
    end
    
    % Screen size
    scrsz = handles.scrsz;
    
    % Init figure
    fig = figure('Name', ['EEG Bands #', num2str(bandInd), '/', num2str(lastLoopIndex)],...
                'Position', [0.05*scrsz(3) 0.025*scrsz(4) 0.85*scrsz(3) 0.90*scrsz(4)], ...
                'Color', 'w');

        rows = 5; % 
        cols = handles.bandsPerPlot;
        
        % plot settings
        barWidth = 0.1;
        
        % indices for difference
        diffIndices =[1; ... % DARK
                      2; ... % RED
                      3];    % WHITE
        
        diffLabel = {'D'; ...
                     'R'; ...
                     'W'};      
                 
        diffLabelLong = {'Dark'; ...
                         'Red'; ...
                         'White'};           
                 
        diffMatrixIndices = {[1 4 7]; [2 5 8]; [3 6 9]};
                
        offset = 0.2;
        xTickLocations = (1:9) - offset;        
        xTickLocationsMean = xTickLocations + (2*offset);
        
            xTickLabelsLevent = {'P1 7am';' ';' ';'P2 11am';' ';' ';'P3 3pm';' ';' '};                    
            for columns = 1 : length(xTickLabelsLevent) % Add the second row to the XTick labels
                ind = rem(columns,3);
                if ind == 0
                    ind = 3;
                end
                indInv = 3 - (ind-1);
                xTick2rowLevent{columns} = sprintf('%s\n%s', diffLabel{indInv}, xTickLabelsLevent{columns});
            end
            
            xTickLabels = {'P1 7am';' ';' ';'P2 11am';' ';' ';'P3 3pm';' ';' '};                    
            for columns = 1 : length(xTickLabels) % Add the second row to the XTick labels
                ind = rem(columns,3);
                if ind == 0
                    ind = 3;
                end
                xTick2row{columns} = sprintf('%s%s\n%s', 'T', num2str(ind), xTickLabels{columns});
            end
        
       %% READ FROM .MAT -files (or not), for quicker debugging/development
       if localRun == 0
            
           %% Create the matrix with different PERIODs (the "Levent Matrix")
           % see for example "ONR_EEG_DAY_LRC.xlsx" [AD17:AM36]       

                for jj = 1 : cols % go through the frequency bands
                    eegBandIndex(jj) = binsToPlot(jj) + bandOffset;
                    [aver_Period{jj}, medianV_Period{jj}, SD_Period{jj}, N_Period{jj}] = ...
                        plot_getLeventMatrixFromCell(diffIndices, cols, jj, meanScalar, eegBandIndex(jj), fieldIn, fileOutStr);
                end % number of cols            
                %aver_Period{1}

            %% Go through the conditions (Dark/Red/White)
            for ii = 1 : length(diffIndices)                 
                for jj = 1 : cols % go through the frequency bands
                    %eegBandIndex(jj) = ((bandInd - 1)*cols) + jj + bandOffset;
                    index = ((ii-1)*cols) + jj;            
                    [aver{ii,jj}, medianV{ii,jj}, SD{ii,jj}, N{ii,jj}] = plot_getMatrixFromCell(ii,meanScalar{ii},eegBandIndex(jj),index,fieldIn,fileOutStr);
                end
            end
            
            %% Create the checkup matrix
            for jj = 1 : cols % go through the frequency bands  
                %eegBandIndex(jj) = ((bandInd - 1)*cols) + jj + bandOffset;
                checkupMatrix{jj} = plot_getCheckupMatrix(meanScalar, eegBandIndex(jj), fieldIn, handles);
            end
    
            if handles.saveTempDebugMATs == 1
                if bandInd == 1 % only for the first figure
                    save(fullfile(handles.path.debugMatFiles, 'tempLeventPlotForResults.mat'), 'checkupMatrix', 'aver_Period', 'medianV_Period', 'SD_Period', 'N_Period', 'aver', 'medianV', 'SD', 'N', 'eegBandIndex')
                end
            end
            
       else % load from MAT
           load(fullfile(handles.path.debugMatFiles, 'tempLeventPlotForResults.mat'))           
       end
       
       whos
            
    %% PLOT    
    
        for jj = 1 : cols         
            
            %% 1st ROW
            sp(jj,1) = subplot(rows,cols,jj);
                
                [averMean_Period, averSD_Period] = plot_averOfIndidivMeans(aver_Period{jj});                
                
                    % PLOT
                    hold on           
                    
                        % Bar Histograms
                        p2hist(jj,1) = bar(xTickLocationsMean(diffMatrixIndices{1}), averMean_Period(diffMatrixIndices{1}), 'BarWidth', barWidth);
                        p2hist(jj,2) = bar(xTickLocationsMean(diffMatrixIndices{2}), averMean_Period(diffMatrixIndices{2}), 'BarWidth', barWidth);
                        p2hist(jj,3) = bar(xTickLocationsMean(diffMatrixIndices{3}), averMean_Period(diffMatrixIndices{3}), 'BarWidth', barWidth);

                        % errors of histograms (plot on top of the bars)
                        p2(jj) = errorbar(xTickLocationsMean, averMean_Period, averSD_Period, 'ko');

                        % individual means
                        p1(jj,:) = plot(xTickLocations, aver_Period{jj}', 'o');                    
                        
                    hold off                   
                                   
                    % ANNOTATE
                    yOffset = 0.2;
                    ticks(jj,:) = text(xTickLocations+offset, zeros(length(xTick2rowLevent),1) - yOffset, xTick2rowLevent); % X ticks
                    
                    if eegBandIndex(jj) < handles.indexToStartRatioBins
                        titleStr = sprintf('%s\n%s\n', handles.eegBins.label{eegBandIndex(jj)}, ...
                                                    [num2str(handles.eegBins.freqs{eegBandIndex(jj)}(1)), '-', num2str(handles.eegBins.freqs{eegBandIndex(jj)}(2)), ' Hz']);
                    else
                        titleStr = sprintf('%s', handles.eegBins.label{eegBandIndex(jj)});
                    end
                    tit(jj) = title(titleStr);
                        pos = get(tit(jj), 'Position');
                        
                    
                    % make it the layout tighter
                    pos = get(sp(jj,1), 'Position');
                    posOffs = 0.04;
                    %set(sp(jj,1), 'Position', [pos(1)-posOffs pos(2)-posOffs pos(3)+(posOffs/2) pos(4)+(posOffs/2)])
                    
                
            %% 2nd ROW
            sp(jj,2) = subplot(rows,cols,jj+cols);
            
                hold on 
                for ii = 1 : length(diffLabel)
                    [averMean{ii,jj}, averSD{ii,jj}] = plot_averOfIndidivMeans(aver{ii,jj});
                    p3(ii,jj) = errorbar(xTickLocationsMean, averMean{ii,jj}, averSD{ii,jj}, '-o');                    
                end
                hold off
                
                % ANNOTATE
                yOffset = 0.2;
                ticks2(jj,:) = text(xTickLocations+offset, zeros(length(xTick2row),1) - yOffset, xTick2row); % X ticks
                
                % make it the layout tighter
                pos = get(sp(jj,2), 'Position');
                %set(sp(jj,2), 'Position', [pos(1)-posOffs pos(2)-posOffs pos(3)+(posOffs/2) pos(4)+(posOffs/2)])

                
            %% 3rd ROW (STATS)
            ind1 = jj+(2*cols); ind2 = jj+(3*cols); ind3 = jj+(4*cols);
            sp(jj,3) = subplot(rows,cols,[ind1 ind2 ind3]);           
            
                for jjk = 1 : cols % go through the frequency bands   
                    statOut{jjk} = stat_preConditionVectors(checkupMatrix{jjk}, aver_Period{jjk}, handles);
                end
                plot_annotateWithStats(statOut{jj}, handles)
    
                        
        end
     
    %% STYLE
        
        whiteColor = [.65 .45 0];
    
        set(p1, 'MarkerSize', 2);
        set(p2, 'MarkerSize', 1, 'MarkerFaceColor', 'k', 'MarkerEdgeColor', [.2 .2 .2], 'Marker', 'none');
        
        set(p3(1,:), 'Color', 'k', 'MarkerFaceColor', 'k', 'Marker', '^')
        set(p3(2,:), 'Color', 'r', 'MarkerFaceColor', 'r', 'Marker', 's')
        set(p3(3,:), 'Color', whiteColor, 'MarkerFaceColor', whiteColor, 'Marker', 'd')
        set(p3, 'MarkerEdgeColor', 'none')
        
        set(p2hist(:, 1), 'FaceColor', whiteColor)
        set(p2hist(:, 2), 'FaceColor', 'r')
        set(p2hist(:, 3), 'FaceColor', [.3 .3 .3])
        set(p2hist(:,:), 'EdgeColor', 'none', 'BarWidth', 0.1)
            
        set(sp, 'FontName', handles.style.fontName, 'FontSize', handles.style.fontSizeBase-3)
        set(sp, 'XTick', xTickLocations, 'XTickLabel', '')
        set(sp, 'YLim', [0 2], 'XLim', [0 10])
            set(sp(:,3), 'XLim', [0 1], 'YLim', [0 1]) % correct for annotation subplot
        set([ticks ticks2], 'FontName', handles.style.fontName, 'FontSize', handles.style.fontSizeBase-2)
        set([ticks ticks2], 'HorizontalAlignment', 'left')
        
        set(tit, 'FontName', handles.style.fontName, 'FontSize', handles.style.fontSizeBase-1, 'FontWeight', 'bold')
    
    %% EXPORT TO DISK
        
        try
            if handles.figureOut_ON == 1      
                drawnow
                dateStr = getDateString(); % get current date as string
                %cd(path.outputFigures)            
                fileNameOut = sprintf('%s%s%s%s%s', 'EEG-BandSummary-', fileOutStr, '_v', dateStr, '_', num2str(bandInd), '.png');
                export_fig(fullfile(handles.path.figuresOut, fileNameOut), handles.figureOut_resolution, handles.figureOut_antialiasLevel, fig)
                %cd(path.code)
            end
        catch err
            err
            str = sprintf('%s\n%s', 'Crashing probably because you have not installed export_fig from Matlab File Exchange!', ...
                          'Download it from: http://www.mathworks.com/matlabcentral/fileexchange/23629-exportfig, and "File -> Set Path -> Add Folder"');
            warning(str)
        end

        
%% SUBFUNCTIONS
function [averMean, averSD] = plot_averOfIndidivMeans(aver)
    averMean = nanmean(aver);
    averSD   = nanstd(aver);