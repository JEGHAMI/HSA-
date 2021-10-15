clear all, close all,clc
load('ress.mat')
load('bb_train.mat')
load('train_data_ann.mat')
load('tst_data_ann.mat')
%% train
for i =1:height(train_data_ann)

    % Read the image.
    I = imread(train_data_ann.Paths{i});
    I1=I;
    I1(:,:,:)=0;
     bb=bb_train.Boxes{i,1};
     
       xmin=min(bb(:,1));
       ymin=min(bb(:,2));
       [a,b]= size(bb_train.Boxes{i,1});
       w=0;
       h=0;
              for j=1:a
                bbb=bb_train.Boxes{i,1}(j,:);
                    if w < (bbb(1)+bbb(3))
                       w=bbb(1)+bbb(3);
                    end
                    if h < (bbb(2)+bbb(4))
                        h=bbb(2)+bbb(4);
                    end
              end
       I1(ymin:h-1,xmin+2:w-1,:)=I(ymin:h-1,xmin+2:w-1,:);
      %imshow(I1)
     k = strfind(train_data_ann.Paths{i},'RGB1_SUB');
     n=train_data_ann.Paths{i}(k:end);
     s=strfind(train_data_ann.Paths{i},'ACT');
    ss=train_data_ann.Paths{i}(k+8:s-1);
    a=strfind(train_data_ann.Paths{i},'F');
    aa=train_data_ann.Paths{i}(s+3:a-1);
     nm=strcat('E:\1BB\RGB1\S',ss,'\AC',aa,'\',n);
    imwrite(I1,nm);
   

    %figure,imshow(I1);  
end
% imds = imageDatastore('E:\1BB\RGB1','IncludeSubfolders',true,'LabelSource','foldernames');

%% test

for i = 1:height(tst_data_ann)

    % Read the image.
    I = imread(tst_data_ann.Paths{i});
    I1=I;
    I1(:,:,:)=0;
       bb=ress.Boxes{i,1};
       xmin=min(bb(:,1));
       ymin=min(bb(:,2));
       [a,b]= size(ress.Boxes{i,1});
       w=0;
       h=0;
   for j=1:a
       bbb=ress.Boxes{i,1}(j,:);
      if w < (bbb(1)+bbb(3))
          w=bbb(1)+bbb(3);
      end
      if h < (bbb(2)+bbb(4))
          h=bbb(2)+bbb(4);
      end
   end
      I1(ymin:h-1,xmin+2:w-1,:)=I(ymin:h-1,xmin+2:w-1,:);
%        imshow(I1)
     k = strfind(tst_data_ann.Paths{i},'RGB1_SUB');
     n=tst_data_ann.Paths{i}(k:end);
     s=strfind(tst_data_ann.Paths{i},'ACT');
    ss=tst_data_ann.Paths{i}(k+8:s-1);
    a=strfind(tst_data_ann.Paths{i},'F');
    aa=tst_data_ann.Paths{i}(s+3:a-1);
     nm=strcat('E:\1BB\RGB1\S',ss,'\AC',aa,'\',n);
    imwrite(I1,nm);
%    

    %figure,imshow(I1);  
end
