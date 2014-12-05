function [Priors, Mu, Sigma] = EM_Kmeanspp(Data, nbClusters)

% This function initializes the parameters of a Gaussian Mixture Model 
% (GMM) by using k-means++ clustering algorithm.
% Inputs -----------------------------------------------------------------
%   o Data:     D x N array representing N datapoints of D dimensions.
%   o nbClusters: Number K of GMM components.
% Outputs ----------------------------------------------------------------
%   o Priors:   1 x K array representing the prior probabilities of the
%               K GMM components.
%   o Mu:       D x K array representing the centers of the K GMM components.
%   o Sigma:    D x D x K array representing the covariance matrices of the 
%               K GMM components.

Data = Data';
[nbVar, nbData] = size(Data);
[Data_id, Centers] = kmeanspp(Data, nbClusters); 
Mu = Centers;

for i = 1:nbClusters
  idtmp = find(Data_id == i);
  Priors(i) = length(idtmp);
  Sigma(:, :, i) = cov([Data(:, idtmp) Data(:, idtmp)]');
  %Add a tiny variance to avoid numerical instability
  if isempty(idtmp)
      Sigma(:, :, i) = 1E-5.*diag(ones(nbVar,1));
  else
      Sigma(:, :, i) = Sigma(:, :, i) + 1E-5.*diag(ones(nbVar,1));
  end
end
Priors = Priors./sum(Priors);


