## Getting and Cleaning Data Project
#
# Creating a tidy dataset from the UCI HAR dataset
#
# by Tiago T. V. Vinhoza
# April 27, 2014
#
# This R file should be placed in the same folder where the .zip file containing the dataset was extracted
#

# Getting feature names
features <- read.table(file="features.txt",sep=" ")

# Original features were factors, so we convert them to character
cnames <- as.character(features$V2)

# Adding "subject" and "activity" as features
cnames <- c("subject",cnames,"activity")

# Renaming the features 
# 1 - Replacing "()" with "" so R does not treat mean() as calling the function mean. 
# 2 - Replacing "-" with "_" so R does not try to make a subtraction
# 3 - Replacing "BodyBody" with "Body". That was likely a typo
#
cnames <- gsub("-","_",cnames)
cnames <- gsub("\\(","",cnames)
cnames <- gsub("\\)","",cnames)
cnames <- gsub("BodyBody","Body",cnames)

# Reading the activity labels file to convert 
activity_labels <- read.table(file="activity_labels.txt",sep="")

# Reading the training dataset - 7352 rows
# 1 - Feature values (561 columns)
# 2 - Training labels (1 column)
# 3 - Training subjects (1 column)
train <- read.table(file="train/X_train.txt",sep="")
train_labels <- read.table(file="train/y_train.txt",sep="")
train_subject <- read.table(file="train/subject_train.txt",sep="")

# Merging the columns
full_train <- cbind(train_subject,train,train_labels)

# Repeating the operation with the test dataset - 2947 rows
# 1 - Feature values (561 columns)
# 2 - Test labels (1 column)
# 3 - Test subjects (1 column)
test <- read.table(file="test/X_test.txt",sep="")
test_labels <- read.table(file="test/y_test.txt",sep="")
test_subject <- read.table(file="test/subject_test.txt",sep="")

# Merging the columns
full_test <- cbind(test_subject,test,test_labels)

# Merging the "Training" and "Test" datasets
# Resulting dataset has 10299 rows and 563 columns
full_dataset <- rbind(full_train,full_test)

# Assigning the names to the columns of the full dataset
names(full_dataset) <- cnames

# Sorting the datasets by subject and by activity performed
dataset_2 <-full_dataset[order(full_dataset$subject,full_dataset$activity),]

# Putting the rownames in sequential order again
row.names(dataset_2) <- NULL 

# Converting the activity column to factor and assigning the levels from the activity_labels.txt file
dataset_2$activity <- factor(dataset_2$activity)
levels(dataset_2$activity) <- activity_labels$V2

# Selecting the columns with mean and standard deviation of the measurements
# 1 - Starting with the mean. Finding columns where the string "mean()" appears. Since in the
# col_idx_mean some columns with string "meanFreq()" were also selected, they were removed by doing 
# the setdiff operation.
col_idx_mean <- grep("mean()",names(dataset_2))
col_idx_meanFreq <- grep("meanFreq()",names(dataset_2))
col_idx_mean <- setdiff(col_idx_mean,col_idx_meanFreq)

# 2 - Getting the columns with "std()"
col_idx_std <- grep("std()",names(dataset_2))

# Creating the tidy_dataset composed of subject, activity and the columns with mean() and std()
tidy_dataset <- dataset_2[c(1,563,col_idx_mean,col_idx_std)]

# creating an "observation number" column where and putting it as the second column of the dataset.
tidy_dataset <- cbind(observation_number=0,tidy_dataset)
tidy_dataset <- tidy_dataset[c(2,1,3:69)]

# Creating a table to see the number of occurrences for each activity for each user. This is the information
# will be used to populate the "observation_number column" in the dataset
table_subject_activity <- table(tidy_dataset$subject,tidy_dataset$activity)

# Creating the second, independent tidy data set with the average of each variable for each 
#activity and each subject. This dataset will be populated in the loop below 
tidy_dataset_b <- matrix(nrow=180,ncol=68)

# Loop to populate the "observation_number" column in the first dataset and to populate the tidy_dataset_b
counter <- 0
for(ii in 1:30){
  for(jj in 1:6){
    # Filling the "observation_number" column  
    tidy_dataset$observation_number[(counter+1):((counter)+table_subject_activity[ii,jj])] <- (1:table_subject_activity[ii,jj])
    
    # Filling the "tidy_dataset_b" - First column: subject, second column: activity, other columns: mean of the 66 columns
    # that contain mean() and std().
    tidy_dataset_b[6*(ii-1)+jj,] <- c(ii,jj,apply(tidy_dataset[(counter+1):((counter)+table_subject_activity[ii,jj]),-c(1,2,3)],2,mean))
    
    counter <- counter + table_subject_activity[ii,jj]
  }
}

# Converting tidy_data_set_b to a dataframe and assigning the names for its columns
tidy_dataset_b <- data.frame(tidy_dataset_b)
names(tidy_dataset_b) <- cnames[c(1,563,col_idx_mean,col_idx_std)]

# Converting the activity column to factor and assigning the levels from the activity_labels.txt file
tidy_dataset_b$activity <- factor(tidy_dataset_b$activity)
levels(tidy_dataset_b$activity) <- activity_labels$V2

# Writing both datasets as comma separated values files
write.table(tidy_dataset,"tidy_dataset.txt", sep=",")
write.table(tidy_dataset_b,"tidy_dataset_b.txt", sep=",")

