%% get Images

path = 'C:\Courses\Computer Vision\ASL Gesture Recognition\Datasets\osd\Dataset'
dirFolders = dir(path);
countOriginal = 1;
countThresh = 1;
for i = 3:numel(dirFolders)
    name = dirFolders(i).name;
    if numel(name) == 1
        newPath = strcat(path,'\',dirFolders(i).name);
        files = dir(newPath);
        for j = 3:numel(files)
            newName = files(j).name;
            if newName(1:3) == 'ori'
                originalIm{countOriginal} = imread(strcat(path,'/',name,'/',newName));
                countOriginal = countOriginal + 1;
                break;
            end ;
        end;
        for j = 3:numel(files)
            newName = files(j).name;
            if newName(1:3) == 'thr'
                threshIm{countThresh} = imread(strcat(path,'/',name,'/',newName));
                countThresh= countThresh+ 1;
                break;
            end; 
        end;
        
    end
end

%% show Features

nIm = numel(threshIm);
nIm = 4
for i = 1:nIm
    figure(1);
    % Original Image
    subplot(nIm,6,6*(i-1)+1);
    imshow(originalIm{i});
    
    % Thresholded Image
    subplot(nIm,6,6*(i-1)+2);
    imshow(threshIm{i});
    
    % Bounded Box Image
    boundIm = getBoundary(threshIm{i});
    subplot(nIm,6,6*(i-1)+3);
    imshow(boundIm.boundedImage);
    
    % Eroded Image
    erodeIm = threshIm{i} - imerode(threshIm{i},strel('disk',1));
    subplot(nIm,6,6*(i-1)+4);
    imshow(erodeIm);
    
    % hog Features
    [hogIm viz] = extractHOGFeatures(boundIm.boundedImage);
    subplot(nIm,6,6*(i-1)+5);
    plot(viz)
    
    % Get Fingers
    blob = imopen(boundIm.boundedImage,strel('disk',10));
    subplot(nIm,6,6*(i-1)+6);
    imshow(boundIm.boundedImage - blob);

end

nIm = 5
originalIm(1:5) = originalIm(5:9);

threshIm(1:5) = threshIm(5:9);
for i = 1:5
    figure(2);
    % Original Image
    subplot(nIm,6,6*(i-1)+1);
    imshow(originalIm{i});
    
    % Thresholded Image
    subplot(nIm,6,6*(i-1)+2);
    imshow(threshIm{i});
    
    % Bounded Box Image
    boundIm = getBoundary(threshIm{i});
    subplot(nIm,6,6*(i-1)+3);
    imshow(boundIm.boundedImage);
    
    % Eroded Image
    erodeIm = threshIm{i} - imerode(threshIm{i},strel('disk',1));
    subplot(nIm,6,6*(i-1)+4);
    imshow(erodeIm);
    
    % hog Features
    [hogIm viz] = extractHOGFeatures(boundIm.boundedImage);
    subplot(nIm,6,6*(i-1)+5);
    plot(viz)
    
    % Get Fingers
    blob = imopen(boundIm.boundedImage,strel('disk',10));
    subplot(nIm,6,6*(i-1)+6);
    imshow(boundIm.boundedImage - blob);

end


%% PCA for HoG


for i = 1:9
    bIm{i} = getBoundary(threshIm{i});
    hogIm{i} = extractHOGFeatures(bIm{i}.boundedImage);
end;

hogArr = double(reshape(cell2mat(hogIm),[],size(hogIm,2)));
[PC,score,latent,ts,explained]=pca(hogArr);
