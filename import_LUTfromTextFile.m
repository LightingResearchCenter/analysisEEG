function alldata_LUT = import_LUTfromTextFile(path)

    try
        fid = fopen(fullfile(path, 'alldata_lookup_table.txt'));
        alldata_LUT = textscan(fid, '%d %d %s %d %d %s', 'Delimiter', '\t', 'HeaderLines', 1);
        
    catch
        
        if fid == -1
            warning('Could not find the file from network! Are you sure the share is mounted? Trying to open the local copy')
        
            try
                fid = fopen('alldata_lookup_table.txt');
                alldata_LUT = textscan(fid, '%d %d %s %d %d %s', 'Delimiter', '\t', 'HeaderLines', 1);
            
            catch
                error('Could not find the local copy of the LUT file either')
            end
            
        end
        
    end