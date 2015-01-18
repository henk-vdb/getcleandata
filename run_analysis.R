
require(data.table)

################# Global variables #################

dataDir <- "data"
dataLocation <- file.path(dataDir, "UCI HAR Dataset")
dataLocationAlt <- "UCI HAR Dataset"
dataMerged <- file.path(dataDir, "merged_dataset")
dataExtracted <- file.path(dataDir, "extracted_dataset")

################# Functions #################

# Load the data, unzip and report into directory [dataDir]. The directory will be
# created if non-existent.
# Returns: the date of download.
loadData <- function() {
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        zipFile <- file.path(dataDir, "UCI HAR Dataset.zip")
        logFile <- file.path(dataDir, "download.log")
        message("Downloading file from ", fileURL)
        
        if (!file.exists(dataDir)) dir.create(dataDir)
        download.file(fileURL, zipFile, method = "curl", quiet = TRUE)
        dateDownloaded <- date()
        message("Downloaded '", zipFile, "' on ", dateDownloaded)
        
        result <- unzip(zipFile, exdir = dataDir)
        nfiles <- length(result)
        file.remove(zipFile)
        message("Unzipped ", nfiles, " files")
        
        startRelPath <- nchar(dataDir) + 2
        cat("source: ", fileURL,
            "\ndate of download: ", dateDownloaded,
            "\nnumber of files: ", nfiles,
            "\nlist of files:\n", paste(substring(result, startRelPath), 
                                        collapse = "\n"),
            file = logFile, sep = "")
        message("See '", logFile, "' for details")
        
        dateDownloaded
}

# 1. Merges the training and the test sets to create one data set.
mergeData <- function() {
        message("Merging 'test' and 'train' data into ", dataMerged)
        
        if (!file.exists(dataDir)) dir.create(dataDir)
        if (!file.exists(dataMerged)) dir.create(dataMerged)
        
        # copy activity_labels,txt and features.txt
        cfiles <- c("activity_labels.txt", "features.txt")
        from <- file.path(dataLocation, cfiles)
        to <- file.path(dataMerged, cfiles)
        file.copy(from, to)
        message("Coppied ", paste(cfiles, collapse = ", "))
        
        mfiles <- c("subject", "X", "y")
        for (file in mfiles) {
                ptrain <- file.path(dataLocation, "train", paste(file, "_train.txt", sep = ""))
                ptest <- file.path(dataLocation, "test", paste(file, "_test.txt", sep = ""))
                pmerged <- file.path(dataMerged, paste(file, ".txt", sep = ""))
                
                dftrain <- read.table(ptrain)
                dftest <- read.table(ptest)
                dfmerged <- rbindlist(list(dftrain, dftest))
                write.table(dfmerged, pmerged, col.names = FALSE, row.names = FALSE)
                message("Merged '", ptrain, "' and '", ptest, "' into '", pmerged, "'")
        }
        # Don't need the Internal Signals, because using derived data in X.txt.
}

extractData <- function() {
        message("Extracting data from '", dataMerged, "' into '", dataExtracted, "'")
}
        
################# Start of main script #################

# Preferred data location is the directory "data", but we can also live with a
# specific directory right in the working directory.
if (file.exists(dataLocationAlt)) {
        dataLocation <- dataLocationAlt
}

# Get the raw data if it is not at the expected location.
if (!file.exists(dataLocation)) {
        loadData()  
}

message("Using data in: ", dataLocation)

# The actual assignment
# 1. Merges the training and the test sets to create one data set.
if (!file.exists(dataMerged)) {
        mergeData()
}

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
extractData()

