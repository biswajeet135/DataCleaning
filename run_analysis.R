##############################################################################
#
# FILE
#   run_analysis.R
#
# OVERVIEW
#   Using data collected from the accelerometers and make a clean data set, outputting the
#   resulting tidy data to a file named "tidy_data.txt".
#

install.packages("dplyr")
library(dplyr)


##SETTING THE CURRENT WORKING DIRECTORY
path<- "C:/Users/biswajeet.a.sahoo/Documents/Data science/data cleaning"
setwd(path)

##################################################################
##GETTING DATA
##################################################################

##CHECKING IF THE ZIP FILE IS ALREADY DOWNLOADED, IF NOT THEN DOWNLOADING THE DATA FILE

zipdata <- "UCI HAR Dataset.zip"

if(!file.exists(zipdata)) {
  zipurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(zipurl, zipdata, mode = "wb")
}

##UNZIP THE FILE BY uzip COMMAND
filepath <- "UCI HAR Dataset"

if(!file.exists(filepath)) {
  unzip(zipdata)
}

##################################################################
##READUING DATA
##################################################################

##READING TRAIN DATA
trainingSubjects <- read.table(file.path(filepath, "train", "subject_train.txt"))
trainingValues <- read.table(file.path(filepath, "train", "X_train.txt"))
trainingActivity <- read.table(file.path(filepath, "train", "y_train.txt"))

##READING TEST DATA
testSubjects <- read.table(file.path(filepath, "test", "subject_test.txt"))
testValues <- read.table(file.path(filepath, "test", "X_test.txt"))
testActivity <- read.table(file.path(filepath, "test", "y_test.txt"))

##READ FEATURES AND ACTIVITY LEBELS
features <- read.table(file.path(filepath, "features.txt"),as.is = TRUE)
activities <- read.table(file.path(filepath, "activity_labels.txt"))
colnames(activities) <- c("activityId", "activityLabel")

##################################################################
##MERGING TRAIN AND TEST DATA
##################################################################

trainingdata <- cbind(trainingSubjects, trainingValues, trainingActivity)
testdata <- cbind(testSubjects, testValues, testActivity)
finaldata<- rbind(trainingdata, testdata)

colnames(finaldata) <- c("subject", features$V2, "activity")
str(finaldata)
##################################################################
##EXTRACTING ONLY MEAN AND SD DATA
##################################################################

usefulcolumns <- grepl("subject|activity|mean|std",colnames(finaldata))

finaldata <- finaldata[,usefulcolumns]

##################################################################
##Descriptive activity names to name the activities in the data
##################################################################

finaldata$activity <- factor(finaldata$activity, levels = activities[, 1], labels = activities[, 2])


##################################################################
##Appropriately label the data set with descriptive variable names
##################################################################

cols <- colnames(finaldata)

# remove special characters
cols <- gsub("[\\(\\)-]", "", cols)

#clean up names
cols <- gsub("^f", "frequencyDomain", cols)
cols <- gsub("^t", "timeDomain", cols)
cols <- gsub("Acc", "Accelerometer", cols)
cols <- gsub("Gyro", "Gyroscope", cols)
cols <- gsub("Mag", "Magnitude", cols)
cols <- gsub("Freq", "Frequency", cols)
cols <- gsub("mean", "Mean", cols)
cols <- gsub("std", "StandardDeviation", cols)

# correct typo
cols <- gsub("BodyBody", "Body", cols)

# use new labels as column names
colnames(finaldata) <- cols


###################################################################
##Create a second, independent tidy set with the average of each
##variable for each activity and each subject
###################################################################
# group by subject and activity and summarise using mean
finaldataMeans <- finaldata %>% 
  group_by(subject, activity) %>%
  summarise_all(funs(mean))

###################################################################
##WRITING FILE
###################################################################
# output to file "tidy_data.txt"
write.table(finaldata, "tidy_data.txt", row.names = FALSE, 
            quote = FALSE)
