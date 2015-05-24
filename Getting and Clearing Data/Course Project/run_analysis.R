# 0. To make the scrip working you must set your working directory to the script filepath
# setwd("SCRIPT_FILE_PATH")



## 1. Getting the data from the web
# Creating folder for the data if needed
if(!file.exists( paste0(getwd(), "/data") )){
    dir.create( paste0(getwd(), "/data") )
    
    # Downloading the data
    fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileUrl,
                  destfile = paste0(getwd(), "/data", "/UCI HAR Dataset.zip"),
                  method = "curl") # On Windows delete this method
    
    # Unzipping the data
    unzip(zipfile = paste0(getwd(), "/data", "/UCI HAR Dataset.zip"),
          exdir = paste0(getwd(), "/data"),
          setTimes = TRUE)
}



## 2. Merging the training and the test sets to create one data set
# Location of the data main folder
data.dir <- paste0(getwd(), "/data", "/UCI HAR Dataset")

# Loading datasets from 'UCI HAR Dataset' directory
act.lab <- read.table(paste0(data.dir, "/activity_labels.txt"))
feature <- read.table(paste0(data.dir, "/features.txt"))
# ... and naming variables
names(act.lab) <- c("activ_id", "activity")
names(feature) <- c("feature_id", "feature")

# Loading datasets from 'train' subdirectory
sub.train <- read.table(paste0(data.dir, "/train/subject_train.txt"))
X.train <- read.table(paste0(data.dir, "/train/X_train.txt"))
y.train <- read.table(paste0(data.dir, "/train/y_train.txt"))
# ... and naming variables
names(sub.train) <- "id"
names(X.train) <- feature$feature
names(y.train) <- "activ_id"

# Creating train subset
train <- data.frame(sub.train, y.train, X.train)
# ... and releasing memory
rm(list = c("sub.train", "y.train", "X.train"))

# Loading datasets from 'test' subdirectory
sub.test <- read.table(paste0(data.dir, "/test/subject_test.txt"))
X.test <- read.table(paste0(data.dir, "/test/X_test.txt"))
y.test <- read.table(paste0(data.dir, "/test/y_test.txt"))
# ... and naming variables
names(sub.test) <- "id"
names(X.test) <- feature$feature
names(y.test) <- "activ_id"

# Creating test subset
test <- data.frame(sub.test, y.test, X.test)
# ... and releasing memory
rm(list = c("sub.test", "y.test", "X.test"))

# Merging train and test subsets
data <- rbind(test, train)
# ... and releasing memory
rm(list = c("test", "train"))



## 3. Extracting the measurements on the mean and standard deviation
# Index vector of features fulfilling the requirements
index <- grep("(.*)(mean|std)(.*)", feature$feature)
# Adding ID and ACTIV_ID column to index vector
index <- append(1:2, index + 2)
# (+2) is to move indexes to start numeration from the 3rd column in the data

# Subsetting the dataset
data <- data[,index]

# ... and releasing memory
rm(list = c("index", "feature"))


## 4. Adding descriptive activity names to name the activities in the data set
act.lab[,2] <- as.character(act.lab[,2])
activities <- character(nrow(data))
for(i in 1:nrow(data)){
  activities[i] <- as.character(act.lab[data[i,2],2])
}
data[, "activ_id"] <- as.character(act.lab[data[, "activ_id"], "activity"])
names(data)[[2]] <- "activity"

ns <- gsub("[.?]", "-", names(data))
ns <- gsub("(---)", "(", ns)
ns <- gsub("[X]$", "X)", ns)
ns <- gsub("[Y]$", "Y)", ns)
ns <- gsub("[Z]$", "Z)", ns)
ns <- gsub("(--)", "", ns)
ns <- gsub("(mean)$", "mean()", ns)
ns <- gsub("(Freq)$", "Freq()", ns)
ns <- gsub("(std)$", "std()", ns)
names(data) <- ns



## 5. Creating tidy data set with the average of each variable for each activity and each subject.
# Function return vector created by appending rows of matrix
createColumn <- function(matrix){
  x <- list()
  for(i in 1:30){
    x <- append(x, matrix[i,])
  }
  x <- unlist(x); names(x) <- NULL; x
}

# Computing, the means
means <- lapply(names(data)[3:ncol(data)],
                function(name){
                    tapply(data[,name], data[,1:2], mean)[,act.lab[,2]]
                  }
                )
means <- sapply(means, createColumn)

# Creating tidy dataset
tidy.data <- data.frame(cbind(sort(rep(1:30, 6)), rep(act.lab$activity, 30), means))
names(tidy.data) <- names(data)

# ... and releasing memory
rm(list = c("data", "act.lab", "means", "activities", "ns", "i"))

# Saving tidy.data to a text file
data.dir <- ""
data.name <- "tidy_data.txt"
write.table(tidy.data, file = ifelse(data.dir != "",
                                     paste0(data.dir, "/", data.name),
                                     data.name))