% Load the dataset with the updated boundary box.
% Use this to generate features
clc;
clear all;
close all;


%% Load the dataset

path = 'C:\Courses\Computer Vision\ASL Gesture Recognition\Datasets\osd\Dataset';
dirFolders = dir(path);
letter = ['abcdefghijklmnopqrstuvwxyz'];
count = 1;
for i=3:size(dirFolders,1)
    %if size(dirFolders(i).name,2) ~= 1
    dataset.letter = dirFolders(i).name(1);
    newPath = strcat(path,'\',dirFolders(i).name);
    files = dir(newPath);
    [dataset.originalIm,dataset.thresholdIm,dataset.area,dataset.defects,dataset.hull] = loadFiles(newPath,files);
    datasets{count} = dataset;
    count = count + 1;
    %end
end
nDatasets = count-1;

clearvars dataset
clearvars files
clearvars i
clearvars count
clearvars letter

%% add boundary features to the dataset 

%Insert all the thresholded matrices in a single one and create a response
%matrix
nObservations = 1;
for i=1:nDatasets
    threshImTemp = datasets{i}.thresholdIm;
    currLetter = datasets{i}.letter;
    nThreshIm = size(threshImTemp,2);
    threshIm(nObservations:nObservations+nThreshIm-1) = threshImTemp; 
    response(nObservations:nObservations+nThreshIm-1) = repmat(currLetter,1,nThreshIm);
    nObservations = nObservations + nThreshIm - 1;
end;

clearvars currLetter
clearvars nThreshIm
%% Generate boundary box thresholded images

for i = 1:nObservations
    bIm{i} = getBoundary(threshIm{i});
    %imwrite(bIm{i}.boundedImage,strcat('.\bounded\bound',num2str(i),'.jpg'));
end;    

%% get Ratio of Areas
for i = 1:nObservations
    ratio(i) = bIm{i}.ratio;
end;
%%
for i =1:nObservations
    boundaryFeatures{i} = extractHOGFeatures(threshIm{i});
end;
    

k = 0.8;
[trainHog trainLetter testHog testLetter] = splitdataset(hogThreshIm,response,k) ;
trainHog = double(reshape(cell2mat(trainHog),[],size(trainHog,2)));
testHog = double(reshape(cell2mat(testHog),[],size(testHog,2)));
