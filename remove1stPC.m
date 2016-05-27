function [denoisedData] = remove1stPC(data)
%REMOVE1STPC reconstructs data without the first PC.
%   Denoising with principal component analysis 

% PCA
[w,pc,ev] = pca(data);

% reconstruction
denoisedData = (pc(:,2:end)*w(:,2:end)');

end

