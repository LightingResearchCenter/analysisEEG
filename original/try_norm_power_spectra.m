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
    path(s,:)
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
    if((trial(s) == 3) && (period(s) == 3))
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
    ps = ps(321:399) + ps(401:479);
%     ps = log10(ps);
%     ps = ps(161:239) + ps(241:319) + ps(321:399) + ps(401:479);
%     ps = ps(161:239);
%     ps = ps/max(ps);
%     ps = (1/sum(ps))*ps;
    dark(:,sub(s) - 65) = ps;
    figure(sub(s))
    plot(1:.5:40, ps, 'k')
    hold on
    end
    
end

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
    if((trial(s) == 3) && (period(s) == 3))
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
    ps = ps(321:399) + ps(401:479);
%     ps = log10(ps);
%     ps = ps(161:239) + ps(241:319) + ps(321:399) + ps(401:479);
%     ps = ps(161:239);
%     ps = ps/max(ps);
%     ps = (1/sum(ps))*ps;
    red(:,sub(s) - 65) = ps;
    figure(sub(s))
    plot(1:.5:40, ps, 'r')
    hold on
    end
end

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
    if((trial(s) == 3) && (period(s) == 3))
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
    ps = ps(321:399) + ps(401:479);
%     ps = log10(ps);
%     ps = ps(161:239) + ps(241:319) + ps(321:399) + ps(401:479);
%     ps = ps(161:239);
%     ps = ps/max(ps);
%     ps = (1/sum(ps))*ps;
    white(:,sub(s) - 65) = ps;
    figure(sub(s))
    plot(1:.5:40, ps, 'b')
    hold on
    end
end

mark = zeros(16, 1);
for i = 1:16
    if((dark(1, i) == 0) || (red(1, i) == 0) || (white(1, i) == 0))
        mark(i) = 1;
    else
        mark(i) = 0;
    end
end
dark(:,find(mark == 1)) = [];
red(:,find(mark == 1)) = [];
white(:,find(mark == 1)) = [];

for i = 1:79
    [h, p] = ttest(dark(i,:), red(i,:), 0.05, 'both');
    pr(i) = p;
    [h, p] = ttest(dark(i,:), white(i,:), 0.05, 'both');
    pw(i) = p;
end
   
dark = mean(dark, 2);
dark = dark/max(dark);
red = mean(red, 2);
red = red/max(red);
white = mean(white, 2);
white = white/max(white);

figure(1)
plot(1:.5:40, dark, 'k')
hold on
plot(1:.5:40, red, 'r')
plot(1:.5:40, white, 'b')
ylabel('relative power')
xlabel('frequency (Hz)')
title('Initial Measurement')

freq = 1:.5:40;
freq(find(pr < 0.05))
freq(find(pw < 0.05))


