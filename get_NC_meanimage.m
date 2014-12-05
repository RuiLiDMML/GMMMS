%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Rui Li
% written for computing the mean NC (normal control) image
%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear
close all

load matIndex.mat
load AAL_Atlas_Nii
load brainIndex.mat

bIndexInt = sub2ind([91 109 91], brainIndex(:, 1), brainIndex(:, 2),brainIndex(:, 3));
dataset = 'ADNI';

data = zeros(902629, 4);
data(:, 1:3) = index;
% suppose normal control images are saved in a folder path
Mul_ImgRead = dir(strcat(path, '*.nii'));
nImages = size(Mul_ImgRead, 1);

for m = 1:nImages
    imgToPro = strcat(path, Mul_ImgRead(m).name); % read in PET
    V = spm_vol_nifti(imgToPro);
    imgOri = spm_read_vols(V);
    imgOri = intNormal(imgOri, 'PSMC'); % intensity normalization
    imgOri(isnan(imgOri)) = 0;
    bVoxel = zeros(size(brainIndex, 1), 1); % brain voxel intensity
    for j = 1:size(brainIndex, 1)
         bVoxel(j, 1) = imgOri(brainIndex(j, 1), brainIndex(j, 2), brainIndex(j, 3));
    end    
    for j = 1:902629
         data(j, 4) = imgOri(index(j, 1), index(j, 2), index(j, 3));
    end
    meanInten(:, m) = data(:, 4);
end
imgAvg(:, 4) = mean(meanInten, 2);
imgAvg(:, 1:3) = data(:, 1:3);

save('NC_meanimage.mat', 'imgAvg')




