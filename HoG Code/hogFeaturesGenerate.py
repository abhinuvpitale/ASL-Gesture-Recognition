import numpy as np
import cv2
import os
import re
from skimage import color, exposure
from skimage.feature import hog
import matplotlib.pyplot as plt
import pandas as pd

path = 'C:/Courses/Computer Vision/project/Datasets/Triesch'
extension = 'pgm'

#hog_table = pd.DataFrame(columns=['file','name','letter','sample','image','hogfeature','hog_disp'])
hog_table = pd.DataFrame(columns=['file','name','letter','sample','hogfeature'])
print hog_table
rowDict={}
rowList = []
i=0;
for file in os.listdir(path):	
	if re.match('.*\.'+extension,file):
		name = file[0:6]
		letter = file[6]
		sample = file[7]
		img = cv2.imread(path+'/'+file)
		img = color.rgb2gray(img)
		
		fd, hog_image = hog(img,orientations = 8, pixels_per_cell=(8,8), cells_per_block=(1,1),visualise=True)
		#print list(fd)
		hog_disp = exposure.rescale_intensity(hog_image,in_range = (0,0.02))
		rowList = [file,name,letter,sample,list(fd)]
		
		hog_table.loc[i] = (rowList)
		i = i+1;
hog_table.to_csv('hogTable.csv')