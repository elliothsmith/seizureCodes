function [denoisedData] = remove1stPC(data)
%REMOVE1STPC reconstructs data without the first PC.
%   Denoising with principal component analysis 
% 
% 

% author: Elliot H Smith - https://github.com/elliothsmith/seizureCodes

% PCA
[w,pc,ev] = pca(data);

% reconstruction without 1st component
denoisedData = (pc(:,2:end)*w(:,2:end)');

end

