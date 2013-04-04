clear all
close all
hold off
clc

[num, txt, raw] = xlsread('C:\LRC\2012_FALL\EEG_ONR_NIGHT\HR stats lookup.xlsx');

path = char(txt);

for s = 1:size(path, 1)
    differ = textread(path(s,:));
    sub(s) = str2num(path(s,49:50));
    trial(s) = str2num(path(s,60));
    period(s) = str2num(path(s,71));
    color(s) = path(s,81);
    
    if(color(s) == 'w')
        HRw(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = 60/mean(differ);
        cvw(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = std(differ)/mean(differ);
        stdNw(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = std(differ);
        
        %get RMS difference in time between beats
        %get number of differences that are greater than 50 ms
        sum = 0;
        counter = 0;
        for i = 1:length(differ) - 1
            sum = sum + (differ(i + 1) - differ(i))^2;
            if(abs(differ(i + 1) - differ(i)) > .05)
                counter = counter + 1;
            end
        end
        RMSSDw(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = sqrt(sum/(length(differ) - 1));
        N50w(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = counter;
        PN50w(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = 100*counter/length(differ);
        if((sub(s) == 56))
            HRw(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = NaN;
            cvw(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = NaN;
            stdNw(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = NaN;
            RMSSDw(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = NaN;
            N50w(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = NaN;
            PN50w(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = NaN;
        end
        if((sub(s) == 53) && (trial(s) == 2) && (period(s) == 3))
            HRw(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = NaN;
            cvw(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = NaN;
            stdNw(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = NaN;
            RMSSDw(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = NaN;
            N50w(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = NaN;
            PN50w(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = NaN;
        end
    elseif(color(s) == 'r')
        HRr(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = 60/mean(differ);
        cvr(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = std(differ)/mean(differ);
        stdNr(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = std(differ);
        
        %get RMS difference in time between beats
        %get number of differences that are greater than 50 ms
        sum = 0;
        counter = 0;
        for i = 1:length(differ) - 1
            sum = sum + (differ(i + 1) - differ(i))^2;
            if(abs(differ(i + 1) - differ(i)) > .05)
                counter = counter + 1;
            end
        end
        RMSSDr(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = sqrt(sum/(length(differ) - 1));
        N50r(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = counter;
        PN50r(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = 100*counter/length(differ);
    else
        HRd(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = 60/mean(differ);
        cvd(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = std(differ)/mean(differ);
        stdNd(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = std(differ);
        
        %get RMS difference in time between beats
        %get number of differences that are greater than 50 ms
        sum = 0;
        counter = 0;
        for i = 1:length(differ) - 1
            sum = sum + (differ(i + 1) - differ(i))^2;
            if(abs(differ(i + 1) - differ(i)) > .05)
                counter = counter + 1;
            end
        end
        RMSSDd(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = sqrt(sum/(length(differ) - 1));
        N50d(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = counter;
        PN50d(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = 100*counter/length(differ);
    end
end

% tempw = HRw;
% tempr = HRr;
% tempd = HRd;
% for i = 1:3
%     HRw(:,i) = HRw(:,i)./tempw(:,1);
%     HRr(:,i) = HRr(:,i)./tempr(:,1);
%     HRd(:,i) = HRd(:,i)./tempd(:,1);
% end
% for i = 4:6
%     HRw(:,i) = HRw(:,i)./tempw(:,4);
%     HRr(:,i) = HRr(:,i)./tempr(:,4);
%     HRd(:,i) = HRd(:,i)./tempd(:,4);
% end
% for i = 7:9
%     HRw(:,i) = HRw(:,i)./tempw(:,7);
%     HRr(:,i) = HRr(:,i)./tempr(:,7);
%     HRd(:,i) = HRd(:,i)./tempd(:,7);
% end
% 
% tempw = cvw;
% tempr = cvr;
% tempd = cvd;
% for i = 1:3
%     cvw(:,i) = cvw(:,i)./tempw(:,1);
%     cvr(:,i) = cvr(:,i)./tempr(:,1);
%     cvd(:,i) = cvd(:,i)./tempd(:,1);
% end
% for i = 4:6
%     cvw(:,i) = cvw(:,i)./tempw(:,4);
%     cvr(:,i) = cvr(:,i)./tempr(:,4);
%     cvd(:,i) = cvd(:,i)./tempd(:,4);
% end
% for i = 7:9
%     cvw(:,i) = cvw(:,i)./tempw(:,7);
%     cvr(:,i) = cvr(:,i)./tempr(:,7);
%     cvd(:,i) = cvd(:,i)./tempd(:,7);
% end
% 
% tempw = stdNw;
% tempr = stdNr;
% tempd = stdNd;
% for i = 1:3
%     stdNw(:,i) = stdNw(:,i)./tempw(:,1);
%     stdNr(:,i) = stdNr(:,i)./tempr(:,1);
%     stdNd(:,i) = stdNd(:,i)./tempd(:,1);
% end
% for i = 4:6
%     stdNw(:,i) = stdNw(:,i)./tempw(:,4);
%     stdNr(:,i) = stdNr(:,i)./tempr(:,4);
%     stdNd(:,i) = stdNd(:,i)./tempd(:,4);
% end
% for i = 7:9
%     stdNw(:,i) = stdNw(:,i)./tempw(:,7);
%     stdNr(:,i) = stdNr(:,i)./tempr(:,7);
%     stdNd(:,i) = stdNd(:,i)./tempd(:,7);
% end
% 
% tempw = RMSSDw;
% tempr = RMSSDr;
% tempd = RMSSDd;
% for i = 1:3
%     RMSSDw(:,i) = RMSSDw(:,i)./tempw(:,1);
%     RMSSDr(:,i) = RMSSDr(:,i)./tempr(:,1);
%     RMSSDd(:,i) = RMSSDd(:,i)./tempd(:,1);
% end
% for i = 4:6
%     RMSSDw(:,i) = RMSSDw(:,i)./tempw(:,4);
%     RMSSDr(:,i) = RMSSDr(:,i)./tempr(:,4);
%     RMSSDd(:,i) = RMSSDd(:,i)./tempd(:,4);
% end
% for i = 7:9
%     RMSSDw(:,i) = RMSSDw(:,i)./tempw(:,7);
%     RMSSDr(:,i) = RMSSDr(:,i)./tempr(:,7);
%     RMSSDd(:,i) = RMSSDd(:,i)./tempd(:,7);
% end
% 
% tempw = PN50w;
% tempr = PN50r;
% tempd = PN50d;
% for i = 1:3
%     PN50w(:,i) = PN50w(:,i)./tempw(:,1);
%     PN50r(:,i) = PN50r(:,i)./tempr(:,1);
%     PN50d(:,i) = PN50d(:,i)./tempd(:,1);
% end
% for i = 4:6
%     PN50w(:,i) = PN50w(:,i)./tempw(:,4);
%     PN50r(:,i) = PN50r(:,i)./tempr(:,4);
%     PN50d(:,i) = PN50d(:,i)./tempd(:,4);
% end
% for i = 7:9
%     PN50w(:,i) = PN50w(:,i)./tempw(:,7);
%     PN50r(:,i) = PN50r(:,i)./tempr(:,7);
%     PN50d(:,i) = PN50d(:,i)./tempd(:,7);
% end
    

data = {'Subject', 'WT1', 'WT2', 'WT3', 'WT4', 'WT5', 'WT6', 'WT7', 'WT8', 'WT9', 'RT1', 'RT2', 'RT3', 'RT4', 'RT5', 'RT6', 'RT7', 'RT8', 'RT9', 'DT1', 'DT2', 'DT3', 'DT4', 'DT5', 'DT6', 'DT7', 'DT8', 'DT9'};
for i = 1:20
    data(i + 1,:) = {i + 65, HRw(i, 1), HRw(i, 2), HRw(i, 3), HRw(i, 4), HRw(i, 5), HRw(i, 6), HRw(i, 7), HRw(i, 8), HRw(i, 9), HRr(i, 1), HRr(i, 2), HRr(i, 3), HRr(i, 4), HRr(i, 5), HRr(i, 6), HRr(i, 7), HRr(i, 8), HRr(i, 9), HRd(i, 1), HRd(i, 2), HRd(i, 3), HRd(i, 4), HRd(i, 5), HRd(i, 6), HRd(i, 7), HRd(i, 8), HRd(i, 9)};
end
xlswrite('HRstats_results_raw.xls', data, 'HR');

data = {'Subject', 'WT1', 'WT2', 'WT3', 'WT4', 'WT5', 'WT6', 'WT7', 'WT8', 'WT9', 'RT1', 'RT2', 'RT3', 'RT4', 'RT5', 'RT6', 'RT7', 'RT8', 'RT9', 'DT1', 'DT2', 'DT3', 'DT4', 'DT5', 'DT6', 'DT7', 'DT8', 'DT9'};
for i = 1:20
    data(i + 1,:) = {i + 65, cvw(i, 1), cvw(i, 2), cvw(i, 3), cvw(i, 4), cvw(i, 5), cvw(i, 6), cvw(i, 7), cvw(i, 8), cvw(i, 9), cvr(i, 1), cvr(i, 2), cvr(i, 3), cvr(i, 4), cvr(i, 5), cvr(i, 6), cvr(i, 7), cvr(i, 8), cvr(i, 9), cvd(i, 1), cvd(i, 2), cvd(i, 3), cvd(i, 4), cvd(i, 5), cvd(i, 6), cvd(i, 7), cvd(i, 8), cvd(i, 9)};
end
xlswrite('HRstats_results_raw.xls', data, 'CV');

data = {'Subject', 'WT1', 'WT2', 'WT3', 'WT4', 'WT5', 'WT6', 'WT7', 'WT8', 'WT9', 'RT1', 'RT2', 'RT3', 'RT4', 'RT5', 'RT6', 'RT7', 'RT8', 'RT9', 'DT1', 'DT2', 'DT3', 'DT4', 'DT5', 'DT6', 'DT7', 'DT8', 'DT9'};
for i = 1:20
    data(i + 1,:) = {i + 65, stdNw(i, 1), stdNw(i, 2), stdNw(i, 3), stdNw(i, 4), stdNw(i, 5), stdNw(i, 6), stdNw(i, 7), stdNw(i, 8), stdNw(i, 9), stdNr(i, 1), stdNr(i, 2), stdNr(i, 3), stdNr(i, 4), stdNr(i, 5), stdNr(i, 6), stdNr(i, 7), stdNr(i, 8), stdNr(i, 9), stdNd(i, 1), stdNd(i, 2), stdNd(i, 3), stdNd(i, 4), stdNd(i, 5), stdNd(i, 6), stdNd(i, 7), stdNd(i, 8), stdNd(i, 9)};
end
xlswrite('HRstats_results_raw.xls', data, 'STD');

data = {'Subject', 'WT1', 'WT2', 'WT3', 'WT4', 'WT5', 'WT6', 'WT7', 'WT8', 'WT9', 'RT1', 'RT2', 'RT3', 'RT4', 'RT5', 'RT6', 'RT7', 'RT8', 'RT9', 'DT1', 'DT2', 'DT3', 'DT4', 'DT5', 'DT6', 'DT7', 'DT8', 'DT9'};
for i = 1:20
    data(i + 1,:) = {i + 65, RMSSDw(i, 1), RMSSDw(i, 2), RMSSDw(i, 3), RMSSDw(i, 4), RMSSDw(i, 5), RMSSDw(i, 6), RMSSDw(i, 7), RMSSDw(i, 8), RMSSDw(i, 9), RMSSDr(i, 1), RMSSDr(i, 2), RMSSDr(i, 3), RMSSDr(i, 4), RMSSDr(i, 5), RMSSDr(i, 6), RMSSDr(i, 7), RMSSDr(i, 8), RMSSDr(i, 9), RMSSDd(i, 1), RMSSDd(i, 2), RMSSDd(i, 3), RMSSDd(i, 4), RMSSDd(i, 5), RMSSDd(i, 6), RMSSDd(i, 7), RMSSDd(i, 8), RMSSDd(i, 9)};
end
xlswrite('HRstats_results_raw.xls', data, 'RMS');
    
data = {'Subject', 'WT1', 'WT2', 'WT3', 'WT4', 'WT5', 'WT6', 'WT7', 'WT8', 'WT9', 'RT1', 'RT2', 'RT3', 'RT4', 'RT5', 'RT6', 'RT7', 'RT8', 'RT9', 'DT1', 'DT2', 'DT3', 'DT4', 'DT5', 'DT6', 'DT7', 'DT8', 'DT9'};
for i = 1:20
    data(i + 1,:) = {i + 65, PN50w(i, 1), PN50w(i, 2), PN50w(i, 3), PN50w(i, 4), PN50w(i, 5), PN50w(i, 6), PN50w(i, 7), PN50w(i, 8), PN50w(i, 9), PN50r(i, 1), PN50r(i, 2), PN50r(i, 3), PN50r(i, 4), PN50r(i, 5), PN50r(i, 6), PN50r(i, 7), PN50r(i, 8), PN50r(i, 9), PN50d(i, 1), PN50d(i, 2), PN50d(i, 3), PN50d(i, 4), PN50d(i, 5), PN50d(i, 6), PN50d(i, 7), PN50d(i, 8), PN50d(i, 9)};
end
xlswrite('HRstats_results_raw.xls', data, 'P50');

deleteEmptyExcelSheets('C:\LRC\2012_FALL\EEG_ONR_NIGHT\matlab\HRstats_results_raw.xls');