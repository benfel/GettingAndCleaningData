# Get the data.  it's in a zip file, so download contents
# from "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# settint the working directory
> setwd("/Users/ruben.felomino/Documents/Unicorn/R Working Files/")

# 1. Reading and Merging the training and the test sets to create one data set.
# Reading
> subtest <- read.table("./UCIHAR/subject_test.txt")
> xtest <- read.table("./UCIHAR/X_test.txt")
> ytest <- read.table("./UCIHAR/Y_test.txt")
> subtrain <- read.table("./UCIHAR/subject_train.txt")
> xtrain <- read.table("./UCIHAR/X_train.txt")
> ytrain <- read.table("./UCIHAR/Y_train.txt")
> features <- read.table("./UCIHAR/features.txt")
> activities <- read.table("./UCIHAR/activity_labels.txt")
# Merging
> xall <- rbind(xtrain, xtest)
> yall <- rbind(ytrain, ytest)
> suball <- rbind(subtrain, subtest)
> allofit <- cbind(suball, yall, xall)
> rm(xtest,ytest,xtrain,ytrain,subtrain,subtest,xall,yall,suball)

# 3. Extracts only the measurements on the mean and standard deviation for each measurement.
# 4. Appropriately labels the data set with descriptive variable names.
> featureNames <- as.character(features[,2])
> newCols <- c("subject", "activity", featureNames)
> colnames(allofit) <- newCols

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
> onlyMeans <- grep("mean()", colnames(allofit))
> onlyStDevs <- grep("std()", colnames(allofit))
> revisedColumns <- c(onlyMeans, onlyStDevs)
> revisedColumns2 <- sort(revisedColumns) 
> newDataFrame <- allofit[, c(1,2,revisedColumns2)]
> newDataFrame2 <- newDataFrame[, !grepl("Freq", colnames(newDataFrame))]
> rm(newDataFrame, allofit)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of 
#    each variable for each activity and each subject.
> tidyframe <- data.frame()
 for (i in 1:30) {
         subj<- subset(newDataFrame2,subject==i)
         for (j in 1:6){
                 actv<- subset(subj, activity==j)
                 myresult<-as.vector(apply(actv,2,mean))
                 tidyframe<-rbind(tidyframe,myresult) 
         }
         
 }

 # Rename stuff and output the data to "Samsung_Data.txt"
> colnames(tidyframe)<-colnames(newDataFrame2)
> levels(tidyframe[,2])<-c('walk','upstairswalk','downstairswalk', 'sit','stand', 'lay')
> write.table(tidyframe, "Samsung_Data.txt", sep = "")
