The core code for the paper submitted to PLOS ONE
"Gaussian mixture models and model selection for [18F] fluorodeoxyglucose positron emission tomography classification in Alzheimer’s disease"

Because we are not allowed to distribute any images of ADNI, so that we can only provide the core code.
The PET image file must be in size [91 109 91].

get_NC_meanimage.m: get the mean normal control (NC) images from many NC images
GMMMS: get the ROI (cluster) of a given mean NC images
featureExtraction: extract features from a new image based on the found ROIs (clusters)

After collecting the features from two groups of images, we can then use any classification algorithm
to build a model to make a prediction. The LIBSVM, for example, is a good package to do so, see
http://www.csie.ntu.edu.tw/~cjlin/libsvm/