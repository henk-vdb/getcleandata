

dataLocation <- file.path("data", "UCI HAR Dataset")
dataLocationAlt <- "UCI HAR Dataset"

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

# Load the data, unzip and report into directory "data", which will be created
# if non-existent.
loadData <- function() {
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        zipFile <- file.path("data", "UCI HAR Dataset.zip")
        logFile <- file.path("data", "download.log")
        message("Downloading file from ", fileURL)
        
        dir.create("data")
        download.file(fileURL, zipFile, method = "curl", quiet = TRUE)
        dateDownloaded <- date()
        message("Downloaded '", zipFile, "'' on ", dateDownloaded)
        
        result <- unzip(zipFile, exdir = "data")
        nfiles <- length(result)
        file.remove(zipFile)
        message("Unzipped ", nfiles, " files in directory data/", dir("data"))
        
        cat("source: ", fileURL,
            "\ndate of download: ", dateDownloaded,
            "\nnumber of files: ", nfiles,
            "\nlist of files:\n", paste(substring(result, 6), collapse = "\n"),
            file = logFile, sep = "")
        message("See '", logFile, "' for details")
        
        dateDownloaded
}

