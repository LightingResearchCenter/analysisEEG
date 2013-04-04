function [ps_bins, indexForCondition] = organize_initDataForPARFORLoop(savenameMAT, i, condition, eegSet, sub, session, period, trial, handles)

    % LOAD THE MAT file SAVED TO DISK
    if i == 1; disp(' '); end            
    disp(['      Organizing FILE: ', num2str(i), '/', num2str(length(savenameMAT)), ' - ', datestr(now)])
    load(savenameMAT{i}); % ps_bins inside this

    % whos

    % define the cell index based on the condition in the input file
    % in other words WHITE / RED / DARK
    try
        indexForCondition = find(strcmp(condition(i), eegSet.conditionsOnFiles), 1);
            % e.g. 1 for dark, 2 for red, 3 for white       
    catch
        if isempty(indexForCondition) % check if no condition is matched
            disp(['Color saved to file is = ', ps_bins{1}{1}{1}.color])
            error('Something is wrong with the color definition of the processed .MAT file')            
        end 
    end

    %% INSPECT the INPUT DATA        
    disp(['            indexForCondition: ', handles.colorConditionCell{indexForCondition}, ', subject: ', num2str(sub(i)), ', condition: ', num2str(condition(i)), ', period: ', num2str(period(i)), ', trial: ', num2str(trial(i))])        
    disp(['            file: ', savenameMAT{i}])
    % disp(['     no of freq bins: ', num2str(length(ps_bins{1}{1}))])  

        if isempty(ps_bins{1}{1})
            warning('no freq bins found for the first time bin! This might be due to artifacts in the raw EEG data')
            % ps_bins
        end

        % % identifiers for the data
        % if isempty(ps_bins{1}{1})
        %     dataOrganized{indexForCondition}.freqs = ps_bins{1}{1}{1}.freqs;
        %     dataOrganized{indexForCondition}.label = ps_bins{1}{1}{1}.label;
        %     dataOrganized{indexForCondition}.subject = ps_bins{1}{1}{1}.sub;
        %     dataOrganized{indexForCondition}.confLevel = ps_bins{1}{1}{1}.confLevel;
        % else % correct later
        %     dataOrganized{indexForCondition}.subject{subjectIndex}.bins{j}.trial{k}.period{l}.freqs = NaN;
        %     dataOrganized{indexForCondition}.subject{subjectIndex}.bins{j}.trial{k}.period{l}.label = NaN;
        %     dataOrganized{indexForCondition}.subject{subjectIndex}.bins{j}.trial{k}.period{l}.subject = NaN;
        %     dataOrganized{indexForCondition}.subject{subjectIndex}.bins{j}.trial{k}.period{l}.confLevel = NaN;
        % end