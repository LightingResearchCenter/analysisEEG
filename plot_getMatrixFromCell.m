function [aver, medianV, SD, N] = plot_getMatrixFromCell(ii, meanScalar, eegBandIndex, index, fieldIn, fileOutStr)

    % disp(['Period = ', num2str(1), ', Subject = ', num2str(1)])

    for ij = 1 : length(meanScalar.subject) % no of subjects
        for k = 1 : length(meanScalar.subject{ij}.bins{1}.trial) % trials
            for l = 1 : length(meanScalar.subject{ij}.bins{1}.trial{k}.period) % periods

                % so matrix size of numberOfSubjects x 9 (trials * periods)

                % get the indices
                index1 = 1; % init offset
                index1_2 = index1 + ((l-1)*3); % correct for the period
                index1_3 = index1_2 + (k-1); % correct for the correct trial

                % meanScalar.subject{ij}.bins{eegBandIndex}.trial{k}.period{l}.ch
                % meanScalar.subject{ij}.bins{eegBandIndex}.trial{k}.period{l}.ch.(fieldIn)

                try

                    if ij == 1 && l == 1 % debug
                        avDebug = meanScalar.subject{ij}.bins{eegBandIndex}.trial{k}.period{l}.ch.(fieldIn).aver;
                        debugString = sprintf('%s%s\t %s%s\t %s%s', '  k = ', num2str(k), 'aver = ', num2str(avDebug), 'eegBandIndex = ', num2str(eegBandIndex));
                        % disp(debugString)
                    end
                    aver(ij,index1_3)       = meanScalar.subject{ij}.bins{eegBandIndex}.trial{k}.period{l}.ch.(fieldIn).aver;
                    medianV(ij,index1_3)    = NaN;
                    SD(ij,index1_3)         = meanScalar.subject{ij}.bins{eegBandIndex}.trial{k}.period{l}.ch.(fieldIn).SD;
                    % N = mean(meanScalar.subject{ij}.bins{eegBandIndex}.trial{k}.period{l}.ch.powerSpec.N)
                    N(ij,index1_3)          = NaN;

                catch err

                    if ij == 1 && k == 1 && l == 1
                        warning(['   problem getting the data at EEG freq index = ', num2str(eegBandIndex), ', thus notting plotted'])
                    end
                    % err
                    % just skip this subplot if there is no data
                    aver(ij,index1_3) = NaN;
                    medianV(ij,index1_3) = NaN;
                    SD(ij,index1_3) = NaN;
                    N(ij,index1_3) = NaN;

                end % try

            end % periods
        end % trials
    end % subjects
    
    
    

