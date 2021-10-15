clear all, close all, clc
%% load train, test data
load('XTrain.mat');
load('YTrain.mat');
load('XTest.mat');
load('YTest.mat');


%% parameters
inputSize = 4096;
numHiddenUnits = 150;%100
numClasses = 16;

layers = [ ...
    sequenceInputLayer(inputSize)
    bilstmLayer(numHiddenUnits,'OutputMode','last')
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer]
maxEpochs = 400;
miniBatchSize = 64;

options = trainingOptions('adam', ...
    'ExecutionEnvironment','gpu', ...
    'GradientThreshold',1, ...
    'MaxEpochs',maxEpochs, ...
    'MiniBatchSize',miniBatchSize, ...
    'SequenceLength','longest', ...
    'Shuffle','never', ...
    'Verbose',0, ...
    'Plots','training-progress');

net = trainNetwork(XTrain,YTrain,layers,options);
YPred = classify(net,XTest, ...
    'MiniBatchSize',miniBatchSize, ...
    'ExecutionEnvironment','gpu');
acc = sum(YPred == YTest)./numel(YTest)

C=confusionmat(YTest,YPred);
C=C/12*100;
xvar=categorical({'A1','A2','A3','A4','A5','A6','A7','A8','A9','A10','A11','A12','A13','A14','A15','A16'});
yvar=categorical({'A1','A2','A3','A4','A5','A6','A7','A8','A9','A10','A11','A12','A13','A14','A15','A16'});
heatmap(xvar,yvar,C);
