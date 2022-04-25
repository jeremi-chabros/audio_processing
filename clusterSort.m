function sortedSpikeMatrix = clusterSort(spikeMatrix)
%{
INPUT
spikeMatrix (2D matrix)
    matrix with dimensions (numUnits, numTimeBins)
%}

%% Calculate distance / similarity matrix
% Correlation

distMatrix = cov(spikeMatrix');
% distMatrix  = pca(spikeMatrix');
% [~,distMatrix] = svd(distMatrix');
distMatrix(isnan(distMatrix)) = 0;
% distMatrix = reshape(distMatrix, [sqrt(length(distMatrix)),sqrt(length(distMatrix))]);
% Dynamic time warping (TODO)

%% Cluster distance matrix

Z = linkage(distMatrix);
[~, ~, outperm] = dendrogram(Z, 0);


%% Sort rows based on distance
sortedSpikeMatrix = spikeMatrix(outperm, :);


end