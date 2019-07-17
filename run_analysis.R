
#reading and converting raw datasets
features <- read.csv('./UCI HAR Dataset/features.txt', header = FALSE, sep = ' ')
features <- as.character(features[,2])
train.x <- read.table('./UCI HAR Dataset/train/X_train.txt')
train.y <- read.csv('./UCI HAR Dataset/train/y_train.txt', header = FALSE, sep = ' ')
train.subject <- read.csv('./UCI HAR Dataset/train/subject_train.txt',header = FALSE, sep = ' ')
test.x <- read.table('./UCI HAR Dataset/test/X_test.txt')
test.y <- read.csv('./UCI HAR Dataset/test/y_test.txt', header = FALSE, sep = ' ')
test.subject <- read.csv('./UCI HAR Dataset/test/subject_test.txt', header = FALSE, sep = ' ')


#combining the 3 training datasets and putting labels on the columns
train.all <-  data.frame(train.subject, train.y, train.x)
names(train.all) <- c(c('subject', 'activity'), features)


#combining the 3 testing datasets and putting labels on the columns
test.all <-  data.frame(test.subject, test.y, test.x)
names(test.all) <- c(c('subject', 'activity'), features)



#merging the training and testing sets to create one master data set
har_data <- rbind(train.all, test.all)



#extracting only the measurements on the mean and standard deviation 
col.select <- grep('mean|std', features)
har_msd <-har_data[,c(1,2,col.select + 2)]



#using descriptive activity names to name the activities in the data set
labels <- read.table('./UCI HAR Dataset/activity_labels.txt', header = FALSE)
labels <- as.character(labels[,2])
har_msd$activity <- labels[har_msd$activity]


#adjusting the labeling the variable names to something more user-friendly 
name.new <- names(har_msd)

name.new <- gsub("[(][)]", "", name.new)
name.new <- gsub("^t", "TimeDomain_", name.new)
name.new <- gsub("^f", "FrequencyDomain_", name.new)
name.new <- gsub("Acc", "Accelerometer", name.new)
name.new <- gsub("Gyro", "Gyroscope", name.new)
name.new <- gsub("Mag", "Magnitude", name.new)
name.new <- gsub("-mean-", "_Mean_", name.new)
name.new <- gsub("-std-", "_StandardDeviation_", name.new)
name.new <- gsub("-", "_", name.new)

names(har_msd) <- name.new


#creating a tidy data set with the average of each variable for each activity and subject
tidy_data <- aggregate(har_msd[,3:81], by = list(activity = har_msd$activity, subject = har_msd$subject),FUN = mean)


#exporting the outputs from steps 4 and 5 as .txt files
write.table(x = har_msd, file = "har_data.txt", row.names = FALSE)
write.table(x = tidy_data, file = "final_data.txt", row.names = FALSE)

#generating the codebook for the orginal data
makeCodebook(har_msd)

