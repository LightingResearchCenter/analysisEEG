function plot_alphaPeakPlot(alphaPeak, alphaGravity, handles)

    if nargin == 0
        load alphaPeakPlot.mat
        close all
    else
        save alphaPeakPlot.mat
    end
    
    fig = figure('Color','w');
            
        sp_rows = 2;
        sp_cols = 2;

        % create X vector
        ind1 = handles.subjectOffset + 1;
        ind2 = handles.subjectOffset + handles.numberOfSubjects;
        subX = (ind1 : 1 : ind2)';

        %% peak
        
            j = 1;
            sp(j) = subplot(sp_rows,sp_cols,j);                
                e(j) = errorbar(subX, alphaPeak.IndivMeanOfMedians, alphaPeak.IndivSDofMedians, 'o');
                    xlab(j) = xlabel('Subject');
                    ylab(j) = ylabel('Alpha Peak [Hz]');                
                    tit(j) = title('Individual Alpha Peak');

                % SDs (variability within the subject)
                j = 2;
                sp(j) = subplot(sp_rows,sp_cols,j);
                    e(j) = errorbar(subX, alphaPeak.IndivMeanOfSDs, alphaPeak.IndivSDofSDs, 'o');
                        xlab(j) = xlabel('Subject');
                        ylab(j) = ylabel('Peak Variability [SD, Hz]');
                        tit(j) = title('Individual Peak variability');

        %% gravity
        
            j = 3;
            sp(j) = subplot(sp_rows,sp_cols,j);                
                e(j) = errorbar(subX, alphaGravity.IndivMeanOfMedians, alphaGravity.IndivSDofMedians, 'o');
                    xlab(j) = xlabel('Subject');
                    ylab(j) = ylabel('Alpha Gravity [Hz]');
                    titStr = sprintf('%s', 'Individual Alpha Gravity');
                    tit(j) = title(titStr);

                % SDs (variability within the subject)
                j = 4;
                sp(j) = subplot(sp_rows,sp_cols,j);
                    e(j) = errorbar(subX, alphaGravity.IndivMeanOfSDs, alphaGravity.IndivSDofSDs, 'o');
                        xlab(j) = xlabel('Subject');
                        ylab(j) = ylabel('Gravity Variability [SD, Hz]');
                        tit(j) = title('Individual Gravity variability');
            
            
        %% style  
        
            set(sp, 'XLim', [min(subX)-1 max(subX)+1], 'YLim', [8 12])
                set(sp([2 4]), 'YLim', [0 2])

            set([xlab ylab], 'FontName', handles.style.fontName, 'FontSize', handles.style.fontSizeBase-1)
            set(tit, 'FontName', handles.style.fontName, 'FontSize', handles.style.fontSizeBase-1, 'FontWeight', 'bold')

            set(e, 'Color', [.3 .3 .3], 'MarkerSize', 4, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'k')
                set(e([2 4]), 'MarkerFaceColor', 'b')

        
        %% export to disk
        try
            if handles.figureOut_ON == 1      
                drawnow
                dateStr = getDateString(); % get current date as string
                %cd(path.outputFigures)            
                fileNameOut = sprintf('%s%s%s', 'AlphaPeaks_v', dateStr, '.png');
                export_fig(fullfile(handles.path.figuresOut, fileNameOut), handles.figureOut_resolution, handles.figureOut_antialiasLevel, fig)
                %cd(path.code)
            end
        catch
            str = sprintf('%s\n%s', 'Crashing probably because you have not installed export_fig from Matlab File Exchange!', ...
                          'Download it from: http://www.mathworks.com/matlabcentral/fileexchange/23629-exportfig, and "File -> Set Path -> Add Folder"');
            error(str)
        end