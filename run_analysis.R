## Script should be launch in the folder "UCI HAR Dataset".
## This script does the following: 
##
##   - Merges the training and the test sets to create one data set.
##   - Extracts only the measurements on the mean and standard deviation for each measurement. 
##   - Uses descriptive activity names to name the activities in the data set
##   - Appropriately labels the data set with descriptive variable names. 
##   - Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
## 

#==========load/read data==============
#read test data
Y_test <-read.table('./test/Y_test.txt')
X_test <-read.table('./test/X_test.txt')
subject_test <-read.table('./test/subject_test.txt');

#read train data
Y_train <-read.table('./train/Y_train.txt')
X_train <-read.table('./train/X_train.txt')
subject_train <-read.table('./train/subject_train.txt');

#read features names
features <-read.table('./features.txt')
activity_labels <- read.table('./activity_labels.txt')
activity_labels <- activity_labels[,2]

#=======create one big file========
#bind test+train data together
X_data <- rbind(X_train, X_test)
Y_data <- rbind(Y_train, Y_test)
subject_data <- rbind(subject_train, subject_test)

#name activity_labels and subject_data
activity_id <- "activity_id"
activity_name <- "activity_name"
subject <- "subject"
Y_data[,2] = activity_labels[Y_data[,1]]
names(Y_data) <- c(activity_id, activity_name)
names(subject_data) <- c(subject)

#choose columns with mean/std in X_data
features<-tolower(features[,2])
names(X_data) <- features
X_data <- X_data[,grep("(std\\(\\))|(mean\\(\\))", names(X_data))]

#bind with activity info and subject info
bigdata<-cbind(X_data, Y_data, subject_data)
id_labels = c(subject, activity_id, activity_name);
data_labels = setdiff(colnames(bigdata), id_labels)

meltdata = melt(bigdata, id = id_labels, measure.vars = data_labels)

# Apply mean function to dataset using dcast function
tidydata = dcast(meltdata, subject + activity_name ~ variable, mean)
write.table(tidydata, file = "./tidy.txt")




