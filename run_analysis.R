#0. file download and unzip
destPath<-"./data"
destFile<- file.path(destPath,"Dataset.zip" )
tidyFile<- file.path(destPath,"Tidydataset.txt" )

dataPath<-file.path(destPath,"UCI HAR Dataset")

if(!file.exists(destPath)) {dir.create(destPath)}
fileUrl="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile = destFile)
unzip(destFile,exdir = destPath)

############## 1. Merges the training and the test sets to create one data set.

    # read train files
    subjtrain <- read.table(file.path(dataPath,"train","subject_train.txt"))
    measurestrain <- read.table(file.path(dataPath,"train","X_train.txt"))
    labeltrain <- read.table(file.path(dataPath,"train","y_train.txt"))
    
    # read test files
    subjtest <- read.table(file.path(dataPath,"test","subject_test.txt"))
    measurestest <- read.table(file.path(dataPath,"test","X_test.txt"))
    labeltest <- read.table(file.path(dataPath,"test","y_test.txt"))
    
    # merge train data frames into one
    train <- cbind(measurestrain,labeltrain,subjtrain)
    
    # merge test data frames into one
    test <- cbind(measurestest,labeltest,subjtest)
    
    # merge test and train rows into one data set
    measures <- rbind(train,test)
    
    # get variable names from features.txt
    variables <- make.names((read.table(file.path(dataPath,"features.txt"))[2])[[1]])
    # add names for activity and subject
    colNames <- c(variables,"activity","subject")
    
    #assign variable names to the data frame
    names(measures) <- colNames

############## 2. Extracts only the measurements on the mean and standard deviation for 
##############    each measurement.

    meanstdvariables <- grep("(mean\\.\\.|std\\.\\.)",names(measures))
    meanstdmeasures <- measures[,c(meanstdvariables,562,563)]

############## 3. Uses descriptive activity names to name the activities in the data set

    # get activities from txt file
    activities <- read.table(file.path(dataPath,"activity_labels.txt"))
    
    # lookup activity number vs activities table and update the data set
    meanstdmeasures$activity <- sapply(meanstdmeasures$activity,
                                 function(x){ 
                                        as.character(activities[activities$V1==x,][[2]])
                              })
    
############## 4. Appropriately labels the data set with descriptive variable names.
    
    # as by jeff leek lecture criteria applied tolower + gsub
    names(meanstdmeasures) <- gsub("\\.","",tolower(names(meanstdmeasures)))

############## 5. From the data set in step 4, creates a second, independent tidy data set with the average 
##############    of each variable for each activity and each subject.
    
    tidy <- aggregate(.~ subject + activity,data=meanstdmeasures, FUN = "mean")
    
    # create txt file with tidy data
    write.table(tidy,file=tidyFile,row.names = F)
    
   #re read tidy data set
   # pippo<-read.table(tidyFile, header = T)
    