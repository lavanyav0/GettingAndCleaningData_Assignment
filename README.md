# Assignment in Getting and Cleaning Data Course
Lavanya Viswanathan  
April 14, 2017  

## Assignment Summary

The peer graded assignment in the Coursera course, "Getting and Cleaning Data" requires us to demonstrate that we can download and combine data from different pieces in the provided input, add meaningful column names and metrics, and create a tidy data set as the output.

These files have been submitted for the assignment:

1) README.md - this page, with a complete description of what was done for the assignment

2) run_analysis.R - has the R code for the assignment

3) CodeBook.md - describes the variables in the output and what they mean

4) out_mean_data.txt - which contains the output tidy data set for this assignment

5) features_info.txt - this was included in the downloaded input and has the best explanation of the meaning of the accelerometer and gyroscope variables in the output tidy data set. It is included here for completeness

## Read and concatenate the raw training and test data sets

The first step is to read the input data set after downloading it using the instructions given on the course website. As per the instructions provided in the README.txt file in the zip file, readings from the sensor signals (accelerometer and gyroscope) are stored in X_train.txt and X_test.txt. The combined raw dataset has 10299 rows and 561 columns, but it has no information telling us which subjects or activities each row corresponds to, or what the column names (variables) are.


```r
library(plyr)
```

```
## Warning: package 'plyr' was built under R version 3.3.3
```

```r
library(dplyr)
```

```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:plyr':
## 
##     arrange, count, desc, failwith, id, mutate, rename, summarise,
##     summarize
```

```
## The following objects are masked from 'package:stats':
## 
##     filter, lag
```

