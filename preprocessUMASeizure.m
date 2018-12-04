function [MUAFile,microLFPFile] = preprocessUMASeizure(patientID, sz, fileName, filePath, Onset, Offset, preictalMins, postictalMins)
%PREPROCESSUMASEIZURE Processes seizures recorded on utah arrays (no clinical data).
%   preprocessSeizures(patientID, sz, fileName, path, Onset, Offset,
%   preictalTime, PostictalTime) will output a preprocessed chunk of data
%   from seizure number [sz](scalar) from patient [patientID](string) with
%   [preictalTime](scalar) minutes of data before the [Onset](scalar) time
%   in samples (2 kHz) and [postictalTime](scalar) minutes after the
%   [Offset](scalar) time in samples (2 kHz).
%
%   To save time, preprocessSeizure will ask you which preprocessed data
%   you would like to save. To avoid this step and process everything,
%   set inputFlag to 0;


% Author: Elliot H. Smith
% Version Date: 20160112Deb

% to Add:
%  - signalFlag functionality
%  - optional arguments for debugging MUA detection step
%  - spike sorting detected waveforms


%% some exceptions for UI
% fileName
if strcmp(fileName(end-4),'.')
    fileName = fileName(end-4);
end

% loading data
NS5 = openNSx([filePath fileName '.ns5']);
Fs = 3e4;

% building MUA filter
MUA_BAND = [300 3000];
[b,a] = fir1(250,MUA_BAND/(Fs/2));

% denoising full BW data by removing the first PC.
if Onset*15 - preictalMins*60*Fs <= 0
    dData = double(NS5.Data(:,1:Offset*15 + postictalMins*60*Fs));
elseif Offset*15 + postictalMins*60*Fs > size(NS5.Data,2)
    Q = input('offset time is longer than the file length. \n\nDo you want to dig into the next file to fill out the entire requested duration [1], \n\n     or clip[ at the end of this file [2]?  \n\nPlease choose 1 or 2:');
    if Q==1
        num = str2double(fileName(end-2:end))+1;
        if num<10
            fileName(end-2:end) = ['00' num2str(num)];
        elseif num>=10
            fileName(end-2:end) = ['0' num2str(num)];
        elseif num>=100
            fileName(end-2:end) = [num2str(num)];
        end
        tmp1 = double(NS5.Data(:,Onset*15 - preictalMins*60*Fs:size(NS5.Data,2)));
        
        NS5_2 = openNSx([filePath fileName '.ns5']);
        dData = cat(2,tmp1,double(NS5_2.Data(:,1:1 + postictalMins*60*Fs)));
    elseif Q==2
        dData = double(NS5.Data(:,Onset*15 - preictalMins*60*Fs:size(NS5.Data,2)));
    end
else
    dData = double(NS5.Data(:,Onset*15 - preictalMins*60*Fs:Offset*15 + postictalMins*60*Fs));
end
% dData = remove1stPC(tmp);
% clear tmp

% filtering for MUA
for ch = 1:size(dData,1)
    muamat(ch,:) = filtfilt(b,a,dData(ch,:));
    display(['filtering channel ' num2str(ch) ' of ' num2str(size(NS5.Data,1))])
end

% timescale
%         tsec = linspace(Onset*15 - preictalMins*60*Fs,(Offset*15 + postictalMins*60*Fs)./Fs,size(muamat,2));

% number of channels
numChans = size(muamat,1);

%% detect action potentials in the seizure files.
% [2015030: could make all of these optional args]
DEBUG = 0;
MUA_BAND = [500 3000];
DETECTION_THRESHOLD = 5;
ARTIFACT_THRESHOLD = 12;

% filtering MUA trace
Fs = 3e4;
[b,a] = fir1(90,MUA_BAND/(Fs/2));
WAVEFORM_RANGE = int32(floor(Fs*(-0.6)/1000)):int32(floor(Fs*1.0/1000));

samplewin = floor(0.0005*Fs);
avg_window = int16(60*Fs); % average threshold over this window

% initialize the data structure
mua_data.filter = MUA_BAND;
mua_data.artifact_rejection_threshold = ARTIFACT_THRESHOLD;
mua_data.detection_threshold = DETECTION_THRESHOLD;
mua_data.thresholds = [DETECTION_THRESHOLD ARTIFACT_THRESHOLD];
mua_data.start_time = Onset*15;
mua_data.duration = size(muamat,2)/Fs;
mua_data.nchannels = numChans;
mua_data.nspikes = zeros(numChans,1);
mua_data.fs = Fs;

