function organize_LRCSummaryOut(sub, alpha, beta, theta, alphatheta, handles)        
    
    fileOut = 'checkupMatrix.txt';
    fileWithPath = fullfile(handles.path.excelOut, fileOut);
    
    header = {'Subject', 'WT1', 'WT2', 'WT3', 'WT4', 'WT5', 'WT6', 'WT7', 'WT8', 'WT9', 'RT1', 'RT2', 'RT3', 'RT4', 'RT5', 'RT6', 'RT7', 'RT8', 'RT9', 'DT1', 'DT2', 'DT3', 'DT4', 'DT5', 'DT6', 'DT7', 'DT8', 'DT9'};
    txtHeader=sprintf('%s\t',header{:});
    txtHeader(end)='';
    
    dlmwrite(fileWithPath, ['Alpha'], 'delimiter', '')
    dlmwrite(fileWithPath, txtHeader, '-append', 'delimiter', '')
    dlmwrite(fileWithPath, [sub alpha], '-append', 'delimiter', '\t')
    
    dlmwrite(fileWithPath, ['Beta'], '-append', 'delimiter', '')
    dlmwrite(fileWithPath, txtHeader, '-append', 'delimiter', '')
    dlmwrite(fileWithPath, [sub beta], '-append', 'delimiter', '\t')
    
    dlmwrite(fileWithPath, ['Theta'], '-append', 'delimiter', '')
    dlmwrite(fileWithPath, txtHeader, '-append', 'delimiter', '')
    dlmwrite(fileWithPath, [sub theta], '-append', 'delimiter', '\t')
    
    dlmwrite(fileWithPath, ['Alpha-Theta'], '-append', 'delimiter', '')
    dlmwrite(fileWithPath, txtHeader, '-append', 'delimiter', '')
    dlmwrite(fileWithPath, [sub alphatheta], '-append', 'delimiter', '\t')