import cv2
import numpy
import os
from numpy.linalg import inv
import math

def get_features(path1,vec):
    '''This function goes to path1, reads all the images present there,
    downsizes them to 32x32, expands the image into a 1D array,appends 
    all the feature vectors and returns the list of all feature vectors'''
    listing = os.listdir(path1)
    del listing[-1]
    for file in listing:
        img = cv2.imread(path1 + '/' + file)
        img = cv2.cvtColor( img, cv2.COLOR_RGB2GRAY )
        img = cv2.resize(img,(32, 32))
        arr=numpy.reshape(img, (numpy.product(img.shape),))
        #Division by 10 to prevent det(cov)from going to infinity
        arr=numpy.divide(arr,10) 
        vec.append(arr)  
    return

'''Functions g1, g2 and g3 are discriminant functions for models 1,2 and 3 
respectively. They have been optimized for that particular model'''
def g1(x,u,covinv,detcov):  
    a=x-u
    d=numpy.dot(a,covinv)
    e=numpy.dot(d,a.reshape(vec_size,1))
    ans=(-0.5*e)-(0.5*detcov)    
    return ans

def g2(x,u,covinv):
    diff=x-u
    d=numpy.dot(diff[None],covinv)
    d=numpy.dot(d,diff[:,None])
    return -1*d
        
def g3(x,u):
    diff=x-u
    d=numpy.dot(diff[None],diff[:,None])
    return -1*d
 
'''test1, test2 and test3 are the test functions which extract the test images 
from the given path, check which class they belong to and store the results in a file.
Since class labels are known, accuracy is also printed '''
def test1(u,covinv,covdet,file_name):
    
    test_path='TestCharacters/TestCharacters'
    class_lab=[]
    class_lab.append('1')
    class_lab.append('2')
    class_lab.append('3')
    
    'test_result=[]'
    for i in range (3):
        count=0.0
        path=test_path+'/'+class_lab[i]
        f= open(file_name+'_'+class_lab[i],"w+")
        f.write("Predicted labels\n")
        listing = os.listdir(path)
        del listing[-1]
        for file in listing:
            img = cv2.imread(path + '/' + file)
            img = cv2.cvtColor( img, cv2.COLOR_RGB2GRAY )
            img = cv2.resize(img,(32, 32))
            arr=numpy.reshape(img, (numpy.product(img.shape),))
            arr=numpy.divide(arr,10)
            max_class=0
            max_val=g1(arr,u[0],covinv[0],covdet[0])
            for j in range(1,3):
                r=g1(arr,u[j],covinv[j],covdet[j])
                if r>max_val:
                    max_class=j
                    max_val=r
            f.write(" %d\n" % max_class)
            #print(max_class)
            if (max_class==i):
                count+=1.0
            #print max_class
        print(count)
        f.close()
    

def test2(u,covinv,file_name):
    
    test_path='TestCharacters/TestCharacters'
    class_lab=[]
    class_lab.append('1')
    class_lab.append('2')
    class_lab.append('3')
    
    'test_result=[]'
    for i in range (3):
        count=0.0
        path=test_path+'/'+class_lab[i]
        f= open(file_name+'_'+class_lab[i],"w+")
        f.write("Predicted labels\n")
        listing = os.listdir(path)
        del listing[-1]
        for file in listing:
            img = cv2.imread(path + '/' + file)
            img = cv2.cvtColor( img, cv2.COLOR_RGB2GRAY )
            img = cv2.resize(img,(32, 32))
            arr=numpy.reshape(img, (numpy.product(img.shape),))
            arr=numpy.divide(arr,10.0)
            max_class=0
            max_val=g2(arr,u[0],covinv)
            for j in range(1,3):
                r=g2(arr,u[j],covinv)
                if r>max_val:
                    max_class=j
                    max_val=r
            f.write(" %d\n" % max_class)
            if (max_class==i):
                count+=1.0
            #print max_class
        print(count)
        f.close()    

def test3(u,file_name):
   
    test_path='TestCharacters/TestCharacters'
    class_lab=[]
    class_lab.append('1')
    class_lab.append('2')
    class_lab.append('3')
    
    'test_result=[]'
    for i in range (3):
        count=0.0
        path=test_path+'/'+class_lab[i]
        f= open(file_name+'_'+class_lab[i],"w+")
        f.write("Predicted labels\n")
        listing = os.listdir(path)
        del listing[-1]
        for file in listing:
            img = cv2.imread(path + '/' + file)
            img = cv2.cvtColor( img, cv2.COLOR_RGB2GRAY )
            img = cv2.resize(img,(32, 32))
            arr=numpy.reshape(img, (numpy.product(img.shape),))
            arr=numpy.divide(arr,10)
            max_class=0
            max_val=g3(arr,u[0])
            for j in range(1,3):
                r=g3(arr,u[j])
                if r>max_val:
                    max_class=j
                    max_val=r
            f.write(" %d\n" % max_class)
            if (max_class==i):
                count+=1.0
            max_class
        print(count)
        f.close()
  

im_size=32
vec_size=im_size*im_size
training_path='TrainCharacters'


class_lab=[]
class_lab.append('1')
class_lab.append('2')
class_lab.append('3')


'for getting feature vectors for each class'
feat_vec=[[],[],[]]
for i in range (3):
    path=training_path+'/'+class_lab[i]
    get_features(path,feat_vec[i])

'for computing mean of each class'
u=numpy.zeros((3,vec_size))
for i in range(3):
    for j in range(200):
        u[i]+=feat_vec[i][j]
    u[i]/=200 

'Three different modelling schemes for computing cov matrix'
'1. cov = identity matrix for all classes'   

'2. Assuming common diagonal covariance matrix for all classes'
cov2=[]
comb=feat_vec[0]+ feat_vec[1]+ feat_vec[2]
a=numpy.cov(numpy.transpose(comb))
cov2=0.5*numpy.identity(vec_size)

for i in range(vec_size):
    cov2[i][i]+=a[i][i]


'3. The samples of each class are modelled by a separate covariance matrix'
cov3=[[],[],[]]
covinv=[[],[],[]]
covdet=[[],[],[]]

cov3[0]=numpy.identity(vec_size)+0.5*numpy.cov(numpy.transpose(feat_vec[0]))
cov3[1]=numpy.identity(vec_size)+0.5*numpy.cov(numpy.transpose(feat_vec[1]))
cov3[2]=numpy.identity(vec_size)+0.5*numpy.cov(numpy.transpose(feat_vec[2]))
'Inverses are computed and stored'
covinv[0]=inv(cov3[0])
covinv[1]=inv(cov3[1])
covinv[2]=inv(cov3[2])
'Determinants are computed and stored'
covdet[0]=math.log(numpy.linalg.det(cov3[0]))
covdet[1]=math.log(numpy.linalg.det(cov3[1]))
covdet[2]=math.log(numpy.linalg.det(cov3[2]))

'Test for each model'
test1(u,covinv,covdet,"test_independent_cov")
test2(u,cov2,"test_pooled_cov")
test3(u,"test_identity_cov")

