clc;
close  all;
clear all;

%% Pre-presentation Run
mdl = load('osdNewLetterSVM.mat');
mdl = mdl.mdl;
figure(1);
while true    
    system('py imgSave.py');
    thresIm = imread('threshImg.jpg');
    figure(1);
    title('Thresholded Image');
    imshow(thresIm);
    orgIm = imread('origImg.jpg');
    figure(2);
    imshow(orgIm);
    hog = extractHOGFeatures(thresIm);
    prediction = predict(mdl,hog)  
    text(1,1,prediction,'Color','red','FontSize',20)
    
end;

%% Feature Extractor

while true    
    system('py imgSave.py');
    thresIm = imread('threshImg.jpg');
    figure(1);
    title('Thresholded Image');
    imshow(thresIm);
    orgIm = imread('origImg.jpg');
    figure(2);
    imshow(orgIm);
    
    bIm = getBoundary(thresIm);
    bIm = bIm.boundedImage;    
    figure(3);
    imshow(bIm)
    
    edgeIm = bIm - imerode(bIm,strel('disk',1));
    figure(4);
    imshow(edgeIm)
    
end;
