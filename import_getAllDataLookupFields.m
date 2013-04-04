function [sub, period, color, condition, trial, session, path, q, numberOfSubjects, subjectOffset] = ...
    import_getAllDataLookupFields(alldata_LUT)

    disp('    getting info from LUT')
    
    %% NOTE from PETTERI
    % Now the Trial and Period are inversed from the meanings used before
    % with the R. Hamner code
    
        % Period (time of the day, recordings at 3 different times of the day)
        % Trial (within each period, three trials were done, first being the dark)
    
    %% GET THE FIELDS
        
        % Retrieve the subject code
        sub = alldata_LUT{1};
            numberOfSubjects = max(sub) - min(sub) + 1;
            subjectOffset = min(sub) -1; % needed when indexing data to matrix/cell

        % There were three trials for each of different period (3x) and for
        % different color (3x) conditions, thus there are 27 recordings for
        % each subject
        trial = alldata_LUT{2};    

        % Color of the light stimulus (d,r,w : dark / red / white)
        color = cell2mat(alldata_LUT{3});
        condition = color; % twice from Robert's old code

        % Period, (1,2,3 : three different times of the day when the experiment
        % was done)
        period = alldata_LUT{4};   

        % Session (1,2,3) refers to the colors, colors as numbers
        session = alldata_LUT{5};

        % The path on hard drive where the .bdf is found corresponding to the
        % recording session    
        path = alldata_LUT{6};
    
    %% Some old R. Hamner code
    
        % EMPTY why? [Petteri]
            %color(1,:) = [];
            %path(1,:) = [];    
            %condition(1,:) = [];       
            q = [];

        %remove non-darks, what is the purpose of this? (PETTERI)
        % JUST TO MANUALLY GO THROUGH ONE CONDITION?

            %         mark = zeros(length(sub), 1);
            %         for s = 1:length(sub)
            %         %     if(~strcmp(color(s,1), 'd') || (trial(s) ~= 1))
            %             if(~strcmp(color(s, 1), 'd'))% || (sub(s) == 56))
            %                 mark(s) = 1;
            %                 %color(s,1)
            %                 %trial(s)
            %             end
            %         end

            %     q = find(mark == 1);
            %     % condition(q,:) = [];
            %     sub(q) = [];
            %     trial(q) = [];
            %     color(q,:) = [];
            %     period(q,:) = [];
            %     path(q,:) = [];
            %     q = [];