```
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```r
raw_x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
raw_x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
raw_x <- rbind(raw_x_train,raw_x_test)
dim(raw_x)
```

```
## [1] 10299   561
```

## Load only mean and standard deviation measurements, and label the data set with descriptive variable names

To assign meaningful variable names, we have to load the column names from features.txt. A regular expression search allows us to keep only the measurements that correspond to mean and standard deviations. The resulting data set (x) now has descriptive column names, that are consistent with the long form of the original naming convention in the features_info.txt in the input download. Note that the assignment rubric allows us to keep the long form of these variable names.

The data set at this stage still has 10299 rows, but only 66 columns.


```r
features <- read.table("UCI HAR Dataset/features.txt")
mean_std_features_id <- grep("mean[[:punct:](]|std",features$V2)
mean_std_features <- features$V2[mean_std_features_id]
mean_std_features <- sapply(mean_std_features,function(x) gsub("__","",gsub("___","_",gsub("[[:punct:]()]","_",x))))
x <- raw_x[,mean_std_features_id]
names(x) <- mean_std_features
dim(x)
```

```
## [1] 10299    66
```


## Add subject and activity

Now it's time to add information on which subject and activities each row in the data set corresponds to. 

First, we read the subject ids for each row from the subject_train.txt and subject_test.txt files. There are 30 subjects in this experiment, so we check that there are 30 unique subject ids in this column


```r
## read subject id for each row
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
subject <- rbind(subject_train,subject_test)
names(subject) <- c("subject")
unique(subject) %>% arrange(subject)
```

```
##    subject
## 1        1
## 2        2
## 3        3
## 4        4
## 5        5
## 6        6
## 7        7
## 8        8
## 9        9
## 10      10
## 11      11
## 12      12
## 13      13
## 14      14
## 15      15
## 16      16
## 17      17
## 18      18
## 19      19
## 20      20
## 21      21
## 22      22
## 23      23
## 24      24
## 25      25
## 26      26
## 27      27
## 28      28
## 29      29
## 30      30
```

Activities have to be added in two steps. The activity ids for each row are in y_train.txt and y_test.txt. This has to be joined with the map from activity id to activity name in activity_labels.txt. After the join, we check that there are six unique activity ids and activity names.


```r
## read activity_id and activity_name
raw_y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
raw_y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
raw_y <- rbind(raw_y_train,raw_y_test)
names(raw_y) <- c("activity_id")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
names(activity_labels) <- c("activity_id","activity_name")
activity <- left_join(raw_y,activity_labels,by="activity_id")
unique(activity) %>% arrange(activity_id)
```

```
##   activity_id      activity_name
## 1           1            WALKING
## 2           2   WALKING_UPSTAIRS
## 3           3 WALKING_DOWNSTAIRS
## 4           4            SITTING
## 5           5           STANDING
## 6           6             LAYING
```

Now we are ready to combine the subject column, the activity columns and the main data set. We create a new column that combines the subject id with the activity id. This will be used later to calculate averages by subject and activity. We now have 10299 rows and 70 columns


```r
## add subject and activity columns to the data set
data <- cbind(subject,activity) %>% mutate(saID=paste(subject,activity_id,sep="_"))
data <- cbind(data,x)
dim(data)
```

```
## [1] 10299    70
```

```r
str(data)
```

```
## 'data.frame':	10299 obs. of  70 variables:
##  $ subject                  : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ activity_id              : int  5 5 5 5 5 5 5 5 5 5 ...
##  $ activity_name            : Factor w/ 6 levels "LAYING","SITTING",..: 3 3 3 3 3 3 3 3 3 3 ...
##  $ saID                     : chr  "1_5" "1_5" "1_5" "1_5" ...
##  $ tBodyAcc_mean_X          : num  0.289 0.278 0.28 0.279 0.277 ...
##  $ tBodyAcc_mean_Y          : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
##  $ tBodyAcc_mean_Z          : num  -0.133 -0.124 -0.113 -0.123 -0.115 ...
##  $ tBodyAcc_std_X           : num  -0.995 -0.998 -0.995 -0.996 -0.998 ...
##  $ tBodyAcc_std_Y           : num  -0.983 -0.975 -0.967 -0.983 -0.981 ...
##  $ tBodyAcc_std_Z           : num  -0.914 -0.96 -0.979 -0.991 -0.99 ...
##  $ tGravityAcc_mean_X       : num  0.963 0.967 0.967 0.968 0.968 ...
##  $ tGravityAcc_mean_Y       : num  -0.141 -0.142 -0.142 -0.144 -0.149 ...
##  $ tGravityAcc_mean_Z       : num  0.1154 0.1094 0.1019 0.0999 0.0945 ...
##  $ tGravityAcc_std_X        : num  -0.985 -0.997 -1 -0.997 -0.998 ...
##  $ tGravityAcc_std_Y        : num  -0.982 -0.989 -0.993 -0.981 -0.988 ...
##  $ tGravityAcc_std_Z        : num  -0.878 -0.932 -0.993 -0.978 -0.979 ...
##  $ tBodyAccJerk_mean_X      : num  0.078 0.074 0.0736 0.0773 0.0734 ...
##  $ tBodyAccJerk_mean_Y      : num  0.005 0.00577 0.0031 0.02006 0.01912 ...
##  $ tBodyAccJerk_mean_Z      : num  -0.06783 0.02938 -0.00905 -0.00986 0.01678 ...
##  $ tBodyAccJerk_std_X       : num  -0.994 -0.996 -0.991 -0.993 -0.996 ...
##  $ tBodyAccJerk_std_Y       : num  -0.988 -0.981 -0.981 -0.988 -0.988 ...
##  $ tBodyAccJerk_std_Z       : num  -0.994 -0.992 -0.99 -0.993 -0.992 ...
##  $ tBodyGyro_mean_X         : num  -0.0061 -0.0161 -0.0317 -0.0434 -0.034 ...
##  $ tBodyGyro_mean_Y         : num  -0.0314 -0.0839 -0.1023 -0.0914 -0.0747 ...
##  $ tBodyGyro_mean_Z         : num  0.1077 0.1006 0.0961 0.0855 0.0774 ...
##  $ tBodyGyro_std_X          : num  -0.985 -0.983 -0.976 -0.991 -0.985 ...
##  $ tBodyGyro_std_Y          : num  -0.977 -0.989 -0.994 -0.992 -0.992 ...
##  $ tBodyGyro_std_Z          : num  -0.992 -0.989 -0.986 -0.988 -0.987 ...
##  $ tBodyGyroJerk_mean_X     : num  -0.0992 -0.1105 -0.1085 -0.0912 -0.0908 ...
##  $ tBodyGyroJerk_mean_Y     : num  -0.0555 -0.0448 -0.0424 -0.0363 -0.0376 ...
##  $ tBodyGyroJerk_mean_Z     : num  -0.062 -0.0592 -0.0558 -0.0605 -0.0583 ...
##  $ tBodyGyroJerk_std_X      : num  -0.992 -0.99 -0.988 -0.991 -0.991 ...
##  $ tBodyGyroJerk_std_Y      : num  -0.993 -0.997 -0.996 -0.997 -0.996 ...
##  $ tBodyGyroJerk_std_Z      : num  -0.992 -0.994 -0.992 -0.993 -0.995 ...
##  $ tBodyAccMag_mean         : num  -0.959 -0.979 -0.984 -0.987 -0.993 ...
##  $ tBodyAccMag_std          : num  -0.951 -0.976 -0.988 -0.986 -0.991 ...
##  $ tGravityAccMag_mean      : num  -0.959 -0.979 -0.984 -0.987 -0.993 ...
##  $ tGravityAccMag_std       : num  -0.951 -0.976 -0.988 -0.986 -0.991 ...
##  $ tBodyAccJerkMag_mean     : num  -0.993 -0.991 -0.989 -0.993 -0.993 ...
##  $ tBodyAccJerkMag_std      : num  -0.994 -0.992 -0.99 -0.993 -0.996 ...
##  $ tBodyGyroMag_mean        : num  -0.969 -0.981 -0.976 -0.982 -0.985 ...
##  $ tBodyGyroMag_std         : num  -0.964 -0.984 -0.986 -0.987 -0.989 ...
##  $ tBodyGyroJerkMag_mean    : num  -0.994 -0.995 -0.993 -0.996 -0.996 ...
##  $ tBodyGyroJerkMag_std     : num  -0.991 -0.996 -0.995 -0.995 -0.995 ...
##  $ fBodyAcc_mean_X          : num  -0.995 -0.997 -0.994 -0.995 -0.997 ...
##  $ fBodyAcc_mean_Y          : num  -0.983 -0.977 -0.973 -0.984 -0.982 ...
##  $ fBodyAcc_mean_Z          : num  -0.939 -0.974 -0.983 -0.991 -0.988 ...
##  $ fBodyAcc_std_X           : num  -0.995 -0.999 -0.996 -0.996 -0.999 ...
##  $ fBodyAcc_std_Y           : num  -0.983 -0.975 -0.966 -0.983 -0.98 ...
##  $ fBodyAcc_std_Z           : num  -0.906 -0.955 -0.977 -0.99 -0.992 ...
##  $ fBodyAccJerk_mean_X      : num  -0.992 -0.995 -0.991 -0.994 -0.996 ...
##  $ fBodyAccJerk_mean_Y      : num  -0.987 -0.981 -0.982 -0.989 -0.989 ...
##  $ fBodyAccJerk_mean_Z      : num  -0.99 -0.99 -0.988 -0.991 -0.991 ...
##  $ fBodyAccJerk_std_X       : num  -0.996 -0.997 -0.991 -0.991 -0.997 ...
##  $ fBodyAccJerk_std_Y       : num  -0.991 -0.982 -0.981 -0.987 -0.989 ...
##  $ fBodyAccJerk_std_Z       : num  -0.997 -0.993 -0.99 -0.994 -0.993 ...
##  $ fBodyGyro_mean_X         : num  -0.987 -0.977 -0.975 -0.987 -0.982 ...
##  $ fBodyGyro_mean_Y         : num  -0.982 -0.993 -0.994 -0.994 -0.993 ...
##  $ fBodyGyro_mean_Z         : num  -0.99 -0.99 -0.987 -0.987 -0.989 ...
##  $ fBodyGyro_std_X          : num  -0.985 -0.985 -0.977 -0.993 -0.986 ...
##  $ fBodyGyro_std_Y          : num  -0.974 -0.987 -0.993 -0.992 -0.992 ...
##  $ fBodyGyro_std_Z          : num  -0.994 -0.99 -0.987 -0.989 -0.988 ...
##  $ fBodyAccMag_mean         : num  -0.952 -0.981 -0.988 -0.988 -0.994 ...
##  $ fBodyAccMag_std          : num  -0.956 -0.976 -0.989 -0.987 -0.99 ...
##  $ fBodyBodyAccJerkMag_mean : num  -0.994 -0.99 -0.989 -0.993 -0.996 ...
##  $ fBodyBodyAccJerkMag_std  : num  -0.994 -0.992 -0.991 -0.992 -0.994 ...
##  $ fBodyBodyGyroMag_mean    : num  -0.98 -0.988 -0.989 -0.989 -0.991 ...
##  $ fBodyBodyGyroMag_std     : num  -0.961 -0.983 -0.986 -0.988 -0.989 ...
##  $ fBodyBodyGyroJerkMag_mean: num  -0.992 -0.996 -0.995 -0.995 -0.995 ...
##  $ fBodyBodyGyroJerkMag_std : num  -0.991 -0.996 -0.995 -0.995 -0.995 ...
```

## Calculate averages by subject and activity

The final step is to calculate the average of each variable for each subject and each activity. This results in a tidy data set that has 30 * 6 = 180 rows and 70 columns, significantly smaller and easier to read and understand than the original raw data set.


```r
by_subject_activity <- group_by(data,subject,activity_name)
mean_data <- summarise(by_subject_activity,activity_id = mean(activity_id))
mean_data <- mean_data %>% mutate(saID=paste(subject,activity_id,sep="_"))
for(x in mean_std_features) {
  t <- tapply(as.vector(data[,x]),data$saID,mean)
  t <- data.frame(names(t),as.vector(t))
  names(t) <- c("saID",x)
  t$saID <- as.character(t$saID)
  mean_data <- left_join(mean_data,t,by="saID")
}
mean_data <- arrange(mean_data,subject,activity_id)
mean_data
```

```
## Source: local data frame [180 x 70]
## Groups: subject [30]
## 
##    subject      activity_name activity_id  saID tBodyAcc_mean_X
##      <int>             <fctr>       <dbl> <chr>           <dbl>
## 1        1            WALKING           1   1_1       0.2773308
## 2        1   WALKING_UPSTAIRS           2   1_2       0.2554617
## 3        1 WALKING_DOWNSTAIRS           3   1_3       0.2891883
## 4        1            SITTING           4   1_4       0.2612376
## 5        1           STANDING           5   1_5       0.2789176
## 6        1             LAYING           6   1_6       0.2215982
## 7        2            WALKING           1   2_1       0.2764266
## 8        2   WALKING_UPSTAIRS           2   2_2       0.2471648
## 9        2 WALKING_DOWNSTAIRS           3   2_3       0.2776153
## 10       2            SITTING           4   2_4       0.2770874
## # ... with 170 more rows, and 65 more variables: tBodyAcc_mean_Y <dbl>,
## #   tBodyAcc_mean_Z <dbl>, tBodyAcc_std_X <dbl>, tBodyAcc_std_Y <dbl>,
## #   tBodyAcc_std_Z <dbl>, tGravityAcc_mean_X <dbl>,
## #   tGravityAcc_mean_Y <dbl>, tGravityAcc_mean_Z <dbl>,
## #   tGravityAcc_std_X <dbl>, tGravityAcc_std_Y <dbl>,
## #   tGravityAcc_std_Z <dbl>, tBodyAccJerk_mean_X <dbl>,
## #   tBodyAccJerk_mean_Y <dbl>, tBodyAccJerk_mean_Z <dbl>,
## #   tBodyAccJerk_std_X <dbl>, tBodyAccJerk_std_Y <dbl>,
## #   tBodyAccJerk_std_Z <dbl>, tBodyGyro_mean_X <dbl>,
## #   tBodyGyro_mean_Y <dbl>, tBodyGyro_mean_Z <dbl>, tBodyGyro_std_X <dbl>,
## #   tBodyGyro_std_Y <dbl>, tBodyGyro_std_Z <dbl>,
## #   tBodyGyroJerk_mean_X <dbl>, tBodyGyroJerk_mean_Y <dbl>,
## #   tBodyGyroJerk_mean_Z <dbl>, tBodyGyroJerk_std_X <dbl>,
## #   tBodyGyroJerk_std_Y <dbl>, tBodyGyroJerk_std_Z <dbl>,
## #   tBodyAccMag_mean <dbl>, tBodyAccMag_std <dbl>,
## #   tGravityAccMag_mean <dbl>, tGravityAccMag_std <dbl>,
## #   tBodyAccJerkMag_mean <dbl>, tBodyAccJerkMag_std <dbl>,
## #   tBodyGyroMag_mean <dbl>, tBodyGyroMag_std <dbl>,
## #   tBodyGyroJerkMag_mean <dbl>, tBodyGyroJerkMag_std <dbl>,
## #   fBodyAcc_mean_X <dbl>, fBodyAcc_mean_Y <dbl>, fBodyAcc_mean_Z <dbl>,
## #   fBodyAcc_std_X <dbl>, fBodyAcc_std_Y <dbl>, fBodyAcc_std_Z <dbl>,
## #   fBodyAccJerk_mean_X <dbl>, fBodyAccJerk_mean_Y <dbl>,
## #   fBodyAccJerk_mean_Z <dbl>, fBodyAccJerk_std_X <dbl>,
## #   fBodyAccJerk_std_Y <dbl>, fBodyAccJerk_std_Z <dbl>,
## #   fBodyGyro_mean_X <dbl>, fBodyGyro_mean_Y <dbl>,
## #   fBodyGyro_mean_Z <dbl>, fBodyGyro_std_X <dbl>, fBodyGyro_std_Y <dbl>,
## #   fBodyGyro_std_Z <dbl>, fBodyAccMag_mean <dbl>, fBodyAccMag_std <dbl>,
## #   fBodyBodyAccJerkMag_mean <dbl>, fBodyBodyAccJerkMag_std <dbl>,
## #   fBodyBodyGyroMag_mean <dbl>, fBodyBodyGyroMag_std <dbl>,
## #   fBodyBodyGyroJerkMag_mean <dbl>, fBodyBodyGyroJerkMag_std <dbl>
```

## Save tidy data set to file

The last step is to save the output tidy data set to a text file.


```r
write.table(mean_data,"out_mean_data.txt")
```
