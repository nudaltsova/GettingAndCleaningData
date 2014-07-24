# CodeBook

This code book describes variables, data transformations and work 
performed on the raw data set to clean it up as per assignment requirements. 


* Original data: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

* Original data code book : http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Sections below do not describe data but only changes made, please refer to original cook book for detailed description of data

## Transformations
The target of the ercersise was to merge data from various files and data sets (merge both vertically and horizontally) and select a subset of features as per specified pattern; The resulting data set was then averaged by sme features


Detailed Steps:

1. Read features file, subset only those matching 'mean' or 'std'

2. Normalize feature names

3. Read activities file

4. Normalize activities names

5. Read 'test' dataset: y_test -> activityId; subject_test -> subjectId; x_test -> feature measures
  
6. Subset feature measures by feature name (see step 1)

7. Merge (vertically, cbind) y_test, activities, subject_test and subset of feature measures

8. Repeat 5-7 for train dataset

9. Merge (horizontally, rbind) test and train datasets

10. Aggregate merged data by activity and subject

## Normalized Names

The following normalization was applied:

* dash removed: **yy-X** -> to *yyX*

* brackets removed: **yyy()** -> *yyy*

* duplicates removed: **YyyYyy** -> *Yyy*

* lowercasing: **YYY** -> *yyy*


