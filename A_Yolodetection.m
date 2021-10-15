clear all,close all, clc

load('train_data_ann.mat')
[a,b]=size(train_data_ann); 
n=round(a*0.5);
ech = randsample(a,n);
train_data_ann=train_data_ann(ech,:);
        
% Define the image input size.
imageSize = [224 224 3];

% Define the number of object classes to detect.
numClasses = width(train_data_ann)-1;
load('anchorBoxes.mat')
% anchorBoxes = [
%     76 79
%     65 58
%     138 139
% ];
baseNetwork = resnet50;
%analyzeNetwork(baseNetwork)
% Specify the feature extraction layer.
featureLayer = 'activation_40_relu';
%%% essai %%%%%   featureLayer = 'activation_49_relu';

% Create the YOLO v2 object detection network. 
lgraph = yolov2Layers(imageSize,numClasses,anchorBoxes,baseNetwork,featureLayer);
 options = trainingOptions('sgdm', ...
        'MiniBatchSize',3, ....
        'InitialLearnRate',1e-3, ...
        'MaxEpochs',7,...
        'ExecutionEnvironment','gpu', ...
        'Shuffle','every-epoch');
        %'CheckpointPath', tempdir, ...
           
    
    % Train YOLO v2 detector.
    [detector,info] = trainYOLOv2ObjectDetector(train_data_ann,lgraph,options);
        save('detector','detector')
%% test
clear all, close all, clc
load('detector.mat')
load('tst_data_ann.mat')
%
depVideoPlayer = vision.DeployableVideoPlayer;
for i = 1:height(tst_data_ann)
    
    Read the image.
    I = imread(tst_data_ann.Paths{i});
    
    Run the detector.
    [bboxes,scores,labels] = detect(detector,I,'ExecutionEnvironment', 'gpu', 'SelectStrongest',true);
    display bb
    if ~isempty(bboxes)
         I = insertObjectAnnotation(I,'Rectangle',bboxes,cellstr(labels));       
         
         depVideoPlayer(I);
         pause(0.1);
    else
         depVideoPlayer(I);
    end

    Collect the results.
    results(i).Boxes = bboxes;
    results(i).Scores = scores;
    results(i).Labels = labels;
end
results = struct2table(results);
save('results','results')
Extract expected bounding box locations from test data.

expectedResults = tst_data_ann(:,2:end);
Evaluate the object detector using average precision metric.
[ap, recall, precision] = evaluateDetectionPrecision(results, expectedResults);
% plot precision per class
plot(recall{1,1},precision{1,1},'g-','LineWidth',2, "DisplayName",'Right Hand');
hold on;
plot(recall{2,1},precision{2,1},'b-','LineWidth',2, "DisplayName",'Left Hand');
hold on;
plot(recall{3,1},precision{3,1},'r-','LineWidth',2, "DisplayName",'Head');
hold off;
xlabel('Recall');
ylabel('Precision');
title(sprintf('Average Precision = %.2f\n',ap))
legend('Location', 'best');
legend('boxoff');
% Evaluate miss rate metric for object detection
[am,fppi,missRate] = evaluateDetectionMissRate(ress, expectedResults);
% Plot the log miss rate metrics for each class to false positives per image.
loglog(fppi{1,1}, missRate{1,1},'-g','LineWidth',2, "DisplayName",'Right Hand');
hold on;
loglog(fppi{2,1}, missRate{2,1}, 'b','LineWidth',2,"DisplayName",'Left Hand');
hold on;
loglog(fppi{3,1}, missRate{3,1},'-r','LineWidth',2, "DisplayName",'Head');
hold off;
xlabel('False Positives Per Image');
ylabel('Log Average Miss Rate');
title(sprintf('Log Average Miss Rate = %.2f\n', am))
legend('Location', 'best');
legend('boxoff');