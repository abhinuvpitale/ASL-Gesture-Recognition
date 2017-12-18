im = imread('original_a1.jpg');
grayim = rgb2gray(im);
count = 1;
for i = 0:0.01:1
    a = imbinarize(grayim,i);
    test(count) = numel(find(a == 1));
    count = count + 1
end

slope = test(2:end) - test(1:end-1) 
slope2 = slope(2:end) - slope(1:end-1)

figure(1)
subplot(3,1,1);
plot(test);
subplot(3,1,2);
plot(slope);
subplot(3,1,3);
plot(slope2);

test = imread('thresh_a1.jpg')

testim = rgb2gray(im);
kmes = kmeans(testim(:),2);
tester = zeros(200,200);
tester(find(kmes == 2)) = 1;
imshow(tester)

imagesc(im)
masker = false(size(tester))
masker(10:120,90:120) = true;
imshow(masker)

bw1 = activecontour(testim,masker,200,'edge');

%%
testNew = imread('origImg.jpg');
hsvSpace = rgb2hsv(testNew);
testim = hsvSpace(:,:,3) - hsvSpace(:,:,2);

kmes = kmeans(testim(:),2);
tester = zeros(200,200);
tester(find(kmes == 2)) = 1;
imshow(tester)