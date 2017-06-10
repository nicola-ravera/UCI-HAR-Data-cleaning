Week 4 cleaning data course assignment - Human Activity Recognition Using Smartphones Dataset
===========================================

## Raw data


Here are the raw data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The raw data have been worked to create a new dataset by the following steps:

- 0. Reading raw data

```R
# read train files
    subjtrain <- read.table(file.path(dataPath,"train","subject_train.txt"))
    measurestrain <- read.table(file.path(dataPath,"train","X_train.txt"))
    labeltrain <- read.table(file.path(dataPath,"train","y_train.txt"))
    
    # read test files
    subjtest <- read.table(file.path(dataPath,"test","subject_test.txt"))
    measurestest <- read.table(file.path(dataPath,"test","X_test.txt"))
    labeltest <- read.table(file.path(dataPath,"test","y_test.txt"))
```

- 1. Merging the training and the test sets to create one data set.

```R
 # merge train data frames into one
    train <- cbind(measurestrain,labeltrain,subjtrain)
    
    # merge test data frames into one
    test <- cbind(measurestest,labeltest,subjtest)
    
    # merge test and train rows into one data set
    measures <- rbind(train,test)
```

- 2. Extracting only the measurements on the mean and standard deviation for each measurement.
- 3. Using descriptive activity names to name the activities in the data set
- 4. Appropriately labeling the data set with descriptive variable names.


## All the variables used to create one data set: 68 of 563 original

-   tbodyaccmeanx                    : num  
-   tbodyaccmeany                    : num  
-   tbodyaccmeanz                    : num  
-   tbodyaccstdx                     : num  
-   tbodyaccstdy                     : num  
-   tbodyaccstdz                     : num  
-   tgravityaccmeanx                 : num  
-   tgravityaccmeany                 : num  
-   tgravityaccmeanz                 : num  
-   tgravityaccstdx                  : num  
-   tgravityaccstdy                  : num  
-   tgravityaccstdz                  : num  
-   tbodyaccjerkmeanx                : num  
-   tbodyaccjerkmeany                : num  
-   tbodyaccjerkmeanz                : num  
-   tbodyaccjerkstdx                 : num  
-   tbodyaccjerkstdy                 : num  
-   tbodyaccjerkstdz                 : num  
-   tbodygyromeanx                   : num  
-   tbodygyromeany                   : num  
-   tbodygyromeanz                   : num  
-   tbodygyrostdx                    : num  
-   tbodygyrostdy                    : num  
-   tbodygyrostdz                    : num  
-   tbodygyrojerkmeanx               : num  
-   tbodygyrojerkmeany               : num  
-   tbodygyrojerkmeanz               : num  
-   tbodygyrojerkstdx                : num  
-   tbodygyrojerkstdy                : num  
-   tbodygyrojerkstdz                : num  
-   tbodyaccmagmean                  : num  
-   tbodyaccmagstd                   : num  
-   tgravityaccmagmean               : num  
-   tgravityaccmagstd                : num  
-   tbodyaccjerkmagmean              : num  
-   tbodyaccjerkmagstd               : num  
-   tbodygyromagmean                 : num  
-   tbodygyromagstd                  : num  
-   tbodygyrojerkmagmean             : num  
-   tbodygyrojerkmagstd              : num  
-   fbodyaccmeanx                    : num  
-   fbodyaccmeany                    : num  
-   fbodyaccmeanz                    : num  
-   fbodyaccstdx                     : num  
-   fbodyaccstdy                     : num  
-   fbodyaccstdz                     : num  
-   fbodyaccjerkmeanx                : num  
-   fbodyaccjerkmeany                : num  
-   fbodyaccjerkmeanz                : num  
-   fbodyaccjerkstdx                 : num  
-   fbodyaccjerkstdy                 : num  
-   fbodyaccjerkstdz                 : num  
-   fbodygyromeanx                   : num  
-   fbodygyromeany                   : num  
-   fbodygyromeanz                   : num  
-   fbodygyrostdx                    : num  
-   fbodygyrostdy                    : num  
-   fbodygyrostdz                    : num  
-   fbodyaccmagmean                  : num  
-   fbodyaccmagstd                   : num  
-   fbodybodyaccjerkmagmean          : num  
-   fbodybodyaccjerkmagstd           : num  
-   fbodybodygyromagmean             : num  
-   fbodybodygyromagstd              : num  
-   fbodybodygyrojerkmagmean         : num  
-   fbodybodygyrojerkmagstd          : num  
-   subject                          : int  
-   activity                         : Factor w/ 6 levels 

humanactivity contains:

- 1 WALKING
- 2 WALKING_UPSTAIRS
- 3 WALKING_DOWNSTAIRS
- 4 SITTING
- 5 STANDING
- 6 LAYING

Each other variable has on obvious matching variable in the original dataset.
Features_info.txt and features.txt show information about the variables used.


## Tidy data
Criteria used for tidy data are:

- Extracts only the measurements on the mean and standard deviation for each measurement
```R
  meanstdvariables <- grep("(mean\\.\\.|std\\.\\.)",names(measures))
```

- Uses descriptive activity names to name the activities in the data set
```R
 # get activities from txt file
    activities <- read.table(file.path(dataPath,"activity_labels.txt"))
    
    # lookup activity number vs activities table and update the data set
    meanstdmeasures$activity <- sapply(meanstdmeasures$activity,
                                 function(x){ 
                                        as.character(activities[activities$V1==x,][[2]])
                              })
```

- Appropriately labels the data set with descriptive variable names.
```R
    names(meanstdmeasures) <- gsub("\\.","",tolower(names(meanstdmeasures)))
```
Names variables are lower case, descriptive, non duplicated and not have underscores or dots or white spaces


- Create tidy data set with the average of each variable for each activity and each subject.
```R
    tidy <- aggregate(.~ subject + activity,data=meanstdmeasures, FUN = "mean")
```

## Other relevant information
Tidy data set as a txt file

Created with 
```R
  write.table(tidy,file=tidyFile,row.names = F)
```
Read with 
```R
  read.table(tidyFile,header=T)
```



