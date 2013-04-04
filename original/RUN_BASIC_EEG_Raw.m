clear all
close all
hold off
clc

[num, txt, data] = xlsread('C:\LRC\2012_FALL\EEG_ONR_DAY\HAMNER\alldata_lookup_table.xlsx');

sub = num(:,1);
period = num(:,2);
color = char(txt(:,3));
trial = num(:,4);
session = num(:,5);
path = char(txt(:,6));

color(1,:) = [];
path(1,:) = [];

for s = 1:length(sub)
    savename = ['C:\LRC\2012_FALL\EEG_ONR_DAY\HAMNER\Excel Power Spectra\Subject ', num2str(sub(s)), '_Period ', num2str(period(s)), '_Color ', color(s), '_Trial ', num2str(trial(s)), '_processed.xls']
    path(s,:)
    if(~exist(savename, 'file'))
        OkamotoPS_func_notrigger(path(s,:), savename, sub(s), period(s), trial(s), color(s));
        close all
        datestr(now)
    end
end

%%DARK
[num, txt, data] = xlsread('C:\LRC\2012_FALL\EEG_ONR_DAY\HAMNER\alldata_lookup_table.xlsx');

sub = num(:,1);

condition = char(txt(:,3));
condition(1,:) = [];

trial = num(:,2);

sub = num(:,1);
period = num(:,2);
color = char(txt(:,3));
trial = num(:,4);
session = num(:,5);
path = char(txt(:,6));

color(1,:) = [];
path(1,:) = [];

%remove non-darks
mark = zeros(length(sub), 1);
for s = 1:length(sub)
%     if(~strcmp(color(s,1), 'd') || (trial(s) ~= 1))
    if(~strcmp(color(s, 1), 'd'))% || (sub(s) == 56))
        mark(s) = 1;
        color(s,1)
        trial(s)
    end
end

q = find(mark == 1);
condition(q,:) = [];
sub(q) = [];
trial(q) = [];
color(q,:) = [];
period(q,:) = [];
path(q,:) = [];
q = [];

%pull in and average power spectra
for s = 1:length(sub)
    loadfile = ['C:\LRC\2012_FALL\EEG_ONR_DAY\HAMNER\Excel Power Spectra\Subject ', num2str(sub(s)), '_Period ', num2str(period(s)), '_Color ', color(s), '_Trial ', num2str(trial(s)), '_processed.xls']
    [num, txt, raw] = xlsread(loadfile);
    
