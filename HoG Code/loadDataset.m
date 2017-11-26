
%% Load dataset 
path = 'C:\Courses\Computer Vision\ASL Gesture Recognition\Datasets\Triesch'
extension = 'pgm'

files = dir(strcat(path,'/*.',extension))
nFiles = size(files,1);
for i = 1:nFiles    
    fileName = files(i).name;
    imG = imread(strcat(path,'/',fileName));
    rgbImage = cat(3, imG,imG,imG);
    im{i} = rgbImage;
    name(i,:) = fileName(1:7);
	letter(i) = fileName(7);
	sample(i) = fileName(8);
    predictor.im = im{i};
    predictor.name = name(i,:);
    predictor.letter = letter(i);
    predictor.sample = sample(i);
    predictorCell{i} = predictor;
    
end
numImageCategories = max(size(unique(letter)));
letterCat = categorical(cellstr(letter'))
%% Check The Images
for i= 1:nFiles
    imshow(predictorCell{i}.im(:,:,1));
    predictorCell{i}
    input('yo')
end;
%% Split into training and test modules

[trainPredictor, trainLetter, testPredictor, testLetter] = splitdataset(predictorCell,letterCat,0.8);
nTrain = max(size(trainPredictor));
nTest = max(size(testPredictor));

trainImages = zeros(size(trainPredictor{1}.im,1),size(trainPredictor{1}.im,2),3,nTrain);
for i=1:nTrain
    trainImages(:,:,:,i) = trainPredictor{i}.im;
end

for i=1:nTrain
    trainImagesGray(:,:,i) = trainPredictor{i}.im(:,:,1);
end


%% HoG Features

for i=1:nTrain
    [hogFeatures,Viz] = extractHOGFeatures(trainImagesGray(:,:,i));
    subplot(2,1,1);
    imshow(trainImagesGray(:,:,i));
    subplot(2,1,2);
    plot(Viz)
    input('Ghe')
end;
%% Train the CNN
% Creating the input Layer
[height, width, numChannels ~] = size(trainImages);
imageSize = [height width numChannels];
inputLayer = imageInputLayer(imageSize);

% Middle Layers

filterSize = [5 5];
numFilters = 128;

middleLayers = [

% The first convolutional layer has a bank of 32 5x5x3 filters. A
% symmetric padding of 2 pixels is added to ensure that image borders
% are included in the processing. This is important to avoid
% information at the borders being washed away too early in the
% network.
convolution2dLayer(filterSize, numFilters, 'Padding', 2)

% Note that the third dimension of the filter can be omitted because it
% is automatically deduced based on the connectivity of the network. In
% this case because this layer follows the image layer, the third
% dimension must be 3 to match the number of channels in the input
% image.

% Next add the ReLU layer:
reluLayer()

% Follow it with a max pooling layer that has a 3x3 spatial pooling area
% and a stride of 2 pixels. This down-samples the data dimensions from
% 32x32 to 15x15.
maxPooling2dLayer(3, 'Stride', 2)

% Repeat the 3 core layers to complete the middle of the network.
convolution2dLayer(filterSize, numFilters, 'Padding', 2)
reluLayer()
maxPooling2dLayer(3, 'Stride',2)

convolution2dLayer(filterSize, 2 * numFilters, 'Padding', 2)
reluLayer()
maxPooling2dLayer(3, 'Stride',2)

]

finalLayers = [

% Add a fully connected layer with 64 output neurons. The output size of
% this layer will be an array with a length of 64.
fullyConnectedLayer(64)

% Add an ReLU non-linearity.
reluLayer

% Add the last fully connected layer. At this point, the network must
% produce 10 signals that can be used to measure whether the input image
% belongs to one category or another. This measurement is made using the
% subsequent loss layers.
fullyConnectedLayer(numImageCategories)

% Add the softmax loss layer and classification layer. The final layers use
% the output of the fully connected layer to compute the categorical
% probability distribution over the image classes. During the training
% process, all the network weights are tuned to minimize the loss over this
% categorical distribution.
softmaxLayer
classificationLayer
]


layers = [
    inputLayer
    middleLayers
    finalLayers
    ]


opts = trainingOptions('sgdm', ...
'Momentum', 0.9, ...
'InitialLearnRate', 0.001, ...
'LearnRateSchedule', 'piecewise', ...
'LearnRateDropFactor', 0.1, ...
'LearnRateDropPeriod', 8, ...
'L2Regularization', 0.004, ...
'MaxEpochs', 40, ...
'MiniBatchSize', 128, ...
'Verbose', true);

trainNetwork(trainImages,trainLetter,layers,opts);
