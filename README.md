# Getting and Cleaning Data Project

### Creating a tidy dataset from the UCI HAR dataset

### by Tiago T. V. Vinhoza
### April 27, 2014

This repository contain the following files:

* Codebook.md - brief explanation regarding each of the attributes from the datasets.
* tidy_dataset.txt - first tidy dataset prepared.
* tidy_dataset_b.txt - second tidy datased prepared.
* getdata-projectfiles-UCI_HAR_Dataset.zip - UCI HAR dataset raw data [1].
* run_analysis.R - routine to create both tidy datasets from the raw dataset.

## Instructions
* Extract the zip file.
* The run_analysis.R file should be placed in the same folder where the .zip file containing the dataset was extracted.

## run_analysis.R explanation

### When running run_analysis.R, the following operations are done to the UCI HAR raw data:
* The files from the raw dataset are loaded.
* Get feature names from "features.txt" and convert them to character.
* Rename the features by replacing some characters. The "()" was with "" so R does not treat mean() as calling the function mean. The "-" was replaced by "_" so R does not try to make a subtraction
* Correct likely typos, for example, replacing "BodyBody" with "Body". 

* Read the training dataset - 7352 rows
  + Feature values (train/X_train.txt) (561 columns)
  + Training labels (train/y_train.txt) (1 column)
  + Training subjects (train/subject_train.txt) (1 column)
  + Add "subject" and "activity" as features.
  + Merge the columns

* Repeating the operation with the test dataset - 2947 rows
  + Feature values (test/X_test.txt) (561 columns)
  + Test labels (test/X_test.txt) (1 column)
  + Test subjects (train/subject_test.txt)(1 column)
  + Add "subject" and "activity" as features.
  + Merge the columns
  
* Merge the "Training" and "Test" datasets - Resulting dataset has 10299 rows and 563 columns
* Assigning the names to the columns of the full dataset.
* Sort the datasets by subject and by activity performed
* Convert the activity column to factor and assigning the levels from the activity_labels.txt file

* Selecting the columns with mean and standard deviation of the measurements
  + Getting columns where the string "mean()" appears. Since in the some columns with string "meanFreq()" were also selected, they were removed by doing the setdiff operation afterwards.
  + Getting the columns with the string "std()"

* Create an "observation number" to determine which reading for each user and each activity is being described in each of the rows.

* Create the *tidy_dataset.txt* file composed of subject, observation_number activity and the columns with mean() and std() - total of 69 columns.

* The routine also creates a second, independent tidy data set *(tidy_dataset_b.txt)* with the average of each variable for each activity and each subject. 

* Both txt files created are comma separated value files.

## Reference
[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012