% Imports the data from .bdf files (+EEG Filtering) 
function savenameMAT = importMain(alldata_LUT, handles)

    % if not loaded from MATs, display "warning"
    if handles.filterAndProcess_BDFs == 1
        disp('   THIS MAY TAKE SOME TIME, importing, filtering, and computing PS of the individual BDF files')    
    end

    % Filenames defined in "alldata_lookup_table.xlsx"
    % Get the fields for organizing the data
    [sub, period, color, condition, trial, session, path, q, numberOfSubjects, subjectOffset] = import_getAllDataLookupFields(alldata_LUT);
        handles.numberOfSubjects = numberOfSubjects;
        handles.subjectOffset = subjectOffset;
    
    % have to specified here for parfor to work
    matlabPath = handles.path.ONRdaytime_matlab; 
    pathMAT = handles.path.ONRdaytime_dataEEG;
    processOrNot = handles.processBdfFiles;
    excelSetOut = handles.eegSet.excelOut;
    eegSet = handles.eegSet;    
    
    % Preallocate cells
    psdata = cell(length(sub),1);
    EEGFT = cell(length(sub),1);    
    savenameFile = cell(length(sub),1);
    savenameXLS = cell(length(sub),1);
    savenameMAT = cell(length(sub),1); 
    excelOutDebugPath = handles.path.excelOutDebug;
    
    nrOfSubjects = length(sub);
    
    % parfor-specific fixes
    processOrNot = handles.filterAndProcess_BDFs; % parfor does not like the "handles embedding"
    psBinsMatPath = handles.path.psBinsAsMAT;
    
    subLength = length(sub);
    
    % Go through the SUBJECTs   
    parfor s = 1 : subLength
        
        savenameFile{s} = ['Subject ', num2str(sub(s)), '_Period ', num2str(period(s)), '_Color ', color(s), '_Trial ', num2str(trial(s)), '_processed.xls'];
        % savenameXLS{s} = fullfile(matlabPath, 'Excel Power Spectra', savenameFile{s});
        savenameXLS{s} = fullfile(excelOutDebugPath, savenameFile{s});
        savenameMAT{s} = fullfile(psBinsMatPath, ['psBins_', strrep(savenameFile{s}, '.xls', '.mat')]);        
        
        % if you want to skip the analysis and read the results directly
        % from MAT-files in analyze_frequencyBins
        if processOrNot == 1            
            
            % display status of the progress
            % fprintf('%s%s',num2str((accumForTracking/length(sub))*100, '%2.1f'),'% ');       
            disp(['      FILE: ', num2str(s), '/', num2str(nrOfSubjects), ' - ', strrep(savenameFile{s}, '_processed.xls', ''), ' - ', datestr(now)])          

            % Now in the original .xlsx the path has been defined as local, so
            % we need to change the beginning
            if isunix
                pathSeparator = '/'; % path separator
                temp = strrep(path{s}, 'C:\LRC\2012_FALL\EEG_ONR_DAY\', '');
                temp = strrep(temp, '\', pathSeparator);
                temp = fullfile(pathMAT, temp);
                pathLoop = temp;

            else
                % for Levent (change something more elegant if more people are
                % starting to run this on Windows)
                pathLoop = path{s};
            end

            % remove possible whitespace from the end
            pathLoop = deblank(pathLoop);

            % Compute the PSDs from BDF files with
            if processOrNot == 0                
                try
                    % disp('                loading the computed power spectrum bins from a MAT file')
                    % load(savenameMAT{s});                    
                catch err % if that specified MAT file did not exist                    
                    warning(err.identifier, 'You have not yet saved any MAT for imported BDFs. Running the analysis from scratch')
                    ps_bins = computeMain(pathLoop, sub(s), period(s), trial(s), color(s), eegSet, savenameMAT{s}, savenameXLS{s}, handles);                   
                    parSave(savenameMAT{s}, ps_bins);
                end                   
            end

            %% COMPUTE MAIN
            if processOrNot == 1
                ps_bins = computeMain(pathLoop, sub(s), period(s), trial(s), color(s), eegSet, s, savenameMAT{s}, savenameXLS{s}, handles);                
                parSave(savenameMAT{s}, ps_bins);      
                
                % One ps_bins takes roughly 481'919'046 of memory ~ 460 MB
                % so they have to be saved one file at a time to the disk
                % really, this adds significant overhead, so you could
                % change into a RAID system and/or SSD hard drives
                
            end
        end        
      
        % ps_bins_Cell{s} = ps_bins;
        
    end % end of subjects   
    disp('     DONE with the import')    
    
     
    function parSave(savenameMAT, ps_bins)
        save(savenameMAT, 'ps_bins')