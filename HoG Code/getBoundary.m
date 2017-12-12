function bb = getBoundary(im)    
    im(im<200) = 0;
    segIm = logical(im);
    [shapeX shapeY]= find(segIm > 0);
    x = min(shapeX);
    y = min(shapeY);
    height = max(shapeX)- x;
    width = max(shapeY) - y;
    boundedImage = segIm(x:x+height,y:y+width);
    ratio = numel(find(boundedImage>0))/numel(boundedImage);
    bb.height = height;
    bb.width = width;
    bb.ratio = ratio;
    bb.x = x;
    bb.y = y;
    bb.boundedImage = boundedImage;
    
end

