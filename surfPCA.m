clc;
clear all;
img = {};
img{1} = imread('thresh_a2.jpg');
img{2} = imread('thresh_b2.jpg');
img{3} = imread('thresh_c2.jpg');
img{4} = imread('thresh_d2.jpg');
img{5} = imread('thresh_g2.jpg');
img{6} = imread('thresh_i2.jpg');
img{7} = imread('thresh_l2.jpg');
img{8} = imread('thresh_v2.jpg');
img{9} = imread('thresh_y2.jpg');

for i=1:9
    points = detectSURFFeatures(img{i});
    [features, valid_points] = extractFeatures(img{i}, points);
    features_std = zscore(features)
    [residuals,reconstructed] = pcares(features_std,2);
    
    xpca = reconstructed(:,1);
    ypca = reconstructed(:,2);
    %zpca = reconstructed(:,3);
    
    scatter(xpca,ypca); hold all;
    
end

% clc
% data = emailOutput;
% figure(2)
% h = histogram(data(:,1),10);
% [residuals,reconstructed] = pcares(data,2);
% xpca = reconstructed(:,1);
% ypca = reconstructed(:,2);
% zpca = reconstructed(:,3);
% scatter3(xpca,ypca,zpca);
