# Submission for Course Project

First of all, we must download the data and store it in a folder, we'll call it /data

The dataset is in .zip format, so we unzip the file

We should see what's inside this data directory, one way is to list the files:

Looking the content of the files, we can see the relations between them, and we conclude
that we'll use Activity, Subject and Features as part of descriptive variable names for data 
in data frame

Read the Activity, Subject and features

Looking at the properties of the above varibles with str(), we can start merging the data
First, concatenate the data tables by rows

Then, set names to variables

Last, merge columns to get the data frame Data for all data

With the data merged, we will extract the mean and the standard deviation for each
measurement

Subset the data frame Data by seleted names of Features

We'll check the data with str(Data)

To tidy the labels, we'll read the activity_labels.txt in the folder

Now knowing the full variable names, proceed to substitute with gsub()

Now we finished tidy the data, proceed to output it with the average
for each activity and each subject. We'll use write.table in plyr package

Getting plyr

Calculating mean and outputting with write.table
