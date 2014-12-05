%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Rui Li
% written for Gaussian Mixture Model + Model Selection (GMMMS) to find ROI
% of a mean PET image (normal control)
%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear
close all

%% 
% suppose the normal control mean image is called 'NC_meanimage.mat'
% the 'imgAvg' is a matrix in size 902629 x 4, with the first three columns
% being the voxel indices and the 4th column is the intensity of the voxel

imgToPro = 'NC_meanimage.mat'; % data is saved as name 'imgAvg'

load matIndex.mat
load AAL_Atlas_Nii

%% AAL defined brain regions
brainIndex = [];
for i = 1:116
    brainIndex = [brainIndex; region{i, 1}];
end

bIndexInt = sub2ind([91 109 91], brainIndex(:, 1), brainIndex(:, 2),brainIndex(:, 3));

nbin = 100; % number of bins, such as, 50, 60,..., 100,..., 150
load(imgToPro)
bVoxel = imgAvg(bIndexInt, 4);
[n nout] = hist(bVoxel, nbin); % divide the voxels into bins
nout = [nout max(bVoxel)];

%% parameter initialization
data = zeros(902629, 4);
data(:, 1:3) = index;
miniSize = 30; % minimum cluster elements
maxiSize = 1000; % maximum cluster elements
count = 0;

%% find ROI (cluster) in each bin
for i = 1:nbin
    voxelRange = nout(i:i+1);
    idxTmp = find(bVoxel>=voxelRange(1)&bVoxel<voxelRange(2));
    ROI = brainIndex(idxTmp, :);
    len = size(ROI, 1);
    maxiK = round(len/miniSize); % minimum number of cluster
    miniK = round(len/maxiSize); % maximum number of cluster
    nlambda = 200;
    lambda_vec = round(linspace(miniK, maxiK, nlambda));
    lambda_vec = lambda_vec(find(lambda_vec>1));
    K_vec = unique(lambda_vec);
    if ~isempty(K_vec)
        ct = 0;
        count = count + 1;
        for k = 1:length(K_vec)
            nK = K_vec(k);
            [Priors, Mu, Sigma] = EM_Kmeanspp(ROI, nK);
            [Priors, Mu, Sigma, Pix,  AIC(k), BIC(k) model{k}] = EM(ROI, Priors, Mu, Sigma);
            ct = ct + 1;
            [classes] = EMclust(ROI', Priors, Mu, Sigma);
            ROIclasses{k, 1} = classes;
        end 
        [val position] = min(BIC); % use the minimum
        ROIallAICBIC{count, 1} = AIC;
        ROIallAICBIC{count, 2} = BIC;
        ROIallAICBIC{count, 3} = K_vec; % # cluster
        clear AIC BIC K_vec
    end            
end

save('PET_AICBIC_clusters.mat', 'ROIallAICBIC')




