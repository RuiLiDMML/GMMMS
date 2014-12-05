function [resImg] = intNormal(img, choice)
%%% voxel intensity normalization

switch choice

    case 'PSMC' % Yakushev method, primary sensor motor cortex
        load PSMC.mat
        voxel = zeros(size(psmc, 1), 1);
        for i = 1:size(psmc, 1)
            voxel(i, 1) = img(psmc(i, 1), psmc(i, 2), psmc(i, 3));
        end
        avg = mean(voxel);
        resImg = img/avg;        
        
    case 'grandMean' % SPM approach

        load brainIndex.mat
        voxel = zeros(size(brainIndex, 1), 1);
        for i = 1:size(brainIndex, 1)
            voxel(i, 1) = img(brainIndex(i, 1), brainIndex(i, 2),brainIndex(i, 3));
        end
        avg = mean(voxel);
        resImg = img/avg; 
end







