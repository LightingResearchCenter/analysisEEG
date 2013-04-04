% The MAIN function of the EEG Analysis, RUN THIS!
function MAIN_AnalysisEEG()

    % Petteri Teikari, LRC, 2013
    clear all
    close all
    
    %% Initialize the analysis program
        
        % Set default settings for the analysis
        handles = init_defaultSettings();   
            handles
        
        % init the Parallel Computing Toolbox
        noOfCores = 1;
        % init_parallelComputing(noOfCores);
                
        
              
            %% Some user-defined settings ("checkboxes")
            % keep them at 1 if you don't know what they mean, that way you get
            % correct results always, but the computation might take some
            % longer than optimizing these switches, 
            
                % change mainly these, ignore the ones above if you are not
                % debugging this code            
                handles.filterAndProcess_BDFs               = 0;
                handles.recalculateAlphaPeaksFromMATfiles   = 1;
                handles.organizedFromMAT                    = 1;
           
                    % these mainly for debugging
                    % don't touch if you are just using this script
                    handles.saveToExcelFiles = 1;
                    handles.saveBDFsAsMats = 0;
                    handles.processBdfFiles = 1;
                    handles.saveIndivivEEGsAsFigures = 0;
                    handles.saveBDFs_toIndividualMats = 1;
                    handles.saveTempDebugMATs = 1;            
                
            % Define different conditions
            handles.colorConditionCell = {'Dark'; 'Red'; 'White'};
            
            % General debug switch
            handles.showDebugMessages = 0;
            
            % settings when auto-saving figures, see exportfig.m for more details
            handles.figureOut_ON                = 1;
            handles.figureOut_resolution        = '-r300';  
            handles.figureOut_format            = 'png';        
            handles.figureOut_antialiasLevel    = '-a2';
    
    
    %% Import the data from .bdf files
    tic;
        % INCLUDING
        % ------------------------------------------
        % * Filtering the EEG recordings (band-pass)
        % * Removing Artifacts
        % * Computing the Power Spectrum
        % * Putting the Power Spectrum to frequency bins (defined in
        %   initDefaultSettings.m)    
        
            % Import the filenames and the session identifiers from LookUpTable
            % This file used to be .xlsx, but for simplicity I saved it to a
            % TEXT file (PETTERI)
            disp(' importing the alldata LUT')
            alldata_LUT = import_LUTfromTextFile(handles.path.cloudInputFiles);

            % READ FROM DISK (time-consuming, time can be saved by reading directly from
            % the .MAT file, however if you change the parameters inside the
            % process script, you need to run the analysis again for new .MAT)
            savenameMAT = importMain(alldata_LUT, handles);
            timing.import = toc;    
        
    %% Organize the Data
    tic;    
        % Re-organize data so that the stats are easy to calculate for each
        % condition (Dark / Red / Blue)
        dataOrganized = organizeMain(savenameMAT, alldata_LUT, handles);
        timing.organization = toc;
   

    %% PLOT
    tic;
        plotMainEEG(dataOrganized, handles)
        timing.plotting = toc;    
    timing