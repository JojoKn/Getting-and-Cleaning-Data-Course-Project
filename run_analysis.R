#####################
####Course Project###
#####################

###Reading in the required data files

x_test <- read.table("~/Desktop/Learning R/Getting and Cleaning Course Project/Getting-and-Cleaning-Data-Course-Project/UCI HAR Dataset/test/X_test.txt", quote="\"", comment.char="")
y_test <- read.table("~/Desktop/Learning R/Getting and Cleaning Course Project/Getting-and-Cleaning-Data-Course-Project/UCI HAR Dataset/test/y_test.txt", quote="\"", comment.char="")
subject_test <- read.table("~/Desktop/Learning R/Getting and Cleaning Course Project/Getting-and-Cleaning-Data-Course-Project/UCI HAR Dataset/test/subject_test.txt", quote="\"", comment.char="")
x_train <- read.table("~/Desktop/Learning R/Getting and Cleaning Course Project/Getting-and-Cleaning-Data-Course-Project/UCI HAR Dataset/train/X_train.txt", quote="\"", comment.char="")
y_train <- read.table("~/Desktop/Learning R/Getting and Cleaning Course Project/Getting-and-Cleaning-Data-Course-Project/UCI HAR Dataset/train/y_train.txt", quote="\"", comment.char="")
subject_train <- read.table("~/Desktop/Learning R/Getting and Cleaning Course Project/Getting-and-Cleaning-Data-Course-Project/UCI HAR Dataset/train/subject_train.txt", quote="\"", comment.char="")

###Naming the columns of the subject file and label file

colnames(subject_test)<-c("id")
colnames(subject_train)<-c("id")

colnames(y_train)<-c("activity")
colnames(y_test)<-c("activity")

###Combination of the train and test dataset separately
combined_test<-cbind(subject_test, y_test, x_test)
combined_train<-cbind(subject_train, y_train, x_train)

###Combination of train and test dataset to obtain one single dataset that contains
###all 30 individuals
combined<-rbind(combined_test, combined_train)

###Reading in the variable names for the combined measures dataset

var_names <- read.table("~/Desktop/Learning R/Getting and Cleaning Course Project/Getting-and-Cleaning-Data-Course-Project/UCI HAR Dataset/features.txt", quote="\"", comment.char="")

###Searching in the list for variable names for all names 
###containing the mean; then obtaining the variable names of the 
###original data frame by combining the numbers obtained with "V"

mean<-grep(".mean.", var_names$V2)
mean_vars<-paste("V", mean, sep="")

###Searching in the list for variable names for all names 
###containing the std; then obtaining the variable names of the 
###original data frame by combining the numbers obtained with "V"

std<-grep(".std.", var_names$V2)
std_vars<-paste("V", std, sep="")

###Subsetting the combined data frame using the variable names that 
###were obtained in the steps before.

combined_lean<-combined[,c("id", "activity", mean_vars, std_vars)]

###Renaming the variable names of the lean dataset by fist obtaining the 
###names from the name file and then assigning them to the lean dataset

mean_names<-var_names[mean,]
mean_names2<-mean_names$V2

std_names<-var_names[std,]
std_names2<-std_names$V2

colnames(combined_lean)<-c("id", "activity", mean_names2, std_names2)

###Assigning the labels to the values for the activity variable

combined_lean$activity_label<-factor(combined_lean$activity_label,
                                     levels=c(1,2,3,4,5,6),
                                     labels=c("walking", "walking_upstairs", "walking_downstairs", "sitting", "standing", "laying"))

###Checking the created lean dataset

View(combined_lean)

###Using the lean data set to create tidy data 
###Required dataset for each of the 30 subjects and each of the 6 activities contains
###the mean of the measures obtained

###loading the required package
library(dplyr)

###Grouping the dataset
final_data<-group_by(combined_lean, id, activity)

###Calculating group means
final_data<-summarise_all(final_data, funs(mean), groups="keep")


#################
###END OF CODE###
#################












