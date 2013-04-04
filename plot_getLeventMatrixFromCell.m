function [aver, medianV, SD, N] = plot_getLeventMatrixFromCell(diffIndices, cols, jj, meanScalar, eegBandIndex, fieldIn, fileOutStr)

    % disp(['Period = ', num2str(1), ', Subject = ', num2str(1)])

    for ii = 1 : length(diffIndices)                                    
        index = ((ii-1)*cols) + jj;

        for ij = 1 : length(meanScalar{ii}.subject) % no of subjects          

            for l = 1 : length(meanScalar{ii}.subject{ij}.bins{1}.trial{1}.period) % periods

                % now the diffIndices need to be inverted (white first,
                % red then, and finally the dark)
                ii_inv = 3-(ii-1);

                % get the indices
                % so matrix size of numberOfSubjects x 9 (conditions * periods)
                index1 = 1; % init offset
                index1_2 = index1 + ((l-1)*3); % correct for the period
                index1_3 = index1_2 + (ii_inv-1); % correct for the condition             

                    %% NOTE THE ORDER
                    % White, Red, Dark which is the same as for
                    % individula Excel sheets, whereas for example the
                    % RED and DARK where flipped in "ONR_EEG_DAY_LRC.xlsx"
                    % so take this into account when comparing the data                    
                    if ij == 1 % debug
                        % disp([ii ij l index1 index1_2 index1_3])
                    end

                % AVERAGE THE TRIALS
                for k = 2 : length(meanScalar{ii}.subject{ij}.bins{1}.trial) % trials
                    ind = k - 1;
                    try
                        averTmp(ind)    = meanScalar{ii}.subject{ij}.bins{eegBandIndex}.trial{k}.period{l}.ch.(fieldIn).aver;
                        medianTmp(ind)  = meanScalar{ii}.subject{ij}.bins{eegBandIndex}.trial{k}.period{l}.ch.(fieldIn).medianValue;
                        sdTmp(ind)      = meanScalar{ii}.subject{ij}.bins{eegBandIndex}.trial{k}.period{l}.ch.(fieldIn).SD;
                        nTmp(ind)       = meanScalar{ii}.subject{ij}.bins{eegBandIndex}.trial{k}.period{l}.ch.(fieldIn).N;
                    catch err
                        err
                        averTmp(ind)    = NaN;
                        medianTmp(ind)  = NaN;
                        sdTmp(ind)      = NaN;
                        nTmp(ind)       = NaN;
                    end                            
                end % trials

                % averTmp
                aver(ij,index1_3)       = nanmean(averTmp);
                medianV(ij,index1_3)    = nanmean(medianTmp);
                SD(ij,index1_3)         = nanmean(sdTmp);
                N(ij,index1_3)          = nanmean(nTmp);

            end % periods               
        end % subjects

    end % conditions