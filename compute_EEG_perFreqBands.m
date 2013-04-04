function [ps_bins, freqsOut] = compute_EEG_perFreqBands(ch, w, k, Hmss, ps, identifiers, freqBinMode, indivPeak, handles)

   
    %% get the correct indicies for freqency bins of interest
    % defined in init_defaultSettings
    
        % these are relative if we have "individual alpha peak" -mode
        if strcmp(freqBinMode, 'indivAlpha') == 1
            handles.eegBins.freqs{k} = handles.eegBins.freqs{k} + indivPeak;
            freqsOut = handles.eegBins.freqs{k};
        elseif strcmp(freqBinMode, 'ratios') == 1
            
            % numerator of the ratio
            if handles.eegBins.indivFlag{k}(1) == 1
                handles.eegBins.freqs{k}{1} = handles.eegBins.freqs{k}{1} + indivPeak;
            else
                handles.eegBins.freqs{k}{1} = handles.eegBins.freqs{k}{1};
            end
            
            % denominator
            if handles.eegBins.indivFlag{k}(2) == 1
                handles.eegBins.freqs{k}{2} = handles.eegBins.freqs{k}{2} + indivPeak;
            else
                handles.eegBins.freqs{k}{2} = handles.eegBins.freqs{k}{2};
            end
            
            freqsOut = handles.eegBins.freqs{k};
        elseif strcmp(freqBinMode, 'fixed') == 1
            freqsOut = handles.eegBins.freqs{k}; 
        end
    
       if strcmp(freqBinMode, 'fixed') == 1                        
            eegBandIndices = handles.eegBins.freqIndices{k};
        
       elseif strcmp(freqBinMode, 'ratios') == 1
            eegBandIndices1 = init_preComputeFrequencyIndices(handles.eegBins.freqs{k}{1}, Hmss.frequencies, handles);
            eegBandIndices2 = init_preComputeFrequencyIndices(handles.eegBins.freqs{k}{2}, Hmss.frequencies, handles);
            
       elseif strcmp(freqBinMode, 'indivAlpha') == 1
           eegBandIndices = init_preComputeFrequencyIndices(handles.eegBins.freqs{k}, Hmss.frequencies, handles);
           
            %            if k == 142
            %                eegBandIndices
            %                disp(k)
            %            end
       end

   %% Assign the input data to the output   
   
       ps_bins.freqs = handles.eegBins.freqs{k};
       ps_bins.label = handles.eegBins.label{k};
       % ps_bins.ch = handles.eegBins.ch{k};
       
       %% FOR INDIVIDUAL ALPHA PEAK AND RATIOS you have to recompute the indices actually (FIND)

       % Assign the data points to the cell  
       if strcmp(freqBinMode, 'indivAlpha') == 1 || strcmp(freqBinMode, 'fixed') == 1
           ps_bins.powerSpec_frequencies = Hmss.frequencies(eegBandIndices);
           ps_bins.data.powerSpectrum = Hmss.Data(eegBandIndices);
           
           % replace with PSD at some point
           ps_bins.data.dummy = ps_bins.data.powerSpectrum;
           ps_bins.data.dummy(:) = NaN;
           
       elseif strcmp(freqBinMode, 'ratios') == 1
           ps_bins.powerSpec_frequencies{1} = Hmss.frequencies(eegBandIndices1);
           ps_bins.powerSpec_frequencies{2} = Hmss.frequencies(eegBandIndices2);
           ps_bins.data.powerSpectrum{1} = Hmss.Data(eegBandIndices1);
           ps_bins.data.powerSpectrum{2} = Hmss.Data(eegBandIndices2);
           
           if isempty(ps_bins.data.powerSpectrum{2})
               warning('powerSpectrum empty! problem with individual alpha-based bands?')
           end
           
           %            if k == 159 % debug
           %                freqsIn_k = handles.eegBins.freqs{k}
           %                freqsIn1 = handles.eegBins.freqs{k}{1}
           %                freqsIn2 = handles.eegBins.freqs{k}{2}
           %                ind1 = eegBandIndices1
           %                ind2 = eegBandIndices2
           %                f1 = ps_bins.powerSpec_frequencies{1}
           %                f2 = ps_bins.powerSpec_frequencies{2}
           %                ps1 = ps_bins.data.powerSpectrum{1}
           %                ps2 = ps_bins.data.powerSpectrum{2}
           %                pause
           %            end             
           
           % replace with PSD at some point
           ps_bins.data.dummy{1} = ps_bins.data.powerSpectrum{1};
           ps_bins.data.dummy{1}(:) = NaN;
           ps_bins.data.dummy{2} = ps_bins.data.dummy{1};
           
       end

  
   %% Confidence intervals are typically empty 
   % (see why at some point?)
   
       if ~isempty(Hmss.ConfInterval)

           try % if for some reasons the indices are not good
                if strcmp(freqBinMode, 'indivAlpha') == 1 || strcmp(freqBinMode, 'fixed') == 1
                    ps_bins.ConfInterval = Hmss.ConfInterval(eegBandIndices);         
                
                elseif strcmp(freqBinMode, 'ratios') == 1
                    ps_bins.ConfInterval{1} = Hmss.ConfInterval(eegBandIndices1);         
                    ps_bins.ConfInterval{2} = Hmss.ConfInterval(eegBandIndices2);         
                end

           catch err
               
                err                
                error('what kind of indices were found really?')
                
                if strcmp(freqBinMode, 'indivAlpha') == 1 || strcmp(freqBinMode, 'fixed') == 1
                    ps_bins.ConfInterval = [];         
                
                elseif strcmp(freqBinMode, 'ratios') == 1
                    ps_bins.ConfInterval{1} = [];         
                    ps_bins.ConfInterval{2} = [];         
                end
                
                
           end
       else
           ps_bins.ConfInterval = [];
       end

       % ps_bins.confLevel = Hmss.ConfLevel;

   %% Assing the identifiers to the cell structure
   
       ps_bins.filename = identifiers.filename;
       ps_bins.fileNameWoPath = identifiers.fileNameWoPath;
       ps_bins.sub = identifiers.sub;
       ps_bins.period = identifiers.period;
       ps_bins.trial = identifiers.trial;
       ps_bins.color = identifiers.color;                       
