## Call the package
library(dplyr)

## Download the given file from URL and save them into own local file MyDataset.zip 
if (!file.exists("Dataset.zip")) { 
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                destfile = "Dataset.zip")
  
  ## Unzip the file zip
  unzip("Dataset.zip")
}

# Read the txt files from the local files.
features <- read.table("UCI HAR Dataset/features.txt", header = F, stringsAsFactors = F) %>% pull(2)
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", header = F, stringsAsFactors = F) %>% pull(2)
dataTrainX <- read.table("UCI HAR Dataset/train/X_train.txt", header = F, stringsAsFactors = F)
dataTrainY <- read.table("UCI HAR Dataset/train/y_train.txt", header = F, stringsAsFactors = F)
dataTrainSubject <- read.table("UCI HAR Dataset/train/subject_train.txt", header = F, stringsAsFactors = F)
dataTestX <- read.table("UCI HAR Dataset/test/X_test.txt", header = F, stringsAsFactors = F)
dataTestY <- read.table("UCI HAR Dataset/test/y_test.txt", header = F, stringsAsFactors = F)
dataTestSubject <- read.table("UCI HAR Dataset/test/subject_test.txt", header = F, stringsAsFactors = F)

## Place X, Y and Subject in « train » / « test » data :
dataTrain<-data.frame(dataTrainSubject, dataTrainX, dataTrainY)
names(dataTrain)<-c("subject", features, "activity")
dataTest<-data.frame(dataTestSubject, dataTestX, dataTestY)
names(dataTest)<-c("subject", features, "activity")

## Create a new data set by merging training and test data
data <- rbind(dataTrain, dataTest)

## Get the mean and sd 
data_ext <- data[,which(colnames(data) %in% c("subject", "activity", grep("mean\\(\\)|std\\(\\)", colnames(data), value=TRUE)))]
str(data_ext)

## use activities in the data set
data_ext$activity <- activityLabels[data_ext$activity]
head(data_ext$activity)
tail(data_ext$activity)
summary(data_ext$activity)

## Labels in  data set with descriptive variable names.
names(data_ext)
head(data_ext)
tail(data_ext)
summary(data_ext)

names(data_ext) <- gsub("^t", "Time", names(data_ext))
names(data_ext) <- gsub("^f", "Frequency", names(data_ext))
names(data_ext) <- gsub("Acc", "Accelerometer", names(data_ext))
names(data_ext) <- gsub("Gyro", "Gyroscope", names(data_ext))
names(data_ext) <- gsub("BodyBody", "Body", names(data_ext))
names(data_ext) <- gsub("Mag", "Magnitude", names(data_ext))
names(data_ext) <- gsub("-mean\\(\\)", "-Mean", names
names(data_ext) <- gsub("-std\\(\\)", "-STD", names(data_ext))
names(data_ext)

## Create the tidy data MyTidyData from the created data set 
MyTidyData <- aggregate(. ~ subject + activity, data_ext, mean)
head(MyTidyData)
tail(MyTidyData)
summary(MyTidyData)

# Write the aoutput into MyTidyDataSet.txt  
write.table(MyTidyData, "MyTidyDataSet.txt", row.name = FALSE)

