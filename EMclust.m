function [classes] = EMclust(ROI, Priors, Mu, Sigma)
%%% given ROI, assign label to each instance

k = size(Mu, 2); % number of classes
n = size(ROI, 2);


prob = zeros(n, k); % class membership
for i = 1:k
    prob(:, i) = gaussPDF(ROI, Mu(:, i), Sigma(:, :, i));
end

weightedProb = prob.*repmat(Priors, n, 1);
weightedProb = weightedProb./repmat(sum(weightedProb, 2), 1, k);
[tmp idx] = max(weightedProb, [], 2);

classes = [ROI' idx];
