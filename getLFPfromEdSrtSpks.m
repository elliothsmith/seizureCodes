function [LFPmat,fileNames] = getLFPfromEdSrtSpks(dirName)
% GETLFPFROMEDSRTSPKS puts all of the LFP from Ed's sorted files in a matrix. 
% 	
% 	example input: '/data/selected_data/sortedAPsMEA_emerix/c5_ictal_matched_units/c5_s1' 
% 
%	This function will load all of the mat files in the above directory starting with 'c5_s1'
% 	and put the variable 'lfp' in a matrix from unique channels.
%
%	the output variable 'LFPmat' is a matrix of LFP from the unique files. 'fileNames' lists
%	those files from which 'LFPmat' was populated. 
%


% author: EHS20170707

% hard coding this for dev. 
% dirName = '/data/selected_data/sortedAPsMEA_emerix/c5_ictal_matched_units/c5_s1'

dirList = dir([dirName, '*.mat']);

% first finding unique channels. 
for fl = 1:length(dirList)
	% string channel number
	k = strfind(dirList(fl).name,'ch');
	
	% converting to channel
	chanNum(fl) = str2double(dirList(fl).name(k+2:k+3));
	if isnan(chanNum(fl))
		chanNum(fl) = str2double(dirList(fl).name(k+2));
	end
	% throw error message. 
	if isnan(chanNum(fl))
		display(['having issues finding channel number for: ' dirList(fl).name]) 
	end
	% saving filenames. 
	fileNames{fl} = dirList(fl).name;
end

% finding unique channels. 
[unitChans,chanIdx] = unique(chanNum);


% loading LFP into a matrix from unique channels. 
for ch = 1:length(chanIdx)
	slashes = strfind(dirName,'/');
	load(fullfile(dirName(1:slashes(end)),fileNames{chanIdx(ch)}),'lfp');
	LFPmat(ch,:) = lfp';
end



end
% So, took a while but new files are being uploaded now, in a directory called "c5_ictal_matched_units" in "/mnt/mfs/selected_data/sortedAPsMEA_emerix/". Each unit is a separate file which is pretty stupid but the result of the processing method. Might merge later. Anyway, each file has:

% details: just the usual details
% lfp: the unfiltered trace from that channel from time zero to +60 seconds, relative to all spike times in these files.
% unit: a structure of structures:
%     original: the original unit from proper spike sorting, with waveforms, times, and some metrics for reference.
%     matched: the waves and times from the ictal spikes that matched the original, plus metrics
%     possible: the waves and times that met the template matching criteria, but failed later tests, plus metrics.

% The metrics are line length, distance from centroid in principal component space, and correlation coefficient to the mean waveform from the original unit. In the "matched" and "possible" structures, it also includes line_length_probs and pc_space_probs, which are just the probability that that waveform corresponds to the original unit based on fitting a Gaussian distribution to the same metric in the original unit. This wasn't done for the correlation coefficient because it's non-Gaussian. All the raw metrics are in there too.

% Some of the template match results are a big mess, so I'm uploading another directory called figs within that one, showing the same figure as I shared previously for each unit on each channel. You can use that to easily discard the ones that clearly just matched garbage through the seizure, though I'm not 100% on what objective criteria you'd use for that, so maybe we can use the metrics to whittle down those messy channels to only the convincing waveforms. Nothing like a bit of subjective spike sorting...
 


