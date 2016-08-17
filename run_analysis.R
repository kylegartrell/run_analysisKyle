library("data.table")
library("plyr")
library("dplyr")

setwd("C:/Users/1405249584A/Documents/R/R-3.2.0/data/UCI HAR Dataset/test")
xtest <- read.table("C:/Users/1405249584A/Documents/R/R-3.2.0/data/UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("C:/Users/1405249584A/Documents/R/R-3.2.0/data/UCI HAR Dataset/test/y_test.txt")
subtest <- read.table("C:/Users/1405249584A/Documents/R/R-3.2.0/data/UCI HAR Dataset/test/subject_test.txt")

setwd("C:/Users/1405249584A/Documents/R/R-3.2.0/data/UCI HAR Dataset/train")
xtrain <- read.table("C:/Users/1405249584A/Documents/R/R-3.2.0/data/UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("C:/Users/1405249584A/Documents/R/R-3.2.0/data/UCI HAR Dataset/train/y_train.txt")
subtrain <- read.table("C:/Users/1405249584A/Documents/R/R-3.2.0/data/UCI HAR Dataset/train/subject_train.txt")

setwd("C:/Users/1405249584A/Documents/R/R-3.2.0/data/UCI HAR Dataset")
features <- read.table("C:/Users/1405249584A/Documents/R/R-3.2.0/data/UCI HAR Dataset/features.txt")

colnames(xtrain) <- features[, 2]
colnames(xtest) <- features[, 2]

length(colnames(xtrain))
length(colnames(ytrain))
length(colnames(subtrain))

merge_train <- cbind(subtrain[, 1], ytrain[, 1], xtrain[, 1:561])
colnames(merge_train)[1:2] <- c("person.id", "activity_label")


merge_test <- cbind(subtest[, 1], ytest[, 1], xtest[, 1:561])
colnames(merge_test)[1:2] <- c("person.id", "activity_label") 

merge_train <- as.data.table(cbind("train", merge_train[, 1:563]))
merge_test <- as.data.table(cbind("test", merge_test[, 1:563]))

colnames(merge_train)[1] <- "data_set"
colnames(merge_test)[1] <- "data_set"

master <- rbind(merge_train, merge_test, fill=TRUE)

mean <- grep("mean()", names(master), value = FALSE, fixed = TRUE)
meanDF <- master[mean]
View(meanDF)

std <- grep("std()", names(master), value = FALSE)
stdDF <- master[std]
View(stdDF)

master$activity_label[master$activity_label == 1] <- "Walking"
master$activity_label[master$activity_label == 2] <- "Walking Upstairs"
master$activity_label[master$activity_label == 3] <- "Walking Downstairs"
master$activity_label[master$activity_label == 4] <- "Sitting"
master$activity_label[master$activity_label == 5] <- "Standing"
master$activity_label[master$activity_label == 6] <- "Laying"
master$activity_label <- as.factor(master$activity_label)
View(master)

rm(xtrain, xtest, ytrain, ytest, subtrain, subtest, merge_train, merge_test)

names(master) <- gsub("Acc", "Accelerator", names(master))
names(master) <- gsub("Mag", "Magnitude", names(master))
names(master) <- gsub("Gyro", "Gyroscope", names(master))
names(master) <- gsub("^t", "time", names(master))
names(master) <- gsub("^f", "frequency", names(master))
View(master)

tidydata <- master[, lapply(.SD, mean), by = "person.id,activity_label"]
View(tidydata)
write.table(tidydata, file = "tidydata.txt", row.names = FALSE)
getwd()
