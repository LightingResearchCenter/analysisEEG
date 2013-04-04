clear all
close all
hold off
clc

%Dark
[num, txt, data] = xlsread('C:\LRC\2012_FALL\EEG_ONR_NIGHT\alldata_lookup_table.xlsx');

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
    if(~strcmp(color(s, 1), 'd'))
        mark(s) = 1;
        color(s,1)
        trial(s)
    end
end

q = find(mark == 1);
sub(q) = [];
trial(q) = [];
color(q,:) = [];
period(q,:) = [];
path(q,:) = [];
q = [];

for s = 1:length(sub)
    savename = ['C:\LRC\2012_FALL\EEG_ONR_NIGHT\HR figures\Subject ', num2str(sub(s)), ' - Trial ', num2str(trial(s)), ' - Period ', num2str(period(s)), ' - Color ', color(s), '.png']
    HRsavename = ['C:\LRC\2012_FALL\EEG_ONR_NIGHT\HR times\Subject ', num2str(sub(s)), ' - Trial ', num2str(trial(s)), ' - Period ', num2str(period(s)), ' - Color ', color(s), '.txt'];
    if(~exist(savename, 'file'))
        HRd(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = EEG_HR_diff27Jun2012(path(s,:), savename, sub(s), trial(s), period(s), color(s), HRsavename)
    end
    close all
end

%RED
[num, txt, data] = xlsread('C:\LRC\2012_FALL\EEG_ONR_NIGHT\alldata_lookup_table.xlsx');

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
    if((~strcmp(color(s, 1), 'r')) || ((sub(s) == 69) && (trial(s) == 3) && (period(s) == 2)))
        mark(s) = 1;
        color(s,1)
        trial(s)
    end
end

q = find(mark == 1);
sub(q) = [];
trial(q) = [];
color(q,:) = [];
period(q,:) = [];
path(q,:) = [];
q = [];

for s = 1:length(sub)
    savename = ['C:\LRC\2012_FALL\EEG_ONR_NIGHT\HR figures\Subject ', num2str(sub(s)), ' - Trial ', num2str(trial(s)), ' - Period ', num2str(period(s)), ' - Color ', color(s), '.png']
    HRsavename = ['C:\LRC\2012_FALL\EEG_ONR_NIGHT\HR times\Subject ', num2str(sub(s)), ' - Trial ', num2str(trial(s)), ' - Period ', num2str(period(s)), ' - Color ', color(s), '.txt'];
    path(s,:)
    if(~exist(savename, 'file'))
        HRr(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = EEG_HR_diff27Jun2012(path(s,:), savename, sub(s), trial(s), period(s), color(s), HRsavename)
    end
    close all
end

%WHITE
[num, txt, data] = xlsread('C:\LRC\2012_FALL\EEG_ONR_NIGHT\alldata_lookup_table.xlsx');

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
    if(~strcmp(color(s, 1), 'w'))
        mark(s) = 1;
        color(s,1)
        trial(s)
    end
end

q = find(mark == 1);
sub(q) = [];
trial(q) = [];
color(q,:) = [];
period(q,:) = [];
path(q,:) = [];
q = [];

for s = 1:length(sub)
    savename = ['C:\LRC\2012_FALL\EEG_ONR_NIGHT\HR figures\Subject ', num2str(sub(s)), ' - Trial ', num2str(trial(s)), ' - Period ', num2str(period(s)), ' - Color ', color(s), '.png']
    HRsavename = ['C:\LRC\2012_FALL\EEG_ONR_NIGHT\HR times\Subject ', num2str(sub(s)), ' - Trial ', num2str(trial(s)), ' - Period ', num2str(period(s)), ' - Color ', color(s), '.txt'];
    if(~exist(savename, 'file'))
        HRw(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = EEG_HR_diff27Jun2012(path(s,:), savename, sub(s), trial(s), period(s), color(s), HRsavename)
    end
    close all
end