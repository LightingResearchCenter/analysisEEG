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

%load in peak alpha location from file
[num, txt, raw] = xlsread('C:\LRC\2012_FALL\EEG_ONR_NIGHT\peak_alpha_locations.xlsx', 'Overall Median');
meds = num(:,2);

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

q = find((sub == 72) | (sub == 75) | (sub == 77));
sub(q) = [];
period(q) = [];
color(q,:) = [];
trial(q) = [];
session(q) = [];
path(q,:) = [];
condition(q,:) = [];

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
    
    apeak = meds(sub(s) - 65);
    tlow = 412 + apeak - 11;
    thigh =412 + apeak - 5;
    alow = 412 + apeak - 5;
    ahigh = 412 + apeak + 5;
    apeak = 412 + apeak;
    
    dalpha(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = mean([ps(alow - 240:ahigh - 240);ps(alow - 160:ahigh - 160);ps(alow - 80:ahigh - 80);ps(alow:ahigh)]);
    dtheta(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = mean([ps(tlow - 240:thigh - 240);ps(tlow - 160:thigh - 160);ps(tlow - 80:thigh - 80);ps(tlow:thigh)]);
    datheta(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = mean([ps(tlow - 240:ahigh - 240);ps(tlow - 160:ahigh - 160);ps(tlow - 80:ahigh - 80);ps(tlow:ahigh)]);  
    dhalpha(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = mean([ps(apeak - 240:ahigh - 240);ps(apeak - 160:ahigh - 160);ps(apeak - 80:ahigh - 80);ps(apeak:ahigh)]);
    dlalpha(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = mean([ps(alow - 240:apeak - 240);ps(alow - 160:apeak - 160);ps(alow - 80:apeak - 80);ps(alow:apeak)]);
end

%normalize to 1 for trial 1
tempa = dalpha;
tempt = dtheta;
tempat = datheta;
tempha = dhalpha;
templa = dlalpha;
for i = 1:3
    dalpha(:,i) = tempa(:,i)./tempa(:,1);
    dtheta(:,i) = tempt(:,i)./tempt(:,1);
    datheta(:,i) = tempat(:,i)./tempat(:,1);
    dhalpha(:,i) = tempha(:,i)./tempha(:,1);
    dlalpha(:,i) = templa(:,i)./templa(:,1);
end
for i = 4:6
    dalpha(:,i) = tempa(:,i)./tempa(:,4);
    dtheta(:,i) = tempt(:,i)./tempt(:,4);
    datheta(:,i) = tempat(:,i)./tempat(:,4);
    dhalpha(:,i) = tempha(:,i)./tempha(:,4);
    dlalpha(:,i) = templa(:,i)./templa(:,4);
end
for i = 7:9
    dalpha(:,i) = tempa(:,i)./tempa(:,7);
    dtheta(:,i) = tempt(:,i)./tempt(:,7);
    datheta(:,i) = tempat(:,i)./tempat(:,7);
    dhalpha(:,i) = tempha(:,i)./tempha(:,7);
    dlalpha(:,i) = templa(:,i)./templa(:,7);
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

q = find((sub == 72) | (sub == 75) | (sub == 77));
sub(q) = [];
period(q) = [];
color(q,:) = [];
trial(q) = [];
session(q) = [];
path(q,:) = [];
condition(q,:) = [];

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
    
    apeak = meds(sub(s) - 65);
    tlow = 412 + apeak - 11;
    thigh =412 + apeak - 5;
    alow = 412 + apeak - 5;
    ahigh = 412 + apeak + 5;
    apeak = 412 + apeak;
    
    ralpha(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = mean([ps(alow - 240:ahigh - 240);ps(alow - 160:ahigh - 160);ps(alow - 80:ahigh - 80);ps(alow:ahigh)]);
    rtheta(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = mean([ps(tlow - 240:thigh - 240);ps(tlow - 160:thigh - 160);ps(tlow - 80:thigh - 80);ps(tlow:thigh)]);
    ratheta(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = mean([ps(tlow - 240:ahigh - 240);ps(tlow - 160:ahigh - 160);ps(tlow - 80:ahigh - 80);ps(tlow:ahigh)]);  
    rhalpha(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = mean([ps(apeak - 240:ahigh - 240);ps(apeak - 160:ahigh - 160);ps(apeak - 80:ahigh - 80);ps(apeak:ahigh)]);
    rlalpha(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = mean([ps(alow - 240:apeak - 240);ps(alow - 160:apeak - 160);ps(alow - 80:apeak - 80);ps(alow:apeak)]);
end

%normalize to 1 for trial 1
tempa = ralpha;
tempt = rtheta;
tempat = ratheta;
tempha = rhalpha;
templa = rlalpha;
for i = 1:3
    ralpha(:,i) = tempa(:,i)./tempa(:,1);
    rtheta(:,i) = tempt(:,i)./tempt(:,1);
    ratheta(:,i) = tempat(:,i)./tempat(:,1);
    rhalpha(:,i) = tempha(:,i)./tempha(:,1);
    rlalpha(:,i) = templa(:,i)./templa(:,1);
end
for i = 4:6
    ralpha(:,i) = tempa(:,i)./tempa(:,4);
    rtheta(:,i) = tempt(:,i)./tempt(:,4);
    ratheta(:,i) = tempat(:,i)./tempat(:,4);
    rhalpha(:,i) = tempha(:,i)./tempha(:,4);
    rlalpha(:,i) = templa(:,i)./templa(:,4);
end
for i = 7:9
    ralpha(:,i) = tempa(:,i)./tempa(:,7);
    rtheta(:,i) = tempt(:,i)./tempt(:,7);
    ratheta(:,i) = tempat(:,i)./tempat(:,7);
    rhalpha(:,i) = tempha(:,i)./tempha(:,7);
    rlalpha(:,i) = templa(:,i)./templa(:,7);
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

q = find((sub == 72) | (sub == 75) | (sub == 77));
sub(q) = [];
period(q) = [];
color(q,:) = [];
trial(q) = [];
session(q) = [];
path(q,:) = [];
condition(q,:) = [];

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
    
    apeak = meds(sub(s) - 65);
    tlow = 412 + apeak - 11;
    thigh =412 + apeak - 5;
    alow = 412 + apeak - 5;
    ahigh = 412 + apeak + 5;
    apeak = 412 + apeak;
    
    walpha(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = mean([ps(alow - 240:ahigh - 240);ps(alow - 160:ahigh - 160);ps(alow - 80:ahigh - 80);ps(alow:ahigh)]);
    wtheta(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = mean([ps(tlow - 240:thigh - 240);ps(tlow - 160:thigh - 160);ps(tlow - 80:thigh - 80);ps(tlow:thigh)]);
    watheta(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = mean([ps(tlow - 240:ahigh - 240);ps(tlow - 160:ahigh - 160);ps(tlow - 80:ahigh - 80);ps(tlow:ahigh)]);
    whalpha(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = mean([ps(apeak - 240:ahigh - 240);ps(apeak - 160:ahigh - 160);ps(apeak - 80:ahigh - 80);ps(apeak:ahigh)]);
    wlalpha(sub(s) - 65, period(s) + 3*(trial(s) - 1)) = mean([ps(alow - 240:apeak - 240);ps(alow - 160:apeak - 160);ps(alow - 80:apeak - 80);ps(alow:apeak)]);
end

%normalize to 1 for trial 1
tempa = walpha;
tempt = wtheta;
tempat = watheta;
tempha = whalpha;
templa = wlalpha;
for i = 1:3
    walpha(:,i) = tempa(:,i)./tempa(:,1);
    wtheta(:,i) = tempt(:,i)./tempt(:,1);
    watheta(:,i) = tempat(:,i)./tempat(:,1);
    whalpha(:,i) = tempha(:,i)./tempha(:,1);
    wlalpha(:,i) = templa(:,i)./templa(:,1);
end
for i = 4:6
    walpha(:,i) = tempa(:,i)./tempa(:,4);
    wtheta(:,i) = tempt(:,i)./tempt(:,4);
    watheta(:,i) = tempat(:,i)./tempat(:,4);
    whalpha(:,i) = tempha(:,i)./tempha(:,4);
    wlalpha(:,i) = templa(:,i)./templa(:,4);
end
for i = 7:9
    walpha(:,i) = tempa(:,i)./tempa(:,7);
    wtheta(:,i) = tempt(:,i)./tempt(:,7);
    watheta(:,i) = tempat(:,i)./tempat(:,7);
    whalpha(:,i) = tempha(:,i)./tempha(:,7);
    wlalpha(:,i) = templa(:,i)./templa(:,7);
end

%remove subject 56's white readings
walpha(7,:) = NaN*zeros(9, 1);
whalpha(7,:) = NaN*zeros(9, 1);
wlalpha(7,:) = NaN*zeros(9, 1);
wtheta(7,:) = NaN*zeros(9, 1);
watheta(7,:) = NaN*zeros(9, 1);

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
title('\fontsize{16}Alpha-peakalpha')

figure(3)
plot(1:9, nanmean(dtheta), 'k')
hold on
plot(1:9, nanmean(rtheta), 'r')
plot(1:9, nanmean(wtheta), 'b')
ylabel('\fontsize{16}Relative Power')
xlabel('\fontsize{16}Period #')
legend('Dark', 'Red', 'White', 'location', 'northwest')
set(gca, 'fontsize', 16)
title('\fontsize{16}Theta-peakalpha')

figure(4)
plot(1:9, nanmean(datheta), 'k')
hold on
plot(1:9, nanmean(ratheta), 'r')
plot(1:9, nanmean(watheta), 'b')
ylabel('\fontsize{16}Relative Power')
xlabel('\fontsize{16}Period #')
legend('Dark', 'Red', 'White', 'location', 'northwest')
set(gca, 'fontsize', 16)
title('\fontsize{16}AlphaTheta-peakalpha')

figure(5)
plot(1:9, nanmean(dhalpha), 'k')
hold on
plot(1:9, nanmean(rhalpha), 'r')
plot(1:9, nanmean(whalpha), 'b')
ylabel('\fontsize{16}Relative Power')
xlabel('\fontsize{16}Period #')
legend('Dark', 'Red', 'White', 'location', 'northwest')
set(gca, 'fontsize', 16)
title('\fontsize{16}HighAlpha-peakalpha')

figure(6)
plot(1:9, nanmean(dlalpha), 'k')
hold on
plot(1:9, nanmean(rlalpha), 'r')
plot(1:9, nanmean(wlalpha), 'b')
ylabel('\fontsize{16}Relative Power')
xlabel('\fontsize{16}Period #')
legend('Dark', 'Red', 'White', 'location', 'northwest')
set(gca, 'fontsize', 16)
title('\fontsize{16}LowAlpha-peakalpha')


%%spit out final values for Mariana
%alpha
%fill data
data = {'Subject', 'WT1', 'WT2', 'WT3', 'WT4', 'WT5', 'WT6', 'WT7', 'WT8', 'WT9', 'RT1', 'RT2', 'RT3', 'RT4', 'RT5', 'RT6', 'RT7', 'RT8', 'RT9', 'DT1', 'DT2', 'DT3', 'DT4', 'DT5', 'DT6', 'DT7', 'DT8', 'DT9'};
for i = 9:9:length(sub)
    dsub(i/9) = sub(i);
    
    data(i/9 + 1,:) = {dsub(i/9) walpha(i/9, 1) walpha(i/9, 2) walpha(i/9, 3) walpha(i/9, 4) walpha(i/9, 5) walpha(i/9, 6) walpha(i/9, 7) walpha(i/9, 8) walpha(i/9, 9) ralpha(i/9, 1) ralpha(i/9, 2) ralpha(i/9, 3) ralpha(i/9, 4) ralpha(i/9, 5) ralpha(i/9, 6) ralpha(i/9, 7) ralpha(i/9, 8) ralpha(i/9, 9) dalpha(i/9, 1) dalpha(i/9, 2) dalpha(i/9, 3) dalpha(i/9, 4) dalpha(i/9, 5) dalpha(i/9, 6) dalpha(i/9, 7) dalpha(i/9, 8) dalpha(i/9, 9)};
end
xlswrite('peakalphaSummary_norm3.xls', data, 'alpha');

%highalpha
%fill data
data = {'Subject', 'WT1', 'WT2', 'WT3', 'WT4', 'WT5', 'WT6', 'WT7', 'WT8', 'WT9', 'RT1', 'RT2', 'RT3', 'RT4', 'RT5', 'RT6', 'RT7', 'RT8', 'RT9', 'DT1', 'DT2', 'DT3', 'DT4', 'DT5', 'DT6', 'DT7', 'DT8', 'DT9'};
for i = 9:9:length(sub)
    dsub(i/9) = sub(i);
    
    data(i/9 + 1,:) = {dsub(i/9) whalpha(i/9, 1) whalpha(i/9, 2) whalpha(i/9, 3) whalpha(i/9, 4) whalpha(i/9, 5) whalpha(i/9, 6) whalpha(i/9, 7) whalpha(i/9, 8) whalpha(i/9, 9) rhalpha(i/9, 1) rhalpha(i/9, 2) rhalpha(i/9, 3) rhalpha(i/9, 4) rhalpha(i/9, 5) rhalpha(i/9, 6) rhalpha(i/9, 7) rhalpha(i/9, 8) rhalpha(i/9, 9) dhalpha(i/9, 1) dhalpha(i/9, 2) dhalpha(i/9, 3) dhalpha(i/9, 4) dhalpha(i/9, 5) dhalpha(i/9, 6) dhalpha(i/9, 7) dhalpha(i/9, 8) dhalpha(i/9, 9)};
end
xlswrite('peakalphaSummary_norm3.xls', data, 'highalpha');

%lowalpha
%fill data
data = {'Subject', 'WT1', 'WT2', 'WT3', 'WT4', 'WT5', 'WT6', 'WT7', 'WT8', 'WT9', 'RT1', 'RT2', 'RT3', 'RT4', 'RT5', 'RT6', 'RT7', 'RT8', 'RT9', 'DT1', 'DT2', 'DT3', 'DT4', 'DT5', 'DT6', 'DT7', 'DT8', 'DT9'};
for i = 9:9:length(sub)
    dsub(i/9) = sub(i);
    
    data(i/9 + 1,:) = {dsub(i/9) wlalpha(i/9, 1) wlalpha(i/9, 2) wlalpha(i/9, 3) wlalpha(i/9, 4) wlalpha(i/9, 5) wlalpha(i/9, 6) wlalpha(i/9, 7) wlalpha(i/9, 8) wlalpha(i/9, 9) rlalpha(i/9, 1) rlalpha(i/9, 2) rlalpha(i/9, 3) rlalpha(i/9, 4) rlalpha(i/9, 5) rlalpha(i/9, 6) rlalpha(i/9, 7) rlalpha(i/9, 8) rlalpha(i/9, 9) dlalpha(i/9, 1) dlalpha(i/9, 2) dlalpha(i/9, 3) dlalpha(i/9, 4) dlalpha(i/9, 5) dlalpha(i/9, 6) dlalpha(i/9, 7) dlalpha(i/9, 8) dlalpha(i/9, 9)};
end
xlswrite('peakalphaSummary_norm3.xls', data, 'lowalpha');

%theta
%fill data
data = {'Subject', 'WT1', 'WT2', 'WT3', 'WT4', 'WT5', 'WT6', 'WT7', 'WT8', 'WT9', 'RT1', 'RT2', 'RT3', 'RT4', 'RT5', 'RT6', 'RT7', 'RT8', 'RT9', 'DT1', 'DT2', 'DT3', 'DT4', 'DT5', 'DT6', 'DT7', 'DT8', 'DT9'};
for i = 9:9:length(sub)
    dsub(i/9) = sub(i);
    
    data(i/9 + 1,:) = {dsub(i/9) wtheta(i/9, 1) wtheta(i/9, 2) wtheta(i/9, 3) wtheta(i/9, 4) wtheta(i/9, 5) wtheta(i/9, 6) wtheta(i/9, 7) wtheta(i/9, 8) wtheta(i/9, 9) rtheta(i/9, 1) rtheta(i/9, 2) rtheta(i/9, 3) rtheta(i/9, 4) rtheta(i/9, 5) rtheta(i/9, 6) rtheta(i/9, 7) rtheta(i/9, 8) rtheta(i/9, 9) dtheta(i/9, 1) dtheta(i/9, 2) dtheta(i/9, 3) dtheta(i/9, 4) dtheta(i/9, 5) dtheta(i/9, 6) dtheta(i/9, 7) dtheta(i/9, 8) dtheta(i/9, 9)};
end
xlswrite('peakalphaSummary_norm3.xls', data, 'theta');

%alpha theta
%fill data
data = {'Subject', 'WT1', 'WT2', 'WT3', 'WT4', 'WT5', 'WT6', 'WT7', 'WT8', 'WT9', 'RT1', 'RT2', 'RT3', 'RT4', 'RT5', 'RT6', 'RT7', 'RT8', 'RT9', 'DT1', 'DT2', 'DT3', 'DT4', 'DT5', 'DT6', 'DT7', 'DT8', 'DT9'};
for i = 9:9:length(sub)
    dsub(i/9) = sub(i);
    
    data(i/9 + 1,:) = {dsub(i/9) watheta(i/9, 1) watheta(i/9, 2) watheta(i/9, 3) watheta(i/9, 4) watheta(i/9, 5) watheta(i/9, 6) watheta(i/9, 7) watheta(i/9, 8) watheta(i/9, 9) ratheta(i/9, 1) ratheta(i/9, 2) ratheta(i/9, 3) ratheta(i/9, 4) ratheta(i/9, 5) ratheta(i/9, 6) ratheta(i/9, 7) ratheta(i/9, 8) ratheta(i/9, 9) datheta(i/9, 1) datheta(i/9, 2) datheta(i/9, 3) datheta(i/9, 4) datheta(i/9, 5) datheta(i/9, 6) datheta(i/9, 7) datheta(i/9, 8) datheta(i/9, 9)};
end
xlswrite('peakalphaSummary_norm3.xls', data, 'atheta');

deleteEmptyExcelSheets('\\root\public\hamner\ONR_EEG_NIGHT_JULY_2012\matlab\peakalphaSummary_norm3.xls');