import cv2
import numpy as np
import math
cap = cv2.VideoCapture(0)
number1 = 0
while(cap.isOpened()):
    ret, img = cap.read()
    #Original = img[100:300, 100:300]
    cv2.rectangle(img,(300,300),(100,100),(0,255,0),0)
    crop_img = img[100:300, 100:300]
    grey = cv2.cvtColor(crop_img, cv2.COLOR_BGR2GRAY)
    value = (35, 35)
    blurred = cv2.GaussianBlur(grey, value, 0)
    _, thresh1 = cv2.threshold(blurred, 127, 255,
                               cv2.THRESH_BINARY_INV+cv2.THRESH_OTSU)
    cv2.imshow('Thresholded', thresh1)
    _,contours, hierarchy = cv2.findContours(thresh1.copy(),cv2.RETR_TREE, \
            cv2.CHAIN_APPROX_NONE)
    max_area = -1
    for i in range(len(contours)):
        cnt=contours[i]
        area = cv2.contourArea(cnt)
        if(area>max_area):
            max_area=area
            ci=i
    cnt=contours[ci]
    x,y,w,h = cv2.boundingRect(cnt)
    cv2.rectangle(crop_img,(x,y),(x+w,y+h),(0,0,255),0)
    hull = cv2.convexHull(cnt)
    drawing = np.zeros(crop_img.shape,np.uint8)
    cv2.drawContours(drawing,[cnt],0,(0,255,0),0)
    cv2.drawContours(drawing,[hull],0,(0,0,255),0)

    hull = cv2.convexHull(cnt,returnPoints = False)
    hull_1 = cv2.convexHull(cnt,returnPoints = True)
    defects = cv2.convexityDefects(cnt,hull)
    count_defects = 0
    #cv2.drawContours(drawing,[defects],0,(0,0,255),0)
    cv2.drawContours(thresh1, contours, -1, (0,255,0), 3)
    for i in range(defects.shape[0]):
        s,e,f,d = defects[i,0]
        start = tuple(cnt[s][0])
        end = tuple(cnt[e][0])
        far = tuple(cnt[f][0])
        a = math.sqrt((end[0] - start[0])**2 + (end[1] - start[1])**2)
        b = math.sqrt((far[0] - start[0])**2 + (far[1] - start[1])**2)
        c = math.sqrt((end[0] - far[0])**2 + (end[1] - far[1])**2)
        angle = math.acos((b**2 + c**2 - a**2)/(2*b*c)) * 57
        if angle <= 90:
            count_defects += 1
            cv2.circle(crop_img,far,1,[0,0,255],-1)
        #dist = cv2.pointPolygonTest(cnt,far,True)
        cv2.line(crop_img,start,end,[0,255,0],2)
        moments = cv2.moments(cnt)

         #Central mass of first order moments
        if moments['m00']!=0:
            cx = int(moments['m10']/moments['m00']) # cx = M10/M00
            cy = int(moments['m01']/moments['m00']) # cy = M01/M00
        centerMass=(cx,cy)    
        #Draw center mass
        cv2.circle(crop_img,centerMass,7,[100,0,255],2)
        font = cv2.FONT_HERSHEY_SIMPLEX
        cv2.putText(crop_img,'Center',tuple(centerMass),font,2,(255,255,255),2) 

        #xx = tuple(map(tuple, hull_1[1]))
        #cv2.circle(crop_img,tuple(a,b),1,[0,255,0],2)
        #cv2.circle(crop_img,far,5,[0,0,255],-1)

         #Get fingertip points from contour hull
    #If points are in proximity of 80 pixels, consider as a single point in the group
        """finger = []
        for i in range(0,len(hull)-1):
            if (np.absolute(hull[i][0][0] - hull[i+1][0][0]) > 80) or ( np.absolute(hull[i][0][1] - hull[i+1][0][1]) > 80):
                if hull[i][0][1] <500 :
                    finger.append(hull[i][0])
        """            



    if count_defects == 1:
        cv2.putText(img,"This is 2", (50,50), cv2.FONT_HERSHEY_SIMPLEX, 2, 2)
    elif count_defects == 2:
        strung = "This is 3"
        cv2.putText(img, strung, (5,50), cv2.FONT_HERSHEY_SIMPLEX, 2, 2)
    elif count_defects == 3:
        cv2.putText(img,"This is 4", (50,50), cv2.FONT_HERSHEY_SIMPLEX, 2, 2)
    elif count_defects == 4:
        cv2.putText(img,"This is 5", (50,50), cv2.FONT_HERSHEY_SIMPLEX, 2, 2)
    else:
        cv2.putText(img,"This is 1", (50,50),\
                    cv2.FONT_HERSHEY_SIMPLEX, 2, 2)
    #cv2.imshow('drawing', drawing)
    #cv2.imshow('end', crop_img)
    cv2.imshow('Gesture', img)
    all_img = np.hstack((drawing, crop_img))
    cv2.imshow('Contours', all_img)
    _,Original = cap.read()
    cv2.imshow('Original',Original[100:300, 100:300])
    k = cv2.waitKey(10)

    if k == 27:
        break
    elif k == 83:
        number1 = number1+1
        number2 = str(number1)
        if int(number2) <= 10:
            #print hull[1][0][0]
            cv2.imwrite(r'D:\VT\Comp Vision Assignments\Project\Code25_11_17\v\thresh_b'+number2+'.jpg',thresh1)
            cv2.imwrite(r'D:\VT\Comp Vision Assignments\Project\Code25_11_17\v\original_b'+number2+'.jpg',Original[100:300, 100:300])
            f1 = open(r'.\v\v_hull.txt','a')
            f2 = open(r'.\v\v_convexity.txt','a')
            f3 = open(r'.\v\v_area.txt','a')
            f4 = open(r'.\v\v_bounding_rect.txt','a')
            #print s
            string1 = str(hull_1)
            string1 = string1.replace('[','').replace(']','')
            string1 = string1.replace('\n\n',',')
            #print string1S
            f1.write(string1)
            f1.write('\n')
            string1 = str(defects)
            string1 = string1.replace('[','').replace(']','')
            string1 = string1.replace('\n\n',',')
            f2.write(string1)
            f2.write('\n')
            #f2.write('\n'+str(s)+','+str(e)+','+str(f)+','+str(d)+'\n')
            f3.write(str(max_area)+'\n')
            f4.write(str(x)+','+str(y)+','+str(x+w)+','+str(y+h)+'\n')
            #f.write()
            f1.close()
            f2.close()
            f3.close()
        else:
            break