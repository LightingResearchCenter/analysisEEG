function plotMainEEG(dataOrganized, handles)

    %% Global SETTINGS

        handles.scrsz = get(0,'ScreenSize'); % get screen size for plotting;
                                             % handles structure used typically with GUI
                                         
                                         
        % now if we have like 15 different bands, it is hard to squeeze
        % them all the one A4 plot, so we divide the data into several
        % sheets
        handles.bandsPerPlot = 5;
        

    %% Plot different bands (compared dark / white / red)
        
        % define the period
        period = 1;
        fieldIn = 'powerSpectrum';
        lastLoopIndex = ceil(handles.indexLastBin_specificBands / handles.bandsPerPlot);
        
            for i = 1 : lastLoopIndex            
                % plot_byDifferentBands(dataOrganized, i, lastLoopIndex, period, fieldIn, handles)            
            end
        
    %% Plot individual means (fixed freq bins)
    
        % Load the data, this plot meant to check the discrepancies between
        % the current script and the old script done by Hamner & Okamoto
        load(fullfile(handles.path.organizeMatFiles, 'dataOrg_mat_scalarAveraged.mat')) % data_organized_meanScalar
    
        fieldIn = 'powerSpectrum';
        lastLoopIndex = ceil(handles.indexLastBin_specificBands / handles.bandsPerPlot);
        fileOutStr = 'fixedBands';
        bandOffset = 0; % start from beginning
        
            for i = 1 : lastLoopIndex     
                % plot_byIndividualMeans(data_organized_meanScalar, i, lastLoopIndex, bandOffset, fieldIn, fileOutStr, handles)    
            end
    
    %% Plot individual means (individual alpha freq bins)    
    
        fieldIn = 'powerSpectrum';        
        lastLoopIndex = ceil((handles.indexToEndIndivBins - handles.indexToStartIndivBins + 1) / handles.bandsPerPlot);
        fileOutStr = 'indivAlphaBand';
        bandOffset = handles.indexToStartIndivBins - 1;
        
            for i = 1 : lastLoopIndex
                % plot_byIndividualMeans(data_organized_meanScalar, i, lastLoopIndex, bandOffset, fieldIn, fileOutStr, handles)    
            end

    %% Plot ratios
    
        fieldIn = 'powerSpectrum';        
        lastLoopIndex = ceil((handles.indexToEndRatioBins - handles.indexToStartRatioBins + 1) / handles.bandsPerPlot);
        fileOutStr = 'ratios';
        bandOffset = handles.indexToStartRatioBins - 1;
        
            for i = 1 : lastLoopIndex
               % plot_byIndividualMeans(data_organized_meanScalar, i, lastLoopIndex, bandOffset, fieldIn, fileOutStr, handles)    
            end
            
    %% Plot "Levent-Plot"
    
        % change the bands at some point to relational, now kinda
        % non-elegant fixed
    
        % fixed bands
        fieldIn = 'powerSpectrum';        
        binsToPlot = [1 2 3 4 5];
        lastLoopIndex = ceil(length(binsToPlot) / handles.bandsPerPlot);
        fileOutStr = 'powerSpectrum';
        bandOffset = 0;        
        
        for i = 1 : lastLoopIndex
            plot_bandsWithLeventPlot(data_organized_meanScalar, i, binsToPlot, lastLoopIndex, bandOffset, fieldIn, fileOutStr, handles)
        end
    
        % individual alpha
        fieldIn = 'powerSpectrum';        
        binsToPlot = [142 143 144 149 150];
        lastLoopIndex = ceil(length(binsToPlot) / handles.bandsPerPlot);
        fileOutStr = 'indivAlphaBand';
        bandOffset = 0;        
        
        for i = 1 : lastLoopIndex
            plot_bandsWithLeventPlot(data_organized_meanScalar, i, binsToPlot, lastLoopIndex, bandOffset, fieldIn, fileOutStr, handles)
        end
        
        % ratios
        fieldIn = 'powerSpectrum';        
        binsToPlot = [161 167 168 173 176];
        lastLoopIndex = ceil(length(binsToPlot) / handles.bandsPerPlot);
        fileOutStr = 'ratios';
        bandOffset = 0;        
        
        for i = 1 : lastLoopIndex
            plot_bandsWithLeventPlot(data_organized_meanScalar, i, binsToPlot, lastLoopIndex, bandOffset, fieldIn, fileOutStr, handles)
        end

        