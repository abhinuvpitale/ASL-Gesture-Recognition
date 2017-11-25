import numpy as np
import cv2
from skimage import color,exposure
from skimage.feature import hog

import matplotlib.pyplot as plt

img = cv2.imread('bfritza1.pgm')
bwImg = color.rgb2gray(img)
print img.shape
print bwImg.shape
cv2.imshow('image',img)
cv2.waitKey(0)
cv2.imshow('image',bwImg)
cv2.waitKey(0)

fd, hog_image = hog(bwImg, orientations=8, pixels_per_cell=(8, 8),
                    cells_per_block=(1, 1), visualise=True)

print fd
print hog_image
hog_disp = exposure.rescale_intensity(hog_image,in_range = (0,0.02))
cv2.imshow('HOG',hog_disp);
cv2.waitKey(0)


fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(8, 4), sharex=True, sharey=True)
ax1.axis('off')
ax1.imshow(img, cmap=plt.cm.gray)
ax1.set_title('Input image')
ax1.set_adjustable('box-forced')

ax2.axis('off')
ax2.imshow(hog_disp, cmap=plt.cm.gray)
ax2.set_title('Histogram of Oriented Gradients')
ax1.set_adjustable('box-forced')
plt.show()

cv2.destroyAllWindows