
################# Global variables #################

dataDir <- "data"
dataLocation <- file.path(dataDir, "UCI HAR Dataset")
dataLocationAlt <- "UCI HAR Dataset"

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


