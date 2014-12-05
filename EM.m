function [Priors, Mu, Sigma, Pix, AIC, BIC, AICBIC] = EM(Data, Priors0, Mu0, Sigma0)
% Expectation-Maximization estimation of GMM parameters.
% Inputs -----------------------------------------------------------------
%   Data:    D x N array representing N datapoints of D dimensions.
%   Priors0: 1 x K array representing the initial prior probabilities 
%              of the K GMM components.
%   Mu0:     D x K array representing the initial centers of the K GMM 
%              components.
%   Sigma0:  D x D x K array representing the initial covariance matrices 
%              of the K GMM components.
% Outputs ----------------------------------------------------------------
%   Priors:  1 x K array representing the prior probabilities of the K GMM 
%              components.
%   Mu:      D x K array representing the centers of the K GMM components.
%   Sigma:   D x D x K array representing the covariance matrices of the 
%              K GMM components.
%   BIC, AIC: Bayesian/Akaike information criterion for model selection

%% Criterion to stop the EM iterative update
loglik_threshold = 1e-3;

%% Initialization of the parameters
maxIter = 500;
Data = Data'; % transpose data
[nbVar, nbData] = size(Data);
nbClusters = size(Sigma0, 3);
loglik_old = -realmax;
nbStep = 0;
Mu = Mu0;
Sigma = Sigma0;
Priors = Priors0;
flag = 'run';
%%

while strcmp(flag, 'run')
  %% E-step %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  Pxi = zeros(nbData, nbClusters);
  for i = 1:nbClusters
    % compute probability p(x|i)
    Pxi(:, i) = gaussPDF(Data, Mu(:, i), Sigma(:, :, i));
  end
  % compute posterior probability p(i|x)
  Pix_tmp = repmat(Priors, [nbData 1]).*Pxi;
  Pix = Pix_tmp./repmat(sum(Pix_tmp,2) + eps, [1 nbClusters]);
  % compute cumulated posterior probability
  E = sum(Pix);
  %% M-step %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  for i = 1:nbClusters
    % update the priors
    Priors(i) = E(i)/nbData;
    % update the centers
    Mu(:, i) = Data*Pix(:,i) / (E(i)+eps);
    % update the covariance matrices
    Data_tmp1 = Data - repmat(Mu(:, i), 1, nbData);
    Sigma(:, :, i) = (repmat(Pix(:, i)', nbVar, 1).*Data_tmp1*Data_tmp1')/(E(i) + eps);
    %% Add a tiny variance to avoid numerical instability
    Sigma(:, :, i) = Sigma(:, :, i) + 1E-5.*diag(ones(nbVar, 1));
  end
  %% Stopping criterion %%%%%%%%%%%%%%%%%%%%
  for i = 1:nbClusters
    % compute the new probability p(x|i)
    Pxi(:, i) = gaussPDF(Data, Mu(:, i), Sigma(:, :, i));
  end
  % compute the log likelihood
  F = Pxi*Priors';
  F(find(F < realmin)) = realmin;
  loglik = mean(log(F));
  % stop the process depending on the increase of the log likelihood 
  if abs((loglik_old-loglik)/loglik_old) < loglik_threshold || nbStep > maxIter
      K = nbClusters; % components
      dim = size(Sigma, 1);      
      loglh = wdensity(Data', Mu', Sigma, Priors, 0, 2);
      % the "log-sum-exp" trick
      maxll = max (loglh,[],2);
      % minus maxll to avoid underflow
      post = exp(bsxfun(@minus, loglh, maxll));
      density = sum(post,2);
      logpdf = log(density) + maxll;
      likelihood = sum(logpdf) ;
      freePara = K*dim*(dim+3)/2+K-1; 
      AIC = -2*likelihood+2*freePara;
      BIC = -2*likelihood+log(size(Pxi, 1))*freePara;
      AICBIC.likelihood = likelihood;
      AICBIC.freePara = freePara;
      AICBIC.logsize = log(size(Pxi, 1));  
      flag = 'stop';
  end
  loglik_old = loglik;
  nbStep = nbStep + 1;
end



