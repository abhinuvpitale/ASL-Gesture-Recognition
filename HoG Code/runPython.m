clc;
close  all;
clear all;
mdl = load('osdNewLetterSVM.mat');
mdl = mdl.mdl;
figure(1);
while true    
    system('python imgSave.py');
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