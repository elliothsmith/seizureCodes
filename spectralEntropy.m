function [Hs,nBins] = spectralEntropy(X)
% SPECTRALENTROPY normalizes and calculates the entropy of a frequency spectrum
%
%   [dE] = spectralEntropy(signal) calculates the spectral entropy
%   of the spectrum in vector X. spectral entropy first normalizes the
%   spectrum by its extrema. 

nBins = length(X);

% normalizing spectrum
spectralDist = (X-min(X))./max(X);

% calculating entropy
Hs = -nansum(spectralDist.*log2(spectralDist));

