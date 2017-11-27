%% Load DataSets

path = 'C:\Courses\Computer Vision\ASL Gesture Recognition\Datasets\osd\Dataset';
dirFolders = dir(path)

letter = ['abcdefghijklmnopqrstuvwxyz'];
count = 1;
for i=3:size(dirFolders,1)
    if size(dirFolders(i).name,2) == 1
        dataset.letter = dirFolders(i).name;
        newPath = strcat(path,'\',dirFolders(i).name)
        files = dir(newPath)
        [dataset.originalIm,dataset.thresholdIm,dataset.area,dataset.defects,dataset.hull] = loadFiles(newPath,files);
        datasets{count} = dataset;
        count = count + 1;
    end    
end