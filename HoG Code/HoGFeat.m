%% Load Dataset
predictor = load('Predictor.mat');
predictor = predictor.predictorCell;

nPredictor = max(size(predictor));
nBlackWhite = 1;
for i = 1:nPredictor
    if predictor{i}.sample ~= '4'
        predictorBW{nBlackWhite} = predictor{i};
        nBlackWhite = nBlackWhite + 1;
    end
end;
nBlackWhite = nBlackWhite - 1;

%% Check The Images
% for i= 1:nBlackWhite
%     imshow(predictorBW{i}.im(:,:,1));
%     predictorBW{i}
%     input('yo')
% end;

%% Extract HoG Features

for i= 1:nBlackWhite
    [hogFeatures,Viz] = extractHOGFeatures(predictorBW{i}.im(:,:,1),'CellSize',[16 16]);
    predictorBW{i}.hogFeatures = hogFeatures;
    letter(i) = predictorBW{i}.letter;
end;

%% Split into Training and Testing Data

[trainPredictor, trainLetter, testPredictor, testLetter] = splitdataset(predictorBW,letter,0.3);
nTrain = max(size(trainPredictor));
nTest = max(size(testPredictor));


%% Train multi Dim SVM

X = zeros(nTrain,max(size(trainPredictor{1}.hogFeatures)));
Y = zeros(nTrain,1);
for i = 1:nTrain
    X(i,:) = trainPredictor{i}.hogFeatures;
    Y(i) = double(trainLetter(i));
end;

%% Fit Model

mdl = fitcecoc(X,Y);

%% Test Model

Yhat = zeros(nTest,1);
for i = 1:nTest
    Yhat(i) = predict(mdl,testPredictor{i}.hogFeatures);
end;

YTrue = double(testLetter)';
truePositive = max(size(find(Yhat-YTrue == 0)))/max(size(YTrue));

