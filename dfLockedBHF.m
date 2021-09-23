function [dFlockedBHF,loFlockedBHF,dF] = dfLockedBHF(ptSzID,data,Fs,dFname)
% DFLOCKEDBHF calculates phase-locked broadband high frequency LFP
%   modified from the PLHG measures in Weiss et al. (2013,2015) published
%   in the journals Brain and Neurology, respectively. This method is more
%   precise, not relying on pre-defined frequency bands or integrating over
%   large windows. This method uses wavelets instead of multi-taper
%   analysis, which improves the temporal resolution of the measure.
%
%   The FIRST input is a seizure or data identifying string (e.g. pt4-1).  
% 
%   The SECOND input is matrix of electrophysiological recordings.
%   The format for the input matrix is [channels X samples].
%
%   The THIRD input is the sampling rate in Hz
%
%   if you want to save dominant frequecny data, put a .mat file name as
%   the FOURTH input. See dominantFrequecny.m for more info.
%
%   outputs are: 
%       1. dominant frequency-locked broadbnand high frequecny LFP
%       [channels X samples]
%       2. low frequency-locked broadbnand high frequecny LFP
%       [channels X samples]
%       3. The output structure from dominantFrequency.m
% 

% dependencies:
%   dominantFrequency.m
%   basewave4.m


% for PLHG start with the dominant frequency analysis
if nargin==3
    dF = dominantFrequency(ptSzID,data,Fs,[],false);
else
    if ~exist(dFname,'file')
        dF = dominantFrequency(ptSzID,data,Fs,[],false);
        save(dFname,'dF','-v7.3')
    elseif exist(dFname,'file')
        fprintf('\ndominant frequency data has already been calculated for this patient and seizure. Loading that...')
        load(dFname,'dF')
    end
end

% dominant frequecncy indexing (domfreqs for all channels by time
% TODO:: fix these loops. 
for cc = 1:size(data,1)
		for ss = size(data,2)
			phiDF(cc,ss) = squeeze(dF.PHIft(cc,dF.dominantFreqTiltIdx(cc,ss),ss));
	end
end


% low frequency phase as a backup
phiLo = squeeze(nanmean(dF.PHIft(:,dF.fHz>5 & dF.fHz<15,:),2));

% which signal to phase lock
phiBHF = squeeze(nanmean(dF.PHIft(:,dF.fHz>70 & dF.fHz<200,:),2));
BHF = squeeze(nanmean(dF.Sft(:,dF.fHz>70 & dF.fHz<200,:),2));


% then calculating the variables of interest. 
dFlockedBHF = abs(BHF.*(phiDF-phiBHF));
loFlockedBHF = abs(BHF.*(phiLo-phiBHF));

end
