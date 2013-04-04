function plot_writeMatrixToDisk(dataMatOut, fileNameOut, path_figuresOutData, handles)

    % for faster debugging / developing    
    if nargin == 0
        handles = init_defaultSettings();
        close all
        load(fullfile(handles.path.debugMatFiles, 'tempWriteMatToDisk.mat'))
    else
        if handles.saveTempDebugMATs == 1            
            save(fullfile(handles.path.debugMatFiles, 'tempWriteMatToDisk.mat'))            
        end
    end
    
    fileNameOut = strrep(fileNameOut, '.png', '.txt');
    fileWithPath = fullfile(path_figuresOutData, fileNameOut);
    
    header = {' ', 'P1T1', 'P1T2', 'P1T3', 'P2T1', 'P2T2', 'P2T3', 'P3T1', 'P3T2', 'P3T3'};
    txtHeader=sprintf('%s\t',header{:});
    txtHeader(end)='';
    
    dlmwrite(fileWithPath, fileNameOut, 'delimiter', '')
    
    for jj = 1 : length(dataMatOut) % bands
        
        for ii = 1 : length(dataMatOut{jj}.title) % conditions (white/dark/red)
            
            dlmwrite(fileWithPath, [' '], '-append', 'delimiter', '')
            dlmwrite(fileWithPath, dataMatOut{jj}.title{ii}, '-append', 'delimiter', '')
            dlmwrite(fileWithPath, txtHeader, '-append', 'delimiter', '')
            
            
            dlmwrite(fileWithPath, ['MEAN'], '-append', 'delimiter', '')
            for k = 1 : length(dataMatOut{jj}.aver(ii,:,:)) % number of subjects
                dlmwrite(fileWithPath, [NaN dataMatOut{jj}.aver(ii,:,k)], '-append', 'delimiter', '\t')
            end           
            
            dlmwrite(fileWithPath, ['SD'], '-append', 'delimiter', '')
            for k = 1 : length(dataMatOut{jj}.SD(ii,:,:))  % number of subjects
                dlmwrite(fileWithPath, [NaN dataMatOut{jj}.SD(ii,:,k)], '-append', 'delimiter', '\t')
            end
            
            
            dlmwrite(fileWithPath, ['Stats MEAN'], '-append', 'delimiter', '')
            dlmwrite(fileWithPath, [NaN dataMatOut{jj}.averMean(ii,:)], '-append', 'delimiter', '\t')
            dlmwrite(fileWithPath, ['Stats SD of MEAN (not mean of SD matrix)'], '-append', 'delimiter', '')
            dlmwrite(fileWithPath, [NaN dataMatOut{jj}.averSD(ii,:)], '-append', 'delimiter', '\t')
            
        end
        
    end
    whos