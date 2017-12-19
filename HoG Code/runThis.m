clc;
close  all;
clear all;

%% Model 1 - Trained only on HoG for the entire image

%mdl = load('osdNewLetterSVM.mat');
mdl = load('boundaryOSD_SVM.mat'); % uses the boundary box extracted Hog features from the osd augmented 10 letter dataset.

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
    figure(3);
    imshow(imerode(thresIm,strel('disk',5)));
    
    bIm = getBoundary(thresIm);
    hog = extractHOGFeatures(imresize(bIm.boundedImage,[150 150]));
    %hog = extractHOGFeatures(thresIm);
    prediction = predict(mdl,hog)  
    text(1,1,prediction,'Color','red','FontSize',20)
    
end;

%% Feature Extraction -  used to display the various features we extraced
fileID = fopen('Dataset.txt','w');  
while true    
    system('python imgSave.py');
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

%% Try HSV

while true
    system('python imgSave.py');
    orgIm = imread('origImg.jpg');
    figure(1);
    imshow(orgIm);
    
    hsvIm = rgb2hsv(orgIm);
    figure(2);
    imshow(hsvIm);
    
    figure(3);
    imshow(hsvIm(:,:,1));

    
    figure(4);
    imshow(hsvIm(:,:,2));
    
    figure(5);
    imshow(hsvIm(:,:,3));
end;
    
%% Final Model - Contains the HoG trained on the boundary boxed images along with height, width and ratio features.
mdl = load('boundaryOSD_SVM.mat'); % uses the boundary box extracted Hog features from the osd augmented 10 letter dataset.
mdl = mdl.mdl;
totPred = 'Letter Predicted -> ' ;
lastPrediction = ' ';
count = 1;
lettersFile = fopen('letters.txt','w');
    
f1 = figure(1) ;
axes1  = findall(f1,'type','auto');
f2 = figure(2) ;
axes2  = findall(f2,'type','auto');
f3 = figure(3) ;
axes3  = findall(f3,'type','auto');
f4 = figure(4) ;
axes4  = findall(f4,'type','auto');
f5 = figure(5) ;
axes5  = findall(f5,'type','auto');
while true
    
    system('python imgSave.py');
    
    thresIm = imread('threshImg.jpg');    
    orgIm = imread('origImg.jpg');
    
    bIm = getBoundary(thresIm);
    hog = extractHOGFeatures(imresize(bIm.boundedImage,[150 150]));
    %hog = extractHOGFeatures(thresIm);
    prediction = predict(mdl,hog)  ;
    if prediction ~= lastPrediction
        totPred = strcat(totPred ,prediction);
        count = count + 1;
        fprintf(lettersFile,prediction);
    
    end
    lastPrediction = prediction;
    clf(f1)
    figure(f1)
    imshow(orgIm);
    title('Original Image');
    rectangle('Position',[bIm.y bIm.x bIm.width bIm.height],'EdgeColor','r');
    
    clf(f2)
    figure(f2);
    imshow(thresIm);
    title('Binary Thresholded Image');
    rectangle('Position',[bIm.y bIm.x bIm.width bIm.height],'EdgeColor','r');
    
    clf(f3)
    figure(f3);
    mTextBox = uicontrol('style','text');
    set(mTextBox,'FontSize',20);
    set(mTextBox,'String',totPred);
    set(mTextBox,'Position',[1 1 600 60]);
    
    text(1,1,prediction,'Color','red','FontSize',20)
   
    clf(f4)
    figure(f4);    
    imshow(bIm.boundedImage);
    title('Bounded Image');
    %set(mTextBox,'Position',[100 100 1000 1000])
    
    %fclose(lettersFile);
    if count > 4
        wordFile = fopen('words.txt','r');
        word = fscanf(wordFile,'%s')
        fgetl(wordFile);
        
        clf(f5)
        figure(f5);
        mTextBox1 = uicontrol('style','text');
        set(mTextBox1,'FontSize',20);
        set(mTextBox1,'String',strcat('Current Word -> ',word));
        set(mTextBox1,'Position',[1 1 600 60]);
        totPred = strcat(totPred,'-')
        %lettersFile = fopen('letters.txt','r');
        fgetl(lettersFile);
        fclose(lettersFile);
        lettersFile = fopen('letters.txt','w');    
        count = 1;
    end;
    

    
    
end