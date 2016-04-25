#First of all, we must download the data and store it in a folder, we'll call it /data
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")

#The dataset is in .zip format, so we unzip the file
unzip(zipfile="./data/Dataset.zip")

#We should see what's inside this data directory, one way is to list the files:
path_rf <- file.path("./data" , "UCI HAR Dataset")
files <- list.files(path_rf, recursive=TRUE)
files

#Looking the content of the files, we can see the relations between them, and we conclude
#that we'll use Activity, Subject and Features as part of descriptive variable names for data 
#in data frame

#Read the Activity files

dataActivityTest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)

#Read the Subject files

dataSubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)

#Read Fearures files

dataFeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)

#Looking at the properties of the above varibles with str(), we can start merging the data
#First, oncatenate the data tables by rows

dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)

#Then, set names to variables

names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2

#Last, merge columns to get the data frame Data for all data

dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

#Now we have the data merged, we will extract the mean and the standard deviation for each
#measurement by subset Name of Features by measurements on the mean and standard deviation
#i.e taken Names of Features with “mean()” or “std()”

subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

#Subset the data frame Data by seleted names of Features
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)

#We'll check the data with str(Data)
str(Data)

#To tidy the labels, we'll read the activity_labels.txt in the folder
activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)

#Now knowing the full variable names, proceed to substitute with gsub()
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "accelerometer", names(Data))
names(Data)<-gsub("Gyro", "gyroscope", names(Data))
names(Data)<-gsub("Mag", "magnitude", names(Data))
names(Data)<-gsub("BodyBody", "body", names(Data))

#Now we finished tidy the data, proceed to output it with the average
#for each activity and each subject. We'll use write.table in plyr package
#Getting plyr
install.packages("plyr")
library(plyr)

#Calculating mean and outputting
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "TheDataClean.txt",row.name=FALSE)

