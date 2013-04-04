function plot_byDifferentBands(dataOrganized, bandInd, lastLoopIndex, period, fieldIn, handles)

    scrsz = handles.scrsz;

    fig = figure('Name', ['EEG Bands #', num2str(bandInd), '/', num2str(lastLoopIndex)],...
                'Position', [0.05*scrsz(3) 0.05*scrsz(4) 0.85*scrsz(3) 0.80*scrsz(4)], ...
                'Color', 'w');

        rows = 3;
        cols = handles.bandsPerPlot;
        
        % indices for difference
        diffIndices =[1 2; ... % DARK - RED
                      1 3; ... % DARK - WHITE
                      2 3];    % RED  - WHITE
        
        diffLabel = {'Dark - RED'; ...
                     'Dark - WHITE'; ...
                     'Red - WHITE'};      
                                
        for jj = 1 : cols
            
            eegBandIndex = ((bandInd - 1)*cols) + jj;

            %% DARK - RED
            i = 1; % row
            index = ((i-1)*cols) + jj;
            sp(index) = subplot(rows,cols,index);
            
                % get the difference
                [mean, SD] = plot_calculateDifferenceSignal(dataOrganized{diffIndices(i,1)}, dataOrganized{diffIndices(i,2)}, period, eegBandIndex, fieldIn);
                time = (linspace(0,length(mean),length(mean)))';
                
                % plot
                p = plot(time, mean, 'k', time, mean+SD, 'k', time, mean-SD, 'k');
                    set(p(2:3), 'Color', [.4 .4 .4])
                            
                    titleStr = sprintf('%s\n%s\n%s\n', diffLabel{i}, ...
                                        handles.eegBins.label{eegBandIndex}, ...
                                        [num2str(handles.eegBins.freqs{eegBandIndex}(1)), '-', num2str(handles.eegBins.freqs{eegBandIndex}(2)), ' Hz']);
                    
                    tit(index) = title(titleStr);
                    setLimits(sp(index), max(mean), min(mean), max(time), min(time), mean, handles)
                    
                    if jj == 1
                       labY(i) = ylabel('Normalized power (to trial 1');
                    end

                    
            %% DARK - WHITE
            i = 2; % row
            index = ((i-1)*cols) + jj;
            sp(index) = subplot(rows,cols,index);
            
                % get the difference
                [mean, SD] = plot_calculateDifferenceSignal(dataOrganized{diffIndices(i,1)}, dataOrganized{diffIndices(i,2)}, period, eegBandIndex, fieldIn);
                time = (linspace(0,length(mean),length(mean)))';
                
                % plot
                p = plot(time, mean, 'k', time, mean+SD, 'k', time, mean-SD, 'k');
                    set(p(2:3), 'Color', [.4 .4 .4])
                              
                    titleStr = sprintf('%s\n%s\n%s\n', diffLabel{i}, ...
                                        handles.eegBins.label{eegBandIndex}, ...
                                        [num2str(handles.eegBins.freqs{eegBandIndex}(1)), '-', num2str(handles.eegBins.freqs{eegBandIndex}(2)), ' Hz']);
                    
                    tit(index) = title(titleStr);
                    setLimits(sp(index), max(mean), min(mean), max(time), min(time), mean, handles)
                    
                    if jj == 1
                       labY(i) = ylabel('Normalized power (to trial 1');
                    end
                    
                    
                    
            %% Red - WHITE
            i = 3; % row    
            index = ((i-1)*cols) + jj;
            sp(index) = subplot(rows,cols,index);
            
                % get the difference
                [mean, SD] = plot_calculateDifferenceSignal(dataOrganized{diffIndices(i,1)}, dataOrganized{diffIndices(i,2)}, period, eegBandIndex, fieldIn);
                time = (linspace(0,length(mean),length(mean)))';
                
                % plot
                p = plot(time, mean, 'k', time, mean+SD, 'k', time, mean-SD, 'k');
                    set(p(2:3), 'Color', [.4 .4 .4])
                              
                    titleStr = sprintf('%s\n%s\n%s\n', diffLabel{i}, ...
                                        handles.eegBins.label{eegBandIndex}, ...
                                        [num2str(handles.eegBins.freqs{eegBandIndex}(1)), '-', num2str(handles.eegBins.freqs{eegBandIndex}(2)), ' Hz']);
                    
                    tit(index) = title(titleStr);
                    setLimits(sp(index), max(mean), min(mean), max(time), min(time), mean, handles)
                    
                    if jj == 1
                       labY(i) = ylabel('Normalized power (to trial 1');
                    end
                    labX(jj) = xlabel('Time [s]');
                    
            
                    
        end
        
        set(sp, 'FontName', handles.style.fontName, 'FontSize', handles.style.fontSizeBase-2)
        set(tit, 'FontName', handles.style.fontName, 'FontSize', handles.style.fontSizeBase-1, 'FontWeight', 'bold')
        set(labY, 'FontName', handles.style.fontName, 'FontSize', handles.style.fontSizeBase-2)
        set(labX, 'FontName', handles.style.fontName, 'FontSize', handles.style.fontSizeBase-2)
        
        
        
        % export to disk
        try
        if handles.figureOut_ON == 1      
            drawnow
            dateStr = getDateString(); % get current date as string
            %cd(path.outputFigures)            
            fileNameOut = sprintf('%s%s%s%s%s', 'EEG-Bands-defined_v', dateStr, '_', num2str(bandInd), '.png');
            export_fig(fullfile(handles.path.figuresOut, fileNameOut), handles.figureOut_resolution, handles.figureOut_antialiasLevel, fig)
            %cd(path.code)
        end
    catch
        str = sprintf('%s\n%s', 'Crashing probably because you have not installed export_fig from Matlab File Exchange!', ...
                      'Download it from: http://www.mathworks.com/matlabcentral/fileexchange/23629-exportfig, and "File -> Set Path -> Add Folder"');
        error(str)

    end
    
