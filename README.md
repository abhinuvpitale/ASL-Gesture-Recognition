
# ASL-Gesture-Recognition

Link to the website : https://abhinuvpitale.github.io/ASL-Gesture-Recognition/

*Setup*

execute the predictWord file and then execute the 'Final Model' subsection from the runPython.m file.

*Following is a reference for the navigating through the code we've developed.*


\ASL Gesture Recognition\HoG Code ->

1. runThis.m - This is the base code which contains the pre-trained model which is executed for fingerspelling detection.

%% Model 1 - Trained only on HoG for the entire image
- This part is the initial model we trained for the entire image. It's accuracy is less due to noise present in the background of the thresholded images.

%% Feature Extraction -  used to display the various features we extraced
- This part shows features extracted from live cam feed. 
USE this for debugging.

%% Final Model - Contains the HoG trained on the boundary boxed images along with height, width and ratio features.
- This is the final code! Use this to get the best possible output. It contains word prediction code along with a better trained model for live feed.

2. LoadOSD.m - This is the file used to train the model on our dataset.
It loads the images, extracts relevant features to train a SVM classifier.
Saves the SVM classifier as .mat file to be used for testing.

3. getBoundary.m - This function extracts the boundary from the thresholded images and also gets height, width and the ratio feature which is useful for classification.

4. showFeatures.m - This gets us all the features for the training images. It also has a few PCA plots to help us select good features and help assign weights to them.

5. HogFeat.m - Used to test in-set accuracy for the trained model on different datasets for Hog and SVM classifier.

6. predictWord.py - This file is used to generate a word from the letters that are being spelled out from the FingerSpelling(runPython.m). 

7. testModels.m - This file was used as rough space to see how various models worked and to see which features worked well for our problem.

Models Present in this file ->
osdSVM - 4 letters, no augmentation
osdAugSVM - 4 letters with augmentation
osdNewLetterSVM - 9 letters, without extended feature set
boundaryOSD_SVM - 9 letters, with augmentation and extended features set.