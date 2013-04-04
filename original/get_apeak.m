clear all
close all
hold off
clc

[num, txt, data] = xlsread('C:\LRC\2012_FALL\EEG_ONR_NIGHT\alldata_lookup_table.xlsx');

sub = num(:,1);
period = num(:,2);
color = char(txt(:,3));
trial = num(:,4);
session = num(:,5);
path = char(txt(:,6));

color(1,:) = [];
path(1,:) = [];

for s = 1:length(sub)
    savename = ['C:\LRC\2012_FALL\EEG_ONR_NIGHT\Excel Power Spectra\Subject ', num2str(sub(s)), '_Period ', num2str(period(s)), '_Color ', color(s), '_Trial ', num2str(trial(s)), '_processed.xls']
    if(~exist(savename, 'file'))
        OkamotoPS_func_notrigger(path(s,:), savename, sub(s), period(s), trial(s), color(s));
        close all
        datestr(now)
    end
end

%%DARK
[num, txt, data] = xlsread('C:\LRC\2012_FALL\EEG_ONR_NIGHT\alldata_lookup_table.xlsx');

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
q = [];

%pull in and average power spectra
for s = 1:length(sub)
    loadfile = ['C:\LRC\2012_FALL\EEG_ONR_NIGHT\Excel Power Spectra\Subject ', num2str(sub(s)), '_Period ', num2str(period(s)), '_Color ', color(s), '_Trial ', num2str(trial(s)), '_processed.xls']
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
    
    adpeak(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = find(ps(413:425) == max(ps(413:425)));
end

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
[num, txt, data] = xlsread('C:\LRC\2012_FALL\EEG_ONR_NIGHT\alldata_lookup_table.xlsx');

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
    loadfile = ['C:\LRC\2012_FALL\EEG_ONR_NIGHT\Excel Power Spectra\Subject ', num2str(sub(s)), '_Period ', num2str(period(s)), '_Color ', color(s), '_Trial ', num2str(trial(s)), '_processed.xls']
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
    
    arpeak(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = find(ps(413:425) == max(ps(413:425)));
end

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
[num, txt, data] = xlsread('C:\LRC\2012_FALL\EEG_ONR_NIGHT\alldata_lookup_table.xlsx');

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
    loadfile = ['C:\LRC\2012_FALL\EEG_ONR_NIGHT\Excel Power Spectra\Subject ', num2str(sub(s)), '_Period ', num2str(period(s)), '_Color ', color(s), '_Trial ', num2str(trial(s)), '_processed.xls']
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
    
    awpeak(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = find(ps(413:425) == max(ps(413:425)));
end



