hog = load('hog.mat');
letter = hog.letter;
hogFeat = hog.hogFeat;

k=0.8;
[trainFeat, trainLetter, testFeat, testLetter] = splitdataset(hogFeat,letter,k);

mdl = fitcecoc(trainFeat',trainLetter);

predValues = predict(mdl,testFeat');