% Wrapper function for organizing the data
function dataOrganized_subjAve = organizeMain(savenameMAT, alldata_LUT, handles)
   
    % BOOLEAN FLAGS (mainly for debugging)
        skipByCondition             = 0;
        skipNormalize               = 0;    
        skipAverageTrials           = 0;
        skipScalarAverages          = 0;
        skipComputeCheckUpMatrix    = 0;
        skipAverageSubjects         = 0;
        skipAverageSubjects_wTrials = 1;
    
    if handles.organizedFromMAT == 0
    
        % Preallocate Cells
        dataOrganized = cell(length(handles.colorConditionCell),1); 
            % size e.g. 3 x 1 : (3,1) - Dark / Red / White                                

        %% Organize by condition        

            % this part takes quite long time, other parts of this code are
            % faster so you typically want to skip this one
            matFileName = 'dataOrg_mat_1stPass.mat';
            
            if skipByCondition == 0          
                dataOrganized = organize_byCondition(savenameMAT, alldata_LUT, handles);                
                disp(['          saving "', matFileName, '"'])
                save(fullfile(handles.path.organizeMatFiles, matFileName), 'dataOrganized')
            else
                if skipNormalize ~= 1
                    disp(['       loading "', matFileName, '"'])
                    load(fullfile(handles.path.organizeMatFiles, matFileName))
                else
                    % no need to load this if next step is loaded from MAT
                    % as well
                end
            end

        %% Normalize to trial 1
        
            matFileName = 'dataOrg_mat_normalized.mat';            
                        
            if skipNormalize == 0
                dataOrganized_norm = organize_normalizeToTrialOne(dataOrganized, handles);                
                disp(['          saving "', matFileName, '"'])
                whos
                clear dataOrganized
                whos
                % save(fullfile(handles.path.organizeMatFiles,
                % matFileName), 'dataOrganized_norm', '-v7.3') 2.9 GB
            else
                if skipAverageTrials ~= 1
                    disp(['       loading "', matFileName, '"'])
                    % load(fullfile(handles.path.organizeMatFiles,
                    % matFileName)) 2.9 GB
                else
                    % no need to load this if next step is loaded from MAT
                    % as well
                end
            end
       

        %% Average the trials (3 trials, average of them)
            
            % note that this function works as well with the non-normalized
            % data so you can give the dataOrganized as input argument as well,
            % or call this function twice with different input arguments if
            % needed            
            matFileName = 'dataOrg_mat_trialsAveraged.mat';
            
            if skipAverageTrials == 0
                dataOrganized_trialAve = organize_averageTheTrials(dataOrganized_norm, handles);
                disp(['          saving "', matFileName, '"'])
                % save(fullfile(handles.path.organizeMatFiles, matFileName), 'dataOrganized_trialAve')
                whos
            else
                disp(['       loading "', matFileName, '"'])
                load(fullfile(handles.path.organizeMatFiles, matFileName))
            end

         %% Get scalar averages (to correspond to the old code)        
            matFileName = 'dataOrg_mat_scalarAveraged.mat';
            
            if skipScalarAverages == 0
                whos
                data_organized_meanScalar = organize_averageForScalars(dataOrganized_norm, handles);
                disp(['          saving "', matFileName, '"'])
                save(fullfile(handles.path.organizeMatFiles, matFileName), 'data_organized_meanScalar')
            else
                disp(['       loading "', matFileName, '"'])
                load(fullfile(handles.path.organizeMatFiles, matFileName))
            end
                    
            
        %% Compute "check-up matrix" to compare the current code to the original code (R. Hamner)
            
            % and the mean power spectra found in Excel sheet "LRCSummary_norm3.xls"            
            matFileName = 'dataOrg_mat_checkupMatrix.mat';
            
            if skipComputeCheckUpMatrix == 0
                dataOrganized_checkupMatrix = organize_checkupMatrix(data_organized_meanScalar, handles);
                disp(['          saving "', matFileName, '"'])
                save(fullfile(handles.path.organizeMatFiles, matFileName), 'dataOrganized_checkupMatrix')
            else
                disp(['       loading "', matFileName, '"'])
                load(fullfile(handles.path.organizeMatFiles, matFileName))
            end        
            

        %% Average the subjects (from averaged trials)        

            % note that this function works as well with the non-normalized
            % data so you can give the dataOrganized as input argument as well,
            % or call this function twice with different input arguments if
            % needed
            matFileName = 'dataOrg_mat_subjAveraged.mat';            
            
            if skipAverageSubjects == 0
                whos
                dataOrganized_subjAve = organize_averageTheSubjects(dataOrganized_trialAve, handles);
                disp(['          saving "', matFileName, '"'])
                save(fullfile(handles.path.matFiles, matFileName), 'dataOrganized_subjAve') % this is rather small file so we save it to Cloud
            else
                disp(['       loading "', matFileName, '"'])
                load(fullfile(handles.path.matFiles, matFileName))
            end

        %% Average the subjects (from all the trials)        

            % note that this function works as well with the non-normalized
            % data so you can give the dataOrganized as input argument as well,
            % or call this function twice with different input arguments if
            % needed
            matFileName = 'dataOrg_mat_subjAveraged_wTrials.mat';  
            
            if skipAverageSubjects_wTrials == 0
                % dataOrganized_subjAve_wTrials = organize_averageTheSubjects_wTrials(dataOrganized_norm, handles);
                disp(['          saving "', matFileName, '"'])
                save(fullfile(handles.path.matFiles, matFileName), 'dataOrganized_subjAve_wTrials')
            else
                disp(['       loading "', matFileName, '"'])
                load(fullfile(handles.path.matFiles, matFileName))
            end
            
    else
        
        % skip the time-consuming computations and load the results from a
        % .MAT-file
        disp('       Skipping the organizeMain -computations, and loading results from "dataOrg_mat_subjAveraged.mat"')
        load(fullfile(handles.path.matFiles, 'dataOrg_mat_subjAveraged.mat'))
        
    end