function setLimits(sp, maxY, minY, maxX, minX, mean, handles)

    % set(sp, 'YLim', [minY maxY])
    set(sp, 'YLim', [-2 2])
    
    line([minX maxX], [0 0], 'Color', 'r')
    
    % annotate the mean +- sd of the vector
    aver = nanmean(mean);
    SD = nanstd(mean);
    
    lims = get(gca, 'YLim'); 
    minY = lims(1); maxY = lims(2);
    
    t = text(0.99*maxX, 0.90*maxY, [num2str(aver,2), '\pm', num2str(SD,2)]);
        set(t, 'HorizontalAlignment', 'right')
        set(t, 'FontName', handles.style.fontName, 'FontSize', handles.style.fontSizeBase-2)
    


function [mean, SD] = plot_calculateDifferenceSignal(signal1, signal2, periodInd, eegBandIndex, fieldIn)

    lengthOfData = length(signal1.bins);
    
    % Prellocate
    %     signal1.meanVector = zeros(lengthOfData,1);
    %     signal1.sdVector   = zeros(lengthOfData,1);
    %     signal2.meanVector = zeros(lengthOfData,1);
    %     signal2.sdVector   = zeros(lengthOfData,1);
    
    %signal1.bins{eegBandIndex}
    %signal1.bins{eegBandIndex}.period{periodInd}
    %signal1.bins{eegBandIndex}.period{periodInd}.ch
    %signal1.bins{eegBandIndex}.period{periodInd}.ch.(fieldIn)
    %signal1.bins{eegBandIndex}.period{periodInd}.ch.(fieldIn).aver
    
    signal1.meanVector = signal1.bins{eegBandIndex}.period{periodInd}.ch.(fieldIn).aver;
    signal1.sdVector   = signal1.bins{eegBandIndex}.period{periodInd}.ch.(fieldIn).SD;
    signal2.meanVector = signal2.bins{eegBandIndex}.period{periodInd}.ch.(fieldIn).aver;
    signal2.sdVector   = signal2.bins{eegBandIndex}.period{periodInd}.ch.(fieldIn).SD;        
    
       
    % DIFFERENCE
    mean = signal1.meanVector - signal2.meanVector;
    SD   = sqrt(signal1.sdVector.^2 + signal2.sdVector.^2);
    
    %pause
    