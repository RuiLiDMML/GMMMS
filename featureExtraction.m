%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Rui Li
% written for feature extraction based on GMM+MS method given a PET image
% with size [91 109 91]
%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear
close all

load matIndex.mat
load AAL_Atlas_Nii
load brainIndex.mat
load PET_AICBIC_clusters.mat

ROIClass = ROIallAICBIC;
imgToPro = 'example.nii'; % suppose the PET image is called 'example.nii'

for cl = 1:length(ROIClass)
    classes = ROIClass{cl, 1};
    cla = classes(:, 4);
    nK = length(unique(cla));
    bIndexInt = sub2ind([91 109 91], brainIndex(:, 1), brainIndex(:, 2),brainIndex(:, 3));
    data = zeros(902629, 4);
    data(:, 1:3) = index;
    groupStats = [];
    intensity = zeros(nImages, nK);
    V = spm_vol_nifti(imgToPro);
    imgOri = spm_read_vols(V);
    imgOri = intNormal(imgOri, 'cerebellum'); % intensity normalization
    % the intensity of the PET
    for j = 1:902629
         data(j, 4) = imgOri(index(j, 1), index(j, 2), index(j, 3));
    end
    for j = 1:nK
        tmpIdx = find(cla == j);
        tmp3D = sub2ind([91 109 91], classes(tmpIdx, 1), classes(tmpIdx, 2), classes(tmpIdx, 3));
        tmpInten = data(tmp3D, 4); % extract the intensities of these voxels
        intensity(m, j) = mean(tmpInten);
        intensity(m, nK+j) = std(tmpInten);
    end
    feature = intensity;
end

save('PET_AICBIC_clusters_features.mat', 'feature')








