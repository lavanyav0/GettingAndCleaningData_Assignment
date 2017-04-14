library(plyr)
library(dplyr)

## read and concatenate the raw training and test data sets

raw_x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
raw_x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
raw_x <- rbind(raw_x_train,raw_x_test)

## assign column names to the 561 columns in the raw dataset
## after extracting only the columns for mean and standard deviation

features <- read.table("UCI HAR Dataset/features.txt")
mean_std_features_id <- grep("mean[[:punct:](]|std",features$V2)
mean_std_features <- features$V2[mean_std_features_id]
mean_std_features <- sapply(mean_std_features,function(x) gsub("__","",gsub("___","_",gsub("[[:punct:]()]","_",x))))
x <- raw_x[,mean_std_features_id]
names(x) <- mean_std_features

## add columns for subject and activity

subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
subject <- rbind(subject_train,subject_test)
names(subject) <- c("subject")

raw_y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
raw_y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
raw_y <- rbind(raw_y_train,raw_y_test)
names(raw_y) <- c("activity_id")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
names(activity_labels) <- c("activity_id","activity_name")
activity <- left_join(raw_y,activity_labels,by="activity_id")

data <- cbind(subject,activity) %>% mutate(saID=paste(subject,activity_id,sep="_"))
data <- cbind(data,x)

## calculate averages by subject and activity

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

## write the output data set to file

write.table(mean_data,"out_mean_data.txt")