clc;
close  all;
clear all;

%% Run the model

%mdl = load('osdNewLetterSVM.mat');
mdl = load('boundaryOSD_SVM.mat'); % uses the boundary box extracted Hog features from the osd augmented 10 letter dataset.

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
    
    bIm = getBoundary(thresIm);
    hog = extractHOGFeatures(imresize(bIm.boundedImage,[150 150]));
    %hog = extractHOGFeatures(thresIm);
    prediction = predict(mdl,hog)  
    text(1,1,prediction,'Color','red','FontSize',20)
    
end;

%% Feature Extractor
fileID = fopen('Dataset.txt','w');
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
    fprintf(fileID,'%f %f %f \n',bIm.ratio,bIm.height,bIm.width);
    bIm = bIm.boundedImage;      
    figure(3);
    imshow(bIm)
    
    edgeIm = bIm - imerode(bIm,strel('disk',1));
    figure(4);
    imshow(edgeIm)

    figure(5);
    erode = imerode(thresIm,strel('disk',10));
    imshow(erode)
    
end;
fclose(fileID);