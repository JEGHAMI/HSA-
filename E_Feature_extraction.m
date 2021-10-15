clc, clear all, close all
clc
ext1='*.jpg';
net = load('net_1bb.mat');
net=net.net_1bb;
k=1;
YTrain=[];

for s=13:50
    ss=num2str(s);
     for a=1:16
        aa=num2str(a);
          cheminRGB= strcat('E:\1BB\RGB1\S',ss,'\AC',aa);
          
          l= dir(fullfile(cheminRGB,ext1));
          taille=length(l);
         ff=[];
         for j=1:taille
             
              jj=num2str(j);
              imr=strcat(cheminRGB,'\','RGB1_SUB',ss,'ACT',aa,'F',jj,'.jpg');
               I=imread(imr);
             %% CNN for feature extraction
             inputSize = net.Layers(1).InputSize;
             augimdsTrain = augmentedImageDatastore(inputSize(1:2),I);
             layer=net.Layers(38).Name;
             f = activations(net,augimdsTrain,layer,'OutputAs','rows');
            ff=[ff;f];
          end
          ff=ff';
          ff=double(ff);
          YTrain=[YTrain;a];
           %kk=num2str(k);
          XTrain{k,1}=ff;
          k=k+1;
          
    end
   
end
YTrain=categorical(YTrain)
save('YTrain','YTrain')
save('XTrain','XTrain','-v7.3')
%% Test
k=1;
YTest=[];
tic
for s=1:12
    ss=num2str(s);
     for a=1:16
        aa=num2str(a);
          cheminRGB= strcat('E:\1BB\RGB1\S',ss,'\AC',aa);
          
          l= dir(fullfile(cheminRGB,ext1));
          taille=length(l);
         ff=[];
         for j=1:taille
             
              jj=num2str(j);
              imr=strcat(cheminRGB,'\','RGB1_SUB',ss,'ACT',aa,'F',jj,'.jpg');
               I=imread(imr);
             %% CNN for feature extraction
             inputSize = net.Layers(1).InputSize;
             augimdsTrain = augmentedImageDatastore(inputSize(1:2),I);
             layer=net.Layers(38).Name;
             f = activations(net,augimdsTrain,layer,'OutputAs','rows');
            ff=[ff;f];
          end
          ff=ff';
          ff=double(ff);
          YTest=[YTest;a];
           %kk=num2str(k);
          XTest{k,1}=ff;
          k=k+1;
          
    end
   
end
YTest=categorical(YTest)
toc
save('YTest','YTest')
save('XTest','XTest','-v7.3')

%%