% looping over channels.
for c=1:numChans
    fprintf('\nsaving timestamps for channel %d of %d.',c,numChans)
    % demeaning MUA
    mua = muamat(c,:) - mean(muamat(c,:));
    
    % calculate threshold based on interictal sample
    clear sig;
    sig = mua(1:avg_window);
    threshold = -DETECTION_THRESHOLD*std(sig);
    thresholds(c) = threshold;
    clear peaks;
    peaks = find_inflections (mua, 'minima');
    peaks = peaks(mua(peaks) < threshold);
    
    % remove peaks that are greater than 5*SD of waveform max amplitude
    % greater than this is typically artifact
    maxabs = abs(mua(peaks));
    artifact_threshold = ARTIFACT_THRESHOLD*std(maxabs);
    
    %clear over;
    %over = find(maxabs > artifact_threshold);
    peaks(find(maxabs > artifact_threshold)) = [];
    
    % now save the waveforms
    waveforms = [];
    for k = 1:length(peaks)
        range = peaks(k) + WAVEFORM_RANGE;
        if min(range) < 1 || max(range) > length(mua)
            % future:  for these, dip back into the original file
            % otherwise, waveform analysis code can just skip
            waveforms(k,:) = zeros(1, length(range));
        else
            waveforms(k,:) = mua(range);
        end
    end
    mua_data.waveforms{c} = waveforms;
    
    % saving timestamps
    mua_data.timestamps{c} = peaks./Fs;
    mua_data.nspikes(c) = length(peaks);
    
    % debug feature.
    if DEBUG && length(peaks) > 0
        clf reset;
        subplot(3,1,1); hold on;
        title (['Channel ' num2str(c)])'
        x1 = 1:length(mua); x1 = x1./Fs;
        plot(x1,mua);
        for s = 1:length(peaks)
            plot(x1(peaks(s)),threshold,'.r');
        end
        subplot(3,1,[2 3]); hold on;
        x2 = 1:49; x2 = x2./Fs; x2 = x2*1000;
        for s = 1:length(peaks)
            plot(x2,waveforms(s,:));
        end
        title (['Threshold = ' num2str(threshold)]);
        pause;
    end
    
end
mua_data.thresholds = thresholds;


% electrode labels
try
    trodeLabels = {NS5.ElectrodesInfo.Label};
catch
    trodeLabels = 'UMA data only';
end

fprintf('\nsaving MUA data. please wait...'); tic;
muaFlag = 'n';
%% saving MUA event times
if strcmp(muaFlag,'y') % could change the name here, but might break somethign downstream.
    MUAFile = [patientID '_MUAtimes-' num2str(sz) '.mat'];
    save(MUAFile,'mua_data','trodeLabels','-v7.3')
else
    MUAFile = [patientID '_MUAtimes-' num2str(sz) '.mat'];
    save(MUAFile,'mua_data','trodeLabels','-v7.3')
end
A = toc;
fprintf('\nsaving data took %.2f seconds',A)


%       if ~exist('dData','var')
%           % denoising full BW data by removing the first PC.
%           tmp = double(NS5.Data(:,Onset*15 - preictalMins*60*Fs:Offset*15 + postictalMins*60*Fs));
%           dData = remove1stPC(tmp);
%           clear tmp
%       end

%% downsample the seizure file and save to mat file with timestamps
Fs = 30000;
Fi = 2000;
display(['downasmpling LFP for seizure ' num2str(sz) ' from ' num2str(Fs) ' to ' num2str(Fi)])
DSFilter = fir1(256,Fi/(Fs/2));

% initializing matrix
seizure_downFiltered = zeros(size(dData));

% loooping over channels
for chs = 1:min(size(dData))
    display(['Low pass filtering Channel ' num2str(chs) ' of 96'])
    % noncausal fitlering
    seizure_downFiltered(chs,:) = filtfilt(DSFilter,1,double(dData(chs,:)));
end

% downsampling
seizure_downsampled = seizure_downFiltered(:,1:(Fs/Fi):end);
dsSeizure = seizure_downsampled;

%% [20150805] saving data from microwires.
microLFPFile = [patientID '_2Kdownsampled_seizure-' num2str(sz) '.mat'];
save(microLFPFile, 'dsSeizure', 'trodeLabels', '-v7.3')


