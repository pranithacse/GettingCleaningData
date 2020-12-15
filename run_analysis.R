# Read the Labels,Test, and Training Sets
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt") #V2 contains label
features <- read.table("./UCI HAR Dataset/features.txt")              # V2 contains feature labels

subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

# Add feature labels to feature data: X_test, X_train (Step 4)
names(X_test)  <- features$V2
names(X_train) <- features$V2

# Add names to subject/case and activity_labels, and label data (Step 4)
names(subject_test)  <- "subject" 
names(subject_train) <- "subject" 
names(activity_labels) <- c("activity_number", "activity_name")
names(y_test)  <- "activity"
names(y_train) <- "activity"

# Combine subjects, labels, features into test and train sets (Step 1)
test  <- cbind(subject_test, y_test, X_test)
train <- cbind(subject_train, y_train, X_train)

# Combine test and train sets into full data set  (Step 1 - continued)
fullset <- rbind(test, train)

# Subset to observations of mean and standard deviation on each measurement
# but keep subject and activity columns (Step 2)
allnames <- c("subject", "activity", as.character(features$V2))
meanStdColumns <- grep("mean|std", allnames, value = FALSE)
reducedset <- fullset[ ,c(1,2,meanStdColumns)]

# Uses descriptive activity names for activites in the data set: by indexing (Step 3)
reducedset$activity <- activity_labels$activity_name[reducedset$activity]

# Create tidy data set
tidyDataset <- reducedset %>% group_by(subject, activity) %>% summarise_each(funs(mean))
write.table(tidyDataset, file = "tidyDataset.txt")

# Call to read in tidy data set produced
a <- read.table("tidyDataset.txt")
