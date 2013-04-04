function HR = EEG_HR_diff27Jun2012(filename, savename, sub, trial, period, color, HRpath)
fid = fopen(filename,'r','l'); % open file for 'read' as 'little endian'

version                 = fread(fid,8,'char')';               % version of data format
identify                = char(version(2:8));
if strcmp(identify,'BIOSEMI') ~= 1
    fclose(fid);
    error('this is not a biosemi bdf file');
end

data.nSamples           = 0;
data.nTrials            = 0;
data.negTrialSize       = 0;
data.sampleRate         = 0;
data.channels           = 0;
data.n_filters          = 0;
data.filters            = [];
data.filtersAux         = 0;
data.subjectId          = char(fread(fid,80,'char')');              % patient ID
data.rundescription     = char(fread(fid,80,'char')');              % recording information
data.dataDate           = char(fread(fid,8,'char')');              % date of recording
data.dataTime           = char(fread(fid,8,'char')');              % start of recording
numberOfBytesInHeader   = fread(fid,8,'char');                      % number of bytes in header record
manufacturer            = fread(fid,44,'char');                                               % reserved
if strcmp(char(manufacturer(1:5)'),'24BIT') ~= 1
    fclose(fid);
    error('this is not a biosemi bdf file');
end

data.nTrials            = str2num(char(fread(fid,8,'char')'));      % number of data records (would be number of trials in CTF)
data.epochTime          = str2num(char(fread(fid,8,'char')'));      % duration of data record (in seconds)
data.channels           = str2num(char(fread(fid,4,'char')'));      % number of samples per trial (in seconds)
data.dataSize           = 3;


for cChannels = 1:data.channels
    chanName                                = char(fread(fid,16,'char')');
end
for cChannels = 1:data.channels
    data.sensor.TransducerType{cChannels}   = char(fread(fid,80,'char')');
end 
for cChannels = 1:data.channels
    data.sensor.dimension{cChannels}        = char(fread(fid,8,'char')');    
end  
for cChannels = 1:data.channels
    data.sensor.physMinimum(cChannels)      = str2num(char(fread(fid,8,'char')'));    
end       
for cChannels = 1:data.channels    
    data.sensor.physMaximum(cChannels)      = str2num(char(fread(fid,8,'char')'));    
end 
for cChannels = 1:data.channels    
    data.sensor.digitalMinimum(cChannels)   = str2num(char(fread(fid,8,'char')'));
end
for cChannels = 1:data.channels    
    data.sensor.digitalMaximum(cChannels)   = str2num(char(fread(fid,8,'char')'));    
end
for cChannels = 1:data.channels    
    data.sensor.gain(cChannels)             = (data.sensor.physMaximum(cChannels)  - data.sensor.physMinimum(cChannels)) ./ (data.sensor.digitalMaximum(cChannels) -  data.sensor.digitalMinimum(cChannels));
end
for cChannels = 1:data.channels    
    data.sensor.preFiltering{cChannels}     = char(fread(fid,80,'char')');
end
for cChannels = 1:data.channels    
    data.sensor.numberOfSamples(cChannels)  = str2num(char(fread(fid,8,'char')'));
    data.sensor.sampleRate(cChannels)       = data.epochTime \ data.sensor.numberOfSamples(cChannels);
end
fread(fid,32*data.channels,'char');

if (data.channels+1)*256 ~= ftell(fid)
    error('something went wrong');
end

if length(unique(data.sensor.sampleRate)) == 1
    data.sampleRate = data.sensor.sampleRate(1);
end
if length(unique(data.sensor.numberOfSamples)) == 1
    data.nSamples = data.sensor.numberOfSamples(1);
end

sizeHeader = 256 + 256 * data.channels;
fseek(fid,0,'eof');
endOfFile=ftell(fid);
if data.nTrials == -1
    data.nTrials = (endOfFile - sizeHeader) / (data.nSamples * data.channels * data.dataSize);
elseif data.nTrials ~= (endOfFile - sizeHeader) / (data.nSamples * data.channels * data.dataSize)
    error('invalid file format');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

r=zeros(data.channels+(24-1),data.nSamples*data.nTrials); %1st row -> sample number, 2-123th row -> MEG001-122ch, 124-125th row -> trig1, trig2
for i=1:data.nTrials;
    fseek(fid,256+256*(data.channels)+data.nSamples*3*data.channels*(i-1),-1);
        for j=1:data.channels-1;
            s=fread(fid,data.nSamples,'bit24');
            r(j,data.nSamples*(i-1)+1:data.nSamples*i)=s';
        end
                
        for t=1:data.nSamples
            s=fread(fid,24,'ubit1');
            r(data.channels:data.channels+24-1,data.nSamples*(i-1)+t)=s;
        end
end

for g=1:data.channels-1;
    r(g,:)=r(g,:).*data.sensor.gain(g);
end

fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Fs=data.sampleRate;

Ref=(r(1,:)+r(2,:))/2;

EEG=zeros(data.channels,length(r));
for c=1:data.channels
    EEG(c,:)=r(c,:)-Ref;
end

% n=0:length(EEG(1,:))-1;
% T=n./Fs;
% for fd=1:data.channels-2
%     ps=abs(fft(EEG(fd,:)));
%     ps=ps./(length(ps)/2);
%     ps=ps.^2;
%     F=0:length(ps)-1;
%     f=F*Fs./length(ps);
%     figure(fd)
%     plot(f,ps);
%     % plot(f,20*log10(psp));
%     xlabel('frequency [Hz]');
%     ylabel('amplitude');
%     axis([0,20,0,5])
%     hold on
% end

EEGF=zeros(data.channels,length(r));
for fi=1:data.channels;   
     low=.7; %[Hz]   
%      low=1; %[Hz]
     high=10; %[Hz]
     
     nyq=Fs/2;
     low2=low/nyq;
     high2=high/nyq;
     passband=[low2 high2];
    
%    [Bb Ab]=cheby1(3,0.01,passband);
     [Bb Ab]=butter(3,passband);
     EEG_1=filter(Bb,Ab,EEG(fi,:));
     EEG_2=filter(Bb,Ab,EEG_1);
%     EEG_1 = filtfilt(Bb, Ab, EEG(fi,:));
%     EEG_2 = filtfilt(Bb, Ab, EEG_1);
     EEGF(fi,:)=EEG_2;
end

Trig1=r(data.channels,:);

% I=find(Trig1>=1);
% figure()
% plot(I)
% I(1)=124698;
% I(1)=length(r)-Fs*60*2.5+1;

El=2.5; % length of EEG period [min]
if(((sub == 76) && (period == 3) && (trial == 2) && (color == 'd')) || ((sub == 75) && (period == 2) && (trial == 2) && (color == 'w')))
    El=1.5;
end
if((size(EEGF, 2) > 317441) || (((sub == 76) && (period == 3) && (trial == 2) && (color == 'd')) || ((sub == 75) && (period == 2) && (trial == 2) && (color == 'w'))))
    EEGFT=EEGF(:,10241:10241+Fs*60*El-1);
else
    EEGFT=EEGF(:,1:1+Fs*60*El-1);
end

%take derivatives to compare with data
FS = 2048;
t=0:length(EEGFT(1,:))-1;
T=t./Fs;

d1 = diff(EEGFT(8,:));
if((sub == 55) && (trial == 1) && (period == 3) && (color == 'r'))
    d1(1:20480) = 0;
end
d2 = diff(d1);
% d3 = d1/max(d1);
% d3(length(d3)) = [];
% d3 = d3 + d2/max(d2);
% d3 = d3/max(d3);


% figure(1)
% plot(T, EEGFT(8,:)/max(EEGFT(8,:)))

T(length(T)) = [];
screen_size = get(0, 'ScreenSize');
f1 = figure(1);
set(f1, 'Position', [0 0 screen_size(3) screen_size(4) ] );
plot(T, d1/max(abs(d1)));

T(length(T)) = [];
% figure(3)
% plot(T, d3/max(d3))

%if first derivative is greater than the threshold, mark the points
d1 = d1/max(abs(d1));
tmark = sort(d1);
if(((sub == 76) && (period == 3) && (trial == 2) && (color == 'd')) || ((sub == 75) && (period == 2) && (trial == 2) && (color == 'w')))
    thresh = .5;
else
    thresh = min([.5 tmark(301000)]);
end
if(sub == 73)
    thresh = .75;
end
if(sub == 67)
    thresh = .7;
end
if(sub == 69)
    thresh = .7;
end
if(sub == 76)
    thresh = .8;
end
if(sub == 79)
    thresh = .65;
end
if(sub == 81)
    thresh = .62;
end
if((sub == 67) && (color == 'r'))
    thresh = .35;
end
if((sub == 67) && (color == 'r') && (trial == 1) && (period == 1))
    thresh = .7;
end
if((sub == 67) && (color == 'r') && (trial == 1) && (period == 2))
    thresh = .3;
end
if((sub == 67) && (color == 'r') && (trial == 3) && (period == 2))
    thresh = .45;
end
if((sub == 71) && (color == 'r'))
    thresh = .7;
end
if(sub == 77)
    thresh = .8;
end
if((sub == 67) && (color == 'w') && (trial == 3))
    thresh = .45;
end
if((sub == 69) && (color == 'w'))
    thresh = .8;
end
if((sub == 71) && (color == 'w'))
    thresh = .7;
end

        
trigger = zeros(307200, 1);
if(((sub == 76) && (period == 3) && (trial == 2) && (color == 'd')) || ((sub == 75) && (period == 2) && (trial == 2) && (color == 'w')))
    trigger = zeros(184320, 1);
end
if((sub == 71) || (sub == 73) || (sub == 67) || (sub == 69) || (sub == 76) || (sub == 81) || (sub == 77))
    for i = 1:length(d1)
        if(d1(i) < -thresh)
            trigger(i) = -thresh;
        end
    end
else
    for i = 1:length(d1)
        if(d1(i) > thresh)
            trigger(i) = thresh;
        end
    end
end

%remove repeated marks for a beat
for i = 1:length(trigger) - 683
    if(sum(trigger(i + 1:i + 683)) ~= 0)
        trigger(i) = 0;
    end
end
for i = length(trigger):-1:684
    if(sum(trigger(i - 683:i - 1)) ~= 0)
        trigger(i) = 0;
    end
end
        

hold

FS = 2048;
t=0:length(EEGFT(1,:))-1;
T=t./Fs;

%plot identified beats
marks = T;
marks(find(trigger == 0)) = [];
trigger(find(trigger == 0)) = [];
scatter(marks, trigger, 'g');

axis([0 30 -1 1])
title(num2str(sub))

%save plot of first derivative and identified beats
saveas(gcf, savename);

%find time between beats
for i = 1:length(trigger) - 1
    differ(i) = marks(i + 1) - marks(i);
end

%mark beats that are more than 1.5 seconds apart
flag = zeros(length(differ), 1);
times = 0;
for i = 1:length(differ)
    if(differ(i) > 1.25)
        times = times + differ(i);
        flag(i) = .5;
    end
end

%remove marked beats
differ(find(flag > 0)) = [];

%HR is 60/time between beats multiplied by trial time/non-omitted trial
%time
correctedHR = (60/mean(differ))*(150/(150 - times));
HR = correctedHR
length(differ)
HR = 60*(length(differ)/(150 - times));

f = fopen(HRpath, 'w');
for i = 1:length(differ)
    fprintf(f, '%f\r\n', differ(i));
end
fclose(f);






    


