function handles = init_derivedPathNames(handles)

    %% DERIVED PATHNAMES
    % Don't touch if you don't know what you are doing

        handles.path.matFiles = fullfile(handles.path.mainCode, 'MAT_files');
             handles.path.matFilesAlphaPeaks = fullfile(handles.path.matFiles, 'individualAlphaPeaks');
        handles.path.cloudInputFiles = fullfile(handles.path.mainCode, 'input'); % cloud, as in Dropbox
        % handles.path.BDFsAsMAT = fullfile(handles.path.matFiles, 'BDFs');
        handles.path.excelOut = fullfile(handles.path.mainCode, 'excelOut');
            handles.path.excelOutDebug = fullfile(handles.path.excelOut, 'debug');
        handles.path.statFuncPath = fullfile(handles.path.mainCode, '3rdPartyStat');
            
        % Figures out
        handles.path.figuresOut = fullfile(handles.path.mainCode, 'figures');
        handles.path.figuresOutData = fullfile(handles.path.mainCode, 'figureData');
        handles.path.figuresOutIndiv = fullfile(handles.path.figuresOut, 'individualData');            

        % Local MAT-files (data files)
        handles.path.psBinsAsMAT = fullfile(handles.path.localMatlabFolder, 'EEG-BDFasMAT');
        handles.path.excelPowerSpectra = fullfile(handles.path.localMatlabFolder, 'Excel Power Spectra');
        handles.path.organizeMatFiles = fullfile(handles.path.localMatlabFolder, 'organizeIntermediateMATs'); 
        handles.path.debugMatFiles = fullfile(handles.path.localMatlabFolder, 'temporaryDebugMATs');
        handles.path.ONRdaytime_dataEEG = fullfile(handles.path.localMatlabFolder, 'EEG_bdf_files');

        % Windows Network        
        handles.path.projects = '/run/user/petteri/gvfs/smb-share:server=root,share=projects/'; % buggy, prefer to use local folders          

            handles.path.ONRdaytime = fullfile(handles.path.projects, 'ONR EEG', 'ONR EEG DAY TIME');
            handles.path.ONRdaytime_matlab = fullfile(handles.path.ONRdaytime, 'MATLAB');
            % handles.path.ONRdaytime_dataEEG = fullfile(handles.path.ONRdaytime_matlab, 'EEG_bdf_files');        