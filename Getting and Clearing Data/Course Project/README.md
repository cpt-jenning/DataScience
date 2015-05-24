### General Information
  Script and other files in this folder are part of "Course Project" from "Getting and Clearing Data" course at coursera.org.
  For more information about downloaded and processed dataset read "README.txt" file in the created "UCI HAR Dataset" folder or visit [this website](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

### Script tested on
  R version 3.1.0 (2014-04-10) -- "Spring Dance" with RStudio on both "Windows 7 64bit"" and "" OS.

### Running the script
  To make the scrip working you must set your working directory to the script filepath (at the beginning of the script there is a suitable place for you to do so).
  Scrip will generate a folder called 'data' in your working directory, and then download and unzip data in that particular folder. Zipped data will also remain in that folder.
  Scrip will automaticly delete unused variables and datasets after each step of computasion to minimize the memory fill.

### Choosed variables
  All variables with 'mean' or 'std' in their names were choosed to create 'tidy' dataset, also labels for those variables remains unchanged (there was simply to many for me to bother) and the explenation for each is placed in 'CodeBook.md'.

### Created dataset
  Created data set contains of 81 named variables and 180 named observations. You can specify either directory you want to save to, name of the file or both at the end of the script.
  In case you remain in as it is created dateset will be saved as "tidy_data.txt" in your working directory.

### Possible errors:
* If there is a folder called 'data' in your working the data won't be downloaded. Change your 'data' folder name to avoid it.
* If there is an error during download and you are using Windows OS you should delete "method = 'curl'" parameter in "download.file(...)" command."