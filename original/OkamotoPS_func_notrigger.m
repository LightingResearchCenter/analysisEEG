function OkamotoPS_func_notrigger(filename, savename, sub, period, trial, color)
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

EEG=zeros(data.channels-2,length(r));
for c=1:data.channels-2
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

EEGF=zeros(data.channels-2,length(r));
for fi=1:data.channels-2;   
     low=0.3; %[Hz]   
%      low=1; %[Hz]
     high=40; %[Hz]
     
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

if(((sub == 75) || (sub == 76)) && (trial == 2))
    El = 1.5; % length of EEG period [min]
else
    El = 2.5;
end
El

if(size(EEGF, 2) > 317441)
    EEGFT=EEGF(:,10241:10241+Fs*60*El-1);
else
    EEGFT=EEGF(:,1:1+Fs*60*El-1);
end

% EOG=r(7,I(1):I(1)+Fs*60*El-1);

t=0:length(EEGFT(1,:))-1;
T=t./Fs;
for z=1:length(EEGFT(:,1));
    figure()
    plot(T,EEGFT(z,:))
    axis([0,150,-100,100]);
    title(['Subject ', num2str(sub), ' _ Period ', num2str(period), ' _ Trial ', num2str(trial), ' _ Color ', num2str(color), ' - Channel ', num2str(z)])
    saveas(gcf, ['C:\LRC\2012_FALL\EEG_ONR_DAY\HAMNER\EEG figures\Subject ', num2str(sub), '_Period ', num2str(period), '_Color ', color, '_Trial ', num2str(trial), '_Channel ', num2str(z), '.png'])
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
wd=2; % data length[s]
rs=1; % running step[s]
pt=(length(EEGFT(1,:))-(wd*Fs))/(rs*Fs);
lr=wd*0.1; %10% cosine window
ramp=ones(1,Fs*wd);
tr=0:1/Fs:lr-1/Fs;
rsine=0.5*sin(2*pi*(1/(lr*2))*tr+(1.5*pi))+0.5;
ramp(1,1:length(rsine))=rsine(1:length(rsine));
ramp(1,length(ramp):-1:length(ramp)-length(rsine)+1)=ramp(1,1:length(rsine));

artth_ee=50;
artth_ey=40;

psdata=zeros(length(EEGFT(:,1)),wd*Fs,pt+2);
for f=1:length(EEGFT(:,1))
    for w=1:pt+1
        fd=EEGFT(f,rs*Fs*(w-1)+1:rs*Fs*(w-1)+(wd*Fs));
        fd=fd.*ramp;
        art_ee=find(fd>artth_ee | fd<-1*artth_ee);
        
        Fq=0:wd*Fs-1;
        ff=Fq*Fs./(wd*Fs);
        psdata(f,:,1)=ff';
        
        bd=EEGFT(7,rs*Fs*(w-1)+1:rs*Fs*(w-1)+(wd*Fs));
        art_ey=find(bd>artth_ey | bd<-1*artth_ey);
        
        if art_ee>=1
           psdata(f,:,w+1)=NaN;
        elseif art_ey>=1
           psdata(f,:,w+1)=NaN; 
        else
           ps=abs(fft(fd));
           ps=ps./(length(ps)/2);
           ps=ps.^2;
           psdata(f,:,w+1)=ps';
        end
    end
end
 
%%%%%%%%%%%%%%%%%%% put out result for excel %%%%%%%%%%%%%%%%%%%%
sl=1; %save data from 1Hz
sh=40; %save data to 100 Hz
slp=(sl/(1/wd))+1;
shp=(sh/(1/wd))+1;
sp=1;%space between ch(n) and ch(n+1)

xdata=zeros((shp-slp+1)*length(EEGFT(:,1))+length(EEGFT(:,1)),pt+2);
% xname=sprintf('%s_%3.2f_%02d_thee%02d_they%02d_PS.xls',filename,low,high,artth_ee,artth_ey);
for x=1:length(EEGFT(:,1))
% xdata=zeros(wd*Fs,pt+1);
xdata((shp-slp+1)*(x-1)+(sp*x):(shp-slp+1)*x+(sp*(x-1)),:)=psdata(x,slp:shp,:);
end
xlswrite(savename,xdata);

clear all;
end
