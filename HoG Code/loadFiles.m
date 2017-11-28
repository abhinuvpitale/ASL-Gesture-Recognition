function [originalIm,thresholdIm,area,defects,hull] = loadFiles(path,files)
    nFiles = size(files,1);
    countOriginal = 1;
    countThreshold = 1;
    for i = 1:nFiles
        currFileName = files(i).name;
        if size(currFileName,2) > 3
            if currFileName(end-2:end) == 'jpg'
                if currFileName(1:3) == 'ori'
                    originalIm{countOriginal} = imread(strcat(path,'/',currFileName));
                    countOriginal = countOriginal + 1;
                end
                if currFileName(1:3) == 'thr'
                    thresholdIm{countThreshold} = imread(strcat(path,'/',currFileName));
                    countThreshold = countThreshold + 1;
                end            
            end 
        end
    end
    defects = 0;
    area = 0;
    hull = 0;
end