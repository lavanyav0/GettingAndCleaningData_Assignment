# CodeBook for Assignment in Getting and Cleaning Data Course
Lavanya Viswanathan  
April 14, 2017  

## Assignment Summary

The peer graded assignment in the Coursera course, "Getting and Cleaning Data" requires us to keep only the variables in the input data set that are related to mean and standard deviation. As this is a subset of the variables in the input data set and the varable names in the output are long form encoding of the input variables, I have included the original description from the input data set

The variables in out_mean_data.txt are:

1) subject - the identifier for each subject in the experiment. This column can take integer values from 1 to 30

2) activity_name - a description name for each activity measured in the experiment. There are six activities: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING

3) activity_id - an integer identifier (from 1 to 6) for each of the six activities in the experiment

4) saID - a string identifier column that is the combination of subject and activity id columns

The remaining 66 columns in the output data set are named similar to the features in the input data set, as described below, in the features_info.txt file

## Input variable description, from features_info.txt

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ

tGravityAcc-XYZ

tBodyAccJerk-XYZ

tBodyGyro-XYZ

tBodyGyroJerk-XYZ

tBodyAccMag

tGravityAccMag

tBodyAccJerkMag

tBodyGyroMag

tBodyGyroJerkMag

fBodyAcc-XYZ

fBodyAccJerk-XYZ

fBodyGyro-XYZ

fBodyAccMag

fBodyAccJerkMag

fBodyGyroMag

fBodyGyroJerkMag


The set of variables that were estimated from these signals are: 

mean(): Mean value

std(): Standard deviation

