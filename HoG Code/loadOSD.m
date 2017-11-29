function accuracy = loadOSD()


%% Load DataSets

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

%% Part 1 - Using the Thresholded Image -> HoG Features
%% Divide into Training and Testing 

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

for i =1:nObservations;
    hogThreshIm{i} = extractHOGFeatures(threshIm{i});
end;

k = 0.8;
[trainHog trainLetter testHog testLetter] = splitdataset(hogThreshIm,response,k) ;
trainHog = double(reshape(cell2mat(trainHog),[],size(trainHog,2)));
testHog = double(reshape(cell2mat(testHog),[],size(testHog,2)));

%% Part2 - Fit the SVM
mdl = fitcecoc(trainHog',trainLetter');

%% Part3 - Test the SVM
Y = predict(mdl,testHog')
accuracy = numel(find(Y-testLetter' == 0))/numel(Y) * 100

%% Part4 - Data Augmentation
% Do NOT execute this if the flipped images are already created.

% for i = 1:nDatasets
%     dataset = datasets{i};
%     newPath = strcat(path,'\',dataset.letter,'Flip');
%     if ~exist(newPath)
%         mkdir(strcat(path,'\',dataset.letter,'Flip'));
%     end;
%     nSize = size(dataset.originalIm,2);
%     for j = 1:nSize
%         imwrite(flipdim(dataset.originalIm{1},2),strcat(newPath,'\originalF_',dataset.letter,num2str(j),'.jpg'),'jpg');
%         imwrite(flipdim(dataset.thresholdIm{1},2),strcat(newPath,'\threshF_',dataset.letter,num2str(j),'.jpg'),'jpg');     
%     end
% end;

end
