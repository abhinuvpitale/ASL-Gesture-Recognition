function [trainFeat trainLetter testFeat testLetter] = splitdataset(hogFeat,letter,k)
    n = max(size(letter));
    nTrain = round(n*k);
    nTest = n-nTrain;
    
    trainIdx = randperm(n,nTrain);
    testIdx = setdiff(1:n,trainIdx);
    trainFeat = hogFeat(trainIdx);
    trainLetter = letter(trainIdx);
    testFeat = hogFeat(testIdx);
    testLetter = letter(testIdx);    

end