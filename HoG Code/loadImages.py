import os
import re
import cv2
import numpy as np

path = 'C:/Courses/Computer Vision/project/Datasets/Triesch'
extension = 'pgm'
imgDict={}

#for eg -> bfritza1.pgm
#name - 'bfritz'
#letter - 'a'
#sample - '1'
#access elemets using imgDict[name][letter][sample]
for file in os.listdir(path):	
	if re.match('.*\.'+extension,file):
		name = file[0:6]
		letter = file[6]
		sample = file[7]
		if imgDict.has_key(name):
			letterDict = imgDict[name]
			if letterDict.has_key(letter):
				sampleDict = letterDict[letter]
				sampleDict[sample] = cv2.imread(path+'/'+file)
			else:
				letterDict[letter] = {sample:cv2.imread(path+'/'+file)}
		else:
			imgDict[name] = {letter:{sample:cv2.imread(path+'/'+file)}}
			
			
np.save('triesch.npy',imgDict)