%     %eliminate NAN's
%     col = num(1,:);
%     q = find(isnan(col));
%     num(:,q) = [];

    marks = zeros(150, 1);
    for i = 1:560
        row = num(i,:);
        q = find(isnan(row));
        marks(q) = marks(q) + 1;
        q = [];
    end
    q = find(marks > 0);
    num(:,q) = [];
    
    %pull out frequency column
    freq = num(:,1);
    num(:,1) = [];
    
    %ps is the average power spectrum for each channel
    ps = mean(num, 2);
    
    %alpha is 8 - 12 Hz on Pz and Oz
    dalpha(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = mean([ps(335:343);ps(415:423)]);
    
    %high alpha is 10.5 - 11 Hz on Pz and Oz
    dhalpha(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = mean([ps(340:341);ps(420:421)]);
    
    %beta is 13 - 30 Hz on Fz and Cz
    dbeta(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = mean([ps(185:219);ps(265:299)]);
    
    %theta is 5 - 7 Hz on Fz and Cz
    dtheta(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = mean([ps(169:173);ps(249:253)]);
    
    %alpha-theta is 5 - 9 Hz on all channels
    datheta(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = mean([ps(169:177);ps(249:257);ps(329:337);ps(409:417)]);
end
pause

%normalize to 1 for period 1 of each trial
tempa = dalpha;
temph = dhalpha;
tempb = dbeta;
tempt = dtheta;
tempat = datheta;
% for i = 1:9
%     dalpha(:,i) = tempa(:,i)./tempa(:,1);
%     dhalpha(:,i) = temph(:,i)./temph(:,1);
%     dbeta(:,i) = tempb(:,i)./tempb(:,1);
%     dtheta(:,i) = tempt(:,i)./tempt(:,1);
%     datheta(:,i) = tempat(:,i)./tempat(:,1);
% end
% for i = 4:6
%     dalpha(:,i) = tempa(:,i)./tempa(:,4);
%     dhalpha(:,i) = temph(:,i)./temph(:,4);
%     dbeta(:,i) = tempb(:,i)./tempb(:,4);
%     dtheta(:,i) = tempt(:,i)./tempt(:,4);
%     datheta(:,i) = tempat(:,i)./tempat(:,4);
% end
% for i = 7:9
%     dalpha(:,i) = tempa(:,i)./tempa(:,7);
%     dhalpha(:,i) = temph(:,i)./temph(:,7);
%     dbeta(:,i) = tempb(:,i)./tempb(:,7);
%     dtheta(:,i) = tempt(:,i)./tempt(:,7);
%     datheta(:,i) = tempat(:,i)./tempat(:,7);
% end

% %remove missing subjects
% col = dalpha(:,1);
% q = find(isnan(col));
% dalpha(q,:) = [];
% dhalpha(q,:) = [];
% dbeta(q,:) = [];
% dtheta(q,:) = [];
% datheta(q,:) = [];
% q = [];
% 
% col = dalpha(:,1);
% q = find(col == 0);
% dalpha(q,:) = NaN;
% dhalpha(q,:) = NaN;
% dbeta(q,:) = NaN;
% dtheta(q,:) = NaN;
% datheta(q,:) = NaN;
% q = [];

%%RED
[num, txt, data] = xlsread('C:\LRC\2012_FALL\EEG_ONR_DAY\HAMNER\alldata_lookup_table.xlsx');

sub = num(:,1);

condition = char(txt(:,3));
condition(1,:) = [];

trial = num(:,2);

sub = num(:,1);
period = num(:,2);
color = char(txt(:,3));
trial = num(:,4);
session = num(:,5);
path = char(txt(:,6));

color(1,:) = [];
path(1,:) = [];

%remove non-darks
mark = zeros(length(sub), 1);
for s = 1:length(sub)
%     if(~strcmp(color(s,1), 'd') || (trial(s) ~= 1))
    if(~strcmp(color(s, 1), 'r'))  %|| (sub(s) == 56))
        mark(s) = 1;
        color(s,1)
        trial(s)
    end
end

q = find(mark == 1);
condition(q,:) = [];
sub(q) = [];
trial(q) = [];
color(q,:) = [];
period(q,:) = [];
q = [];

%pull in and average power spectra
for s = 1:length(sub)
    loadfile = ['C:\LRC\2012_FALL\EEG_ONR_DAY\HAMNER\Excel Power Spectra\Subject ', num2str(sub(s)), '_Period ', num2str(period(s)), '_Color ', color(s), '_Trial ', num2str(trial(s)), '_processed.xls']
    [num, txt, raw] = xlsread(loadfile);
    
%     %eliminate NAN's
%     col = num(1,:);
%     q = find(isnan(col));
%     num(:,q) = [];

    marks = zeros(150, 1);
    for i = 1:560
        row = num(i,:);
        q = find(isnan(row));
        marks(q) = marks(q) + 1;
        q = [];
    end
    q = find(marks > 0);
    num(:,q) = [];
    
    %pull out frequency column
    freq = num(:,1);
    num(:,1) = [];
    
    %ps is the average power spectrum for each channel
    ps = mean(num, 2);
    
    %alpha is 8 - 12 Hz on Pz and Oz
    ralpha(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = mean([ps(335:343);ps(415:423)]);
    
    %high alpha is 10.5 - 11 Hz on Pz and Oz
    rhalpha(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = mean([ps(340:341);ps(420:421)]);
    
    %beta is 13 - 30 Hz on Fz and Cz
    rbeta(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = mean([ps(185:219);ps(265:299)]);
    
    %theta is 5 - 7 Hz on Fz and Cz
    rtheta(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = mean([ps(169:173);ps(249:253)]);
    
    %alpha-theta is 5 - 9 Hz on all channels
    ratheta(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = mean([ps(169:177);ps(249:257);ps(329:337);ps(409:417)]);
    
end

%normalize to 1 for trial 1
tempa = ralpha;
temph = rhalpha;
tempb = rbeta;
tempt = rtheta;
tempat = ratheta;
% for i = 1:9
%     ralpha(:,i) = tempa(:,i)./tempa(:,1);
%     rhalpha(:,i) = temph(:,i)./temph(:,1);
%     rbeta(:,i) = tempb(:,i)./tempb(:,1);
%     rtheta(:,i) = tempt(:,i)./tempt(:,1);
%     ratheta(:,i) = tempat(:,i)./tempat(:,1);
% end
% for i = 4:6
%     ralpha(:,i) = tempa(:,i)./tempa(:,4);
%     rhalpha(:,i) = temph(:,i)./temph(:,4);
%     rbeta(:,i) = tempb(:,i)./tempb(:,4);
%     rtheta(:,i) = tempt(:,i)./tempt(:,4);
%     ratheta(:,i) = tempat(:,i)./tempat(:,4);
% end
% for i = 7:9
%     ralpha(:,i) = tempa(:,i)./tempa(:,7);
%     rhalpha(:,i) = temph(:,i)./temph(:,7);
%     rbeta(:,i) = tempb(:,i)./tempb(:,7);
%     rtheta(:,i) = tempt(:,i)./tempt(:,7);
%     ratheta(:,i) = tempat(:,i)./tempat(:,7);
% end

% %remove missing subjects
% col = ralpha(:,1);
% q = find(isnan(col));
% ralpha(q,:) = [];
% rhalpha(q,:) = [];
% rbeta(q,:) = [];
% rtheta(q,:) = [];
% ratheta(q,:) = [];
% q = [];
% 
% col = ralpha(:,1);
% q = find(col == 0);
% ralpha(q,:) = NaN;
% rhalpha(q,:) = NaN;
% rbeta(q,:) = NaN;
% rtheta(q,:) = NaN;
% ratheta(q,:) = NaN;
% q = [];

%%WHITE
[num, txt, data] = xlsread('C:\LRC\2012_FALL\EEG_ONR_DAY\HAMNER\alldata_lookup_table.xlsx');

sub = num(:,1);

condition = char(txt(:,3));
condition(1,:) = [];

trial = num(:,2);

sub = num(:,1);
period = num(:,2);
color = char(txt(:,3));
trial = num(:,4);
session = num(:,5);
path = char(txt(:,6));

color(1,:) = [];
path(1,:) = [];

%remove non-darks
mark = zeros(length(sub), 1);
for s = 1:length(sub)
%     if(~strcmp(color(s,1), 'd') || (trial(s) ~= 1))
    if(~strcmp(color(s, 1), 'w'))%  || (sub(s) == 56))
        mark(s) = 1;
        color(s,1)
        trial(s)
    end
end

q = find(mark == 1);
condition(q,:) = [];
sub(q) = [];
trial(q) = [];
color(q,:) = [];
period(q,:) = [];
q = [];

%pull in and average power spectra
for s = 1:length(sub)
    loadfile = ['C:\LRC\2012_FALL\EEG_ONR_DAY\HAMNER\Excel Power Spectra\Subject ', num2str(sub(s)), '_Period ', num2str(period(s)), '_Color ', color(s), '_Trial ', num2str(trial(s)), '_processed.xls']
    [num, txt, raw] = xlsread(loadfile);
    
%     %eliminate NAN's
%     col = num(1,:);
%     q = find(isnan(col));
%     num(:,q) = [];

    marks = zeros(150, 1);
    for i = 1:560
        row = num(i,:);
        q = find(isnan(row));
        marks(q) = marks(q) + 1;
        q = [];
    end
    q = find(marks > 0);
    num(:,q) = [];
    
    %pull out frequency column
    freq = num(:,1);
    num(:,1) = [];
    
    %ps is the average power spectrum for each channel
    ps = mean(num, 2);
    
    %alpha is 8 - 12 Hz on Pz and Oz
    walpha(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = mean([ps(335:343);ps(415:423)]);
    
    %high alpha is 10.5 - 11 Hz on Pz and Oz
    whalpha(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = mean([ps(340:341);ps(420:421)]);
    
    %beta is 13 - 30 Hz on Fz and Cz
    wbeta(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = mean([ps(185:219);ps(265:299)]);
    
    %theta is 5 - 7 Hz on Fz and Cz
    wtheta(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = mean([ps(169:173);ps(249:253)]);
    
    %alpha-theta is 5 - 9 Hz on all channels
    watheta(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = mean([ps(169:177);ps(249:257);ps(329:337);ps(409:417)]);
    
end

%normalize to 1 for trial 1
tempa = walpha;
temph = whalpha;
tempb = wbeta;
tempt = wtheta;
tempat = watheta;
% for i = 1:9
%     walpha(:,i) = tempa(:,i)./tempa(:,1);
%     whalpha(:,i) = temph(:,i)./temph(:,1);
%     wbeta(:,i) = tempb(:,i)./tempb(:,1);
%     wtheta(:,i) = tempt(:,i)./tempt(:,1);
%     watheta(:,i) = tempat(:,i)./tempat(:,1);
% end
% for i = 4:6
%     walpha(:,i) = tempa(:,i)./tempa(:,4);
%     whalpha(:,i) = temph(:,i)./temph(:,4);
%     wbeta(:,i) = tempb(:,i)./tempb(:,4);
%     wtheta(:,i) = tempt(:,i)./tempt(:,4);
%     watheta(:,i) = tempat(:,i)./tempat(:,4);
% end
% for i = 7:9
%     walpha(:,i) = tempa(:,i)./tempa(:,7);
%     whalpha(:,i) = temph(:,i)./temph(:,7);
%     wbeta(:,i) = tempb(:,i)./tempb(:,7);
%     wtheta(:,i) = tempt(:,i)./tempt(:,7);
%     watheta(:,i) = tempat(:,i)./tempat(:,7);
% end
% 
% %remove missing subjects
% col = walpha(:,1);
% q = find(isnan(col));
% walpha(q,:) = [];
% whalpha(q,:) = [];
% wbeta(q,:) = [];
% wtheta(q,:) = [];
% watheta(q,:) = [];
% q = [];
% 
% col = walpha(:,1);
% q = find(col == 0);
% walpha(q,:) = NaN;
% whalpha(q,:) = NaN;
% wbeta(q,:) = NaN;
% wtheta(q,:) = NaN;
% watheta(q,:) = NaN;
% q = [];

% %remove subject 56's white readings
% walpha(7,:) = NaN*zeros(9, 1);
% whalpha(7,:) = NaN*zeros(9, 1);
% wbeta(7,:) = NaN*zeros(9, 1);
% wtheta(7,:) = NaN*zeros(9, 1);
% watheta(7,:) = NaN*zeros(9, 1);

%plot
figure(1)
plot(1:9, nanmean(dalpha), 'k')
hold on
plot(1:9, nanmean(ralpha), 'r')
plot(1:9, nanmean(walpha), 'b')
ylabel('\fontsize{16}Relative Power')
xlabel('\fontsize{16}Period #')
legend('Dark', 'Red', 'White', 'location', 'northwest')
set(gca, 'fontsize', 16)
title('\fontsize{16}Alpha-LRC')

figure(2)
plot(1:9, nanmean(dbeta), 'k')
hold on
plot(1:9, nanmean(rbeta), 'r')
plot(1:9, nanmean(wbeta), 'b')
ylabel('\fontsize{16}Relative Power')
xlabel('\fontsize{16}Period #')
legend('Dark', 'Red', 'White', 'location', 'northwest')
set(gca, 'fontsize', 16)
title('\fontsize{16}Beta-LRC')

figure(3)
plot(1:9, nanmean(dtheta), 'k')
hold on
plot(1:9, nanmean(rtheta), 'r')
plot(1:9, nanmean(wtheta), 'b')
ylabel('\fontsize{16}Relative Power')
xlabel('\fontsize{16}Period #')
legend('Dark', 'Red', 'White', 'location', 'northwest')
set(gca, 'fontsize', 16)
title('\fontsize{16}Theta-LRC')

figure(4)
plot(1:9, nanmean(datheta), 'k')
hold on
plot(1:9, nanmean(ratheta), 'r')
plot(1:9, nanmean(watheta), 'b')
ylabel('\fontsize{16}Relative Power')
xlabel('\fontsize{16}Period #')
legend('Dark', 'Red', 'White', 'location', 'northwest')
set(gca, 'fontsize', 16)
title('\fontsize{16}AlphaTheta-LRC')

%%spit out final values for Mariana
%alpha
%fill data
data = {'Subject', 'WT1', 'WT2', 'WT3', 'WT4', 'WT5', 'WT6', 'WT7', 'WT8', 'WT9', 'RT1', 'RT2', 'RT3', 'RT4', 'RT5', 'RT6', 'RT7', 'RT8', 'RT9', 'DT1', 'DT2', 'DT3', 'DT4', 'DT5', 'DT6', 'DT7', 'DT8', 'DT9'};
for i = 9:9:length(sub)
    dsub(i/9) = sub(i);
    
    data(i/9 + 1,:) = {dsub(i/9) walpha(i/9, 1) walpha(i/9, 2) walpha(i/9, 3) walpha(i/9, 4) walpha(i/9, 5) walpha(i/9, 6) walpha(i/9, 7) walpha(i/9, 8) walpha(i/9, 9) ralpha(i/9, 1) ralpha(i/9, 2) ralpha(i/9, 3) ralpha(i/9, 4) ralpha(i/9, 5) ralpha(i/9, 6) ralpha(i/9, 7) ralpha(i/9, 8) ralpha(i/9, 9) dalpha(i/9, 1) dalpha(i/9, 2) dalpha(i/9, 3) dalpha(i/9, 4) dalpha(i/9, 5) dalpha(i/9, 6) dalpha(i/9, 7) dalpha(i/9, 8) dalpha(i/9, 9)};
end
xlswrite('LRCSummary_Raw.xls', data, 'alpha');

%high alpha
%fill data
data = {'Subject', 'WT1', 'WT2', 'WT3', 'WT4', 'WT5', 'WT6', 'WT7', 'WT8', 'WT9', 'RT1', 'RT2', 'RT3', 'RT4', 'RT5', 'RT6', 'RT7', 'RT8', 'RT9', 'DT1', 'DT2', 'DT3', 'DT4', 'DT5', 'DT6', 'DT7', 'DT8', 'DT9'};
for i = 9:9:length(sub)
    dsub(i/9) = sub(i);
    
    data(i/9 + 1,:) = {dsub(i/9) whalpha(i/9, 1) whalpha(i/9, 2) whalpha(i/9, 3) whalpha(i/9, 4) whalpha(i/9, 5) whalpha(i/9, 6) whalpha(i/9, 7) whalpha(i/9, 8) whalpha(i/9, 9) rhalpha(i/9, 1) rhalpha(i/9, 2) rhalpha(i/9, 3) rhalpha(i/9, 4) rhalpha(i/9, 5) rhalpha(i/9, 6) rhalpha(i/9, 7) rhalpha(i/9, 8) rhalpha(i/9, 9) dhalpha(i/9, 1) dhalpha(i/9, 2) dhalpha(i/9, 3) dhalpha(i/9, 4) dhalpha(i/9, 5) dhalpha(i/9, 6) dhalpha(i/9, 7) dhalpha(i/9, 8) dhalpha(i/9, 9)};
end
xlswrite('LRCSummary_Raw.xls', data, 'halpha');

%beta
%fill data
data = {'Subject', 'WT1', 'WT2', 'WT3', 'WT4', 'WT5', 'WT6', 'WT7', 'WT8', 'WT9', 'RT1', 'RT2', 'RT3', 'RT4', 'RT5', 'RT6', 'RT7', 'RT8', 'RT9', 'DT1', 'DT2', 'DT3', 'DT4', 'DT5', 'DT6', 'DT7', 'DT8', 'DT9'};
for i = 9:9:length(sub)
    dsub(i/9) = sub(i);
    
    data(i/9 + 1,:) = {dsub(i/9) wbeta(i/9, 1) wbeta(i/9, 2) wbeta(i/9, 3) wbeta(i/9, 4) wbeta(i/9, 5) wbeta(i/9, 6) wbeta(i/9, 7) wbeta(i/9, 8) wbeta(i/9, 9) rbeta(i/9, 1) rbeta(i/9, 2) rbeta(i/9, 3) rbeta(i/9, 4) rbeta(i/9, 5) rbeta(i/9, 6) rbeta(i/9, 7) rbeta(i/9, 8) rbeta(i/9, 9) dbeta(i/9, 1) dbeta(i/9, 2) dbeta(i/9, 3) dbeta(i/9, 4) dbeta(i/9, 5) dbeta(i/9, 6) dbeta(i/9, 7) dbeta(i/9, 8) dbeta(i/9, 9)};
end
xlswrite('LRCSummary_Raw.xls', data, 'beta');

%theta
%fill data
data = {'Subject', 'WT1', 'WT2', 'WT3', 'WT4', 'WT5', 'WT6', 'WT7', 'WT8', 'WT9', 'RT1', 'RT2', 'RT3', 'RT4', 'RT5', 'RT6', 'RT7', 'RT8', 'RT9', 'DT1', 'DT2', 'DT3', 'DT4', 'DT5', 'DT6', 'DT7', 'DT8', 'DT9'};
for i = 9:9:length(sub)
    dsub(i/9) = sub(i);
    
    data(i/9 + 1,:) = {dsub(i/9) wtheta(i/9, 1) wtheta(i/9, 2) wtheta(i/9, 3) wtheta(i/9, 4) wtheta(i/9, 5) wtheta(i/9, 6) wtheta(i/9, 7) wtheta(i/9, 8) wtheta(i/9, 9) rtheta(i/9, 1) rtheta(i/9, 2) rtheta(i/9, 3) rtheta(i/9, 4) rtheta(i/9, 5) rtheta(i/9, 6) rtheta(i/9, 7) rtheta(i/9, 8) rtheta(i/9, 9) dtheta(i/9, 1) dtheta(i/9, 2) dtheta(i/9, 3) dtheta(i/9, 4) dtheta(i/9, 5) dtheta(i/9, 6) dtheta(i/9, 7) dtheta(i/9, 8) dtheta(i/9, 9)};
end
xlswrite('LRCSummary_Raw.xls', data, 'theta');

%alpha theta
%fill data
data = {'Subject', 'WT1', 'WT2', 'WT3', 'WT4', 'WT5', 'WT6', 'WT7', 'WT8', 'WT9', 'RT1', 'RT2', 'RT3', 'RT4', 'RT5', 'RT6', 'RT7', 'RT8', 'RT9', 'DT1', 'DT2', 'DT3', 'DT4', 'DT5', 'DT6', 'DT7', 'DT8', 'DT9'};
for i = 9:9:length(sub)
    dsub(i/9) = sub(i);
    
    data(i/9 + 1,:) = {dsub(i/9) watheta(i/9, 1) watheta(i/9, 2) watheta(i/9, 3) watheta(i/9, 4) watheta(i/9, 5) watheta(i/9, 6) watheta(i/9, 7) watheta(i/9, 8) watheta(i/9, 9) ratheta(i/9, 1) ratheta(i/9, 2) ratheta(i/9, 3) ratheta(i/9, 4) ratheta(i/9, 5) ratheta(i/9, 6) ratheta(i/9, 7) ratheta(i/9, 8) ratheta(i/9, 9) datheta(i/9, 1) datheta(i/9, 2) datheta(i/9, 3) datheta(i/9, 4) datheta(i/9, 5) datheta(i/9, 6) datheta(i/9, 7) datheta(i/9, 8) datheta(i/9, 9)};
end
xlswrite('LRCSummary_Raw.xls', data, 'atheta');

deleteEmptyExcelSheets('C:\LRC\2012_FALL\EEG_ONR_DAY\HAMNER\matlab\LRCSummary_Raw.xls');

