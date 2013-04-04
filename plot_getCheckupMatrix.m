% checks that the results of the calculations are the same as previously
% obtained by Levent using the R. Hamner code
function checkupMatrix = plot_getCheckupMatrix(trialMean, j, fieldIn, handles)
    
    for i = 1 : 3 % condition            
        for k = 1 : 3 % trial                
            for l = 1 : 3 % period                                   
                condIndexInv = 3-(i-1);

                % get the indices
                index1 = ((i-1) * (3*3)) + 1;
                index1_2 = index1 + ((l-1)*3);
                index1_3 = index1_2 + (k-1);

                for ij = 1 : length(trialMean{condIndexInv}.subject)

                    % now just assign the data to the correct index                    
                    checkupMatrix.mean(ij,index1_3) = trialMean{condIndexInv}.subject{ij}.bins{j}.trial{k}.period{l}.ch.(fieldIn).aver;
                    checkupMatrix.SD(ij,index1_3)   = trialMean{condIndexInv}.subject{ij}.bins{j}.trial{k}.period{l}.ch.(fieldIn).SD;

                end                
            end
        end
    end

    