## Getting and Cleaning Data Course Project - Course Project
##
## - Merges the training and the test sets to create one data set.
## - Extracts only the measurements on the mean and standard deviation for each measurement. 
## - Uses descriptive activity names to name the activities in the data set
## - Appropriately labels the data set with descriptive variable names. 
## - Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
##
## - By default, Samsung data is expected to be in the working directory, unzipped ubder the folder "UCI HAR Dataset"
##     chanhe dataDir variable to pint to another folder
##
## - The script produces tity.txt


## read, subset and normalize feature names
read.features <- function(directory) {
  
  ##abs file path
  filename <- file.path(directory, "features.txt");
  msg <- paste("reading features file [", filename, "]", " ");
  message(msg)
  
  ##all features
  features <- read.table(filename, col.names = c("featureId","featureName"))
  
  ##subset for MEAN and STD
  features <- features[grep("mean\\(\\)|std", features$featureName),]
  
  ##normalize feature names
  fix.name <- function(x) {
    x <- sub("-mean", "Mean", x, ignore.case=TRUE)
    x <- sub("-std", "Std", x, ignore.case=TRUE)
    x <- sub("-", "", x, ignore.case=TRUE)
    x <- sub("\\(\\)", "", x, ignore.case=TRUE)
    x <- sub("BodyBody", "Body", x, ignore.case=TRUE)
  }
  
  features$featureName <-sapply(features$featureName, fix.name)
  
  features
}
# read and normalize activity names
read.activities <- function(directory) {
  
  ##abs file path
  filename <- file.path(directory, "activity_labels.txt");
  msg <- paste("reading activities file [", filename, "]", " ");
  message(msg)
  
  ##activities
  activities <- read.table(filename, col.names = c("activityId","activityName"))
    
  ##normalize activity names
  fix.name <- function(x) {
    x <- tolower(x)
    x <- sub("_up", "Up", x)
    x <- sub("_do", "Do", x)
  }
  activities$activityName<- sapply(activities$activityName, fix.name)
  
  activities
}

# read and normalize activity names
read.dataset <- function(directory, subname, features, activities) {

  message("reading data from [", file.path(directory, subname), "]", " ")
  
  ##X, Y and Subject
  yData <- read.table(file.path(directory, subname, paste("y_", subname, ".txt", sep="")))
  names(yData) <- c("activityId")
  ## readable activity names by ID
  yData$activityName <- activities[yData$activityId,2]
  
  sData <- read.table(file.path(directory, subname, paste("subject_", subname, ".txt", sep="")))
  names(sData) <- c("subjectId")
  
  xData <- read.table(file.path(directory, subname, paste("X_", subname, ".txt", sep="")))
  ##X for features only
  xData <- xData[,features$featureId]
  names(xData) <- features$featureName
  
  
  cbind(yData,sData,xData)
}


################## locale data ################## 
## change this to your root data dir if needed
dataFolderName <- "UCI HAR Dataset"
dataFolderPath <- getwd()
dataDir <- file.path(dataFolderPath, dataFolderName)

################## MERGE ################## 
features <- read.features(dataDir)
activities <- read.activities(dataDir)

message("merging...")

testData <- read.dataset(dataDir, "test", features, activities)
trainData <- read.dataset(dataDir, "train", features, activities)
mergedData <- rbind(testData, trainData)

################## AGGREGATE #############
message("aggregating...")

## drop string col for aggregation
mergedData$activityName = 0
aggrData = aggregate(mergedData, list(activityId = mergedData$activityId, subjectId = mergedData$subjectId), mean, na.rm=TRUE)

## drop 2 new extra cols
aggrData = aggrData[,-c(1,2)]

##labels back
aggrData$activityName <- activities[aggrData$activityId,2]

message("saving aggregated ...")
write.table(file="tidy.txt", aggrData, col.names=NA)

message("done")
