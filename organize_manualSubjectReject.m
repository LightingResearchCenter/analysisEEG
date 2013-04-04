function [aver, medianValue, SD_rms, SD, N] = organize_manualSubjectReject(i, ij, k, j, l, aver, medianValue, SD_rms, SD, N)

    % aver
    % whos
    
    %% MOVE A BIT EARLIER IN THE SCRIPT at some point, computationally inefficient here

    subjOffset = 49;
    
    if length(aver) == 1 && k ~= 1 % from organize_averageForScalars
        
        if i == 3 && ij+subjOffset == 56
            
            % subject 56 should go here
            %disp(['subject = ', num2str(ij+subjOffset), ', trial = ', num2str(k), ', period = ', num2str(l), ', freqBin = ', num2str(j), ', aver = ', num2str(nanmean(aver)), '    ... convert to NaN'])
            aver = NaN;
            medianValue = NaN;
            SD_rms = NaN;
            SD = NaN;   
            N = NaN;
        end
        
    else % from organize_averageTheTrials       
        
        if i == 3 && ij+subjOffset == 56 &&  k ~= 1             
            
            % subject 56 should go here
            % disp(['subject = ', num2str(ij+subjOffset), ', trial = ', num2str(k), ', period = ', num2str(l), ', freqBin = ', num2str(j), ', aver = ', num2str(nanmean(aver)), '    ... convert to NaN'])                        
            aver(:) = NaN;
            medianValue(:) = NaN;
            SD_rms(:) = NaN;
            try
                SD(:) = NaN;   
            catch
                aver
                medianValue
                SD_rms
                SD
                N
            end
            N(:) = NaN;
            
        end
        
    end

  