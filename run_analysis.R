#Create one R script called run_analysis.R that does the following. 
#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement. 
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names. 
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


#read activity names
activity_nam <- read.table('./UCI HAR Dataset/activity_labels.txt')[,2]

#read column names
feat_nam <- read.table('./UCI HAR Dataset/features.txt')[,2]

#read test data
subject_test <- read.table('./UCI HAR Dataset/test/subject_test.txt')
x_test <- read.table('./UCI HAR Dataset/test/X_test.txt')
y_test <- read.table('./UCI HAR Dataset/test/y_test.txt')

names(x_test) = feat_nam

#extract only the measurements on the mean and standard deviation for each measurement
extract_feat <- grepl('mean|std', feat_nam)
x_test = x_test[, extract_feat]

#set activity labels
y_test[,2] = activity_nam[y_test[,1]]
names(y_test) = c('ID_Activ', 'Label_Activ')
names(subject_test) = 'subject'

#Bind dataset
test_data <- cbind(subject_test, y_test, x_test)

#read train data
subject_train <- read.table('./UCI HAR Dataset/train/subject_train.txt')
x_train <- read.table('./UCI HAR Dataset/train/X_train.txt')
y_train <- read.table('./UCI HAR Dataset/train/y_train.txt')

names(x_train) <- feat_nam

#extract only the measurements on the mean and standard deviation for each measurement
x_train = x_train[, extract_feat]

#set activity labels
names(subject_train) <- 'subject'
y_train[,2] <- activity_nam[y_train[,1]]
names(y_train) <- c('ID_Activ', 'Label_Activ')

#Bind dataset
train_data <- cbind(subject_train, y_train, x_train)

#Merges the training and the test sets to create one data set
merge_data <- rbind(test_data, train_data)

id_labels =c('subject', 'ID_Activ', 'Label_Activ')
merge_data_labels = setdiff(colnames(merge_data), id_labels)
melt_data = melt(merge_data, id = id_labels, measure.vars = merge_data_labels)

#Apply mean fuction to dataset using dcast function
tidy_dataset = dcast(melt_data, subject + Label_Activ ~ variable, mean)

write.table(tidy_dataset, file = './tidy_data.txt', row.name=FALSE)
