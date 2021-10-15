clear all
close all
clc
imds = imageDatastore('E:\1BB\RGB1','IncludeSubfolders',true,'LabelSource','foldernames');


[imdsTrain,imdsTest] = splitEachLabel(imds,0.6,'randomized');
net=vgg16;
numClasses=16;
inputSize = net.Layers(1).InputSize;
imdsTrain = augmentedImageDatastore(inputSize(1:2),imdsTrain);
imdsTest = augmentedImageDatastore(inputSize(1:2),imdsTest);
layersTransfer = net.Layers(1:end-3);
numClasses = 16;
layers = [
    layersTransfer
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];

options = trainingOptions('sgdm', ...
    'MiniBatchSize',8, ...
    'MaxEpochs',2, ...
    'InitialLearnRate',1e-4, ...
    'Shuffle','every-epoch');


net_1bb = trainNetwork(imdsTrain,layers,options);

save('net_1bb','net_1bb')
