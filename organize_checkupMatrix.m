% checks that the results of the calculations are the same as previously
% obtained by Levent using the R. Hamner code
function checkupMatrix = organize_checkupMatrix(trialMean, handles)

    % for faster debugging / developing
    if nargin == 0
        handles = init_defaultSettings();
        load(fullfile(handles.path.debugMatFiles, 'tempCheckupMatrix.mat'))
    else
        if handles.saveTempDebugMATs == 1
            save(fullfile(handles.path.debugMatFiles, 'tempCheckupMatrix.mat'))
        end
    end
    
    % get data fields stored to the bins
    % e.g. (fieldsIn{fieldsInd})trum, (fieldsIn{fieldsInd})tralDensity, "dummy"
    try
        fieldsIn = fieldnames(trialMean{1}.subject{1}.bins{1}.trial{1}.period{1}.ch);
        statFields = fieldnames(trialMean{1}.subject{1}.bins{1}.trial{1}.period{1}.ch.(fieldsIn{1})); % e.g. aver, medianValue, SD, etc.
    catch err
        err        
    end
    
    % Manually match-up the bands    
    % check init_defaultSettings
    for j = 1 : 6 % the first 6 bands        
        for i = 1 : 3 % condition            
            for k = 1 : 3 % trial                
                for l = 1 : 3 % period                    
                    for fieldsInd = 1 : length(fieldsIn)
                                
                        % for statFieldsInd = 1 : length(statFields) % not used atm, update the code maybe at some point                    
                            condIndexInv = 3-(i-1);

                            % get the indices
                            index1 = ((i-1) * (3*3)) + 1;
                            index1_2 = index1 + ((l-1)*3);
                            index1_3 = index1_2 + (k-1);

                            for ij = 1 : length(trialMean{condIndexInv}.subject)

                                % ij
                                % trialMean{condIndexInv}
                                % trialMean{condIndexInv}.subject{ij}
                                % trialMean{condIndexInv}.subject{ij}.bins{j}
                                % trialMean{condIndexInv}.subject{ij}.bins{j}.trial{k}
                                % trialMean{condIndexInv}.subject{ij}.bins{j}.trial{k}.period{l}
                                % trialMean{condIndexInv}.subject{ij}.bins{j}.trial{k}.period{l}.ch.powerSpec

                                % now just assign the data to the correct index                    
                                bands{j}.(fieldsIn{fieldsInd}).mean(ij,index1_3) = trialMean{condIndexInv}.subject{ij}.bins{j}.trial{k}.period{l}.ch.(fieldsIn{fieldsInd}).aver;
                                bands{j}.(fieldsIn{fieldsInd}).SD(ij,index1_3)   = trialMean{condIndexInv}.subject{ij}.bins{j}.trial{k}.period{l}.ch.(fieldsIn{fieldsInd}).SD;
                       
                            end
                        % end
                    end                
                end
            end
        end
        
        % display on the command window
        fieldsInd = 1;
        if j == 1
            disp(handles.eegBins.label{j})
                disp('MEAN')        
                bands{j}.(fieldsIn{fieldsInd}).mean
                %disp('SD')
                %bands{j}.SD
        end
    end
    
    checkupMatrix = bands;    
    % write to Excel then     
        sub = (50 : 1 : 65)';
        organize_LRCSummaryOut(sub, bands{1}.(fieldsIn{fieldsInd}).mean, bands{3}.(fieldsIn{fieldsInd}).mean, bands{4}.(fieldsIn{fieldsInd}).mean, bands{5}.(fieldsIn{fieldsInd}).mean, handles) 
