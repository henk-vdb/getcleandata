
require(data.table)
require(reshape2)

################# Global variables #################

dataDir <- "data"
dataLocation <- file.path(dataDir, "UCI HAR Dataset")
dataLocationAlt <- "UCI HAR Dataset"
dataMerged <- file.path(dataDir, "merged_dataset")
dataExtracted <- file.path(dataDir, "extracted_dataset")
dataCleaned <- file.path(dataDir, "cleaned_dataset")
dataTidy <- file.path(dataDir, "tidy_dataset")

################# Functions #################

# Load the data, unzip and report into directory [dataDir]. The directory will be
# created if non-existent.
# Returns: the date of download.
loadData <- function() {
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        zipFile <- file.path(dataDir, "UCI HAR Dataset.zip")
        logFile <- file.path(dataDir, "download.log")
        message("Step 0. Downloading file from ", fileURL)
        
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
        message("Step 1. Merging 'test' and 'train' data into ", dataMerged)
        
        if (!file.exists(dataDir)) dir.create(dataDir)
        if (!file.exists(dataMerged)) dir.create(dataMerged)
        
        # copy activity_labels.txt and features.txt
        cfiles <- c("activity_labels.txt", "features.txt")
        from <- file.path(dataLocation, cfiles)
        to <- file.path(dataMerged, cfiles)
        file.copy(from, to)
        message("Coppied ", paste(paste0("'", cfiles, "'"), collapse = ", "))
        
        mfiles <- c("subject", "X", "y")
        for (file in mfiles) {
                ptrain <- file.path(dataLocation, "train", paste(file, "_train.txt", sep = ""))
                ptest <- file.path(dataLocation, "test", paste(file, "_test.txt", sep = ""))
                pmerged <- file.path(dataMerged, paste(file, ".txt", sep = ""))
                
                dftrain <- read.table(ptrain)
                dftest <- read.table(ptest)
                dfmerged <- rbindlist(list(dftrain, dftest))
                write.table(dfmerged, pmerged, 
                            col.names = FALSE, row.names = FALSE, quote = FALSE)
                message("Merged '", ptrain, "' and '", ptest, "' into '", pmerged, "'")
        }
        # Don't need the Internal Signals, because using derived data in X.txt.
}

# 2. Extracts only the measurements on the mean and standard deviation 
# for each measurement.
extractData <- function() {
        message("Step 2. Extracting data from '", dataMerged, "' into '", dataExtracted, "'.")
        
        if (!file.exists(dataDir)) dir.create(dataDir)
        if (!file.exists(dataExtracted)) dir.create(dataExtracted)
        
        # copy activity_labels.txt, subject.txt and y.txt
        cfiles <- c("activity_labels.txt", "subject.txt", "y.txt")
        from <- file.path(dataMerged, cfiles)
        to <- file.path(dataExtracted, cfiles)
        file.copy(from, to)
        message("Coppied ", paste(paste0("'", cfiles, "'"), collapse = ", "))
        
        # select features ending on '-mean()' or '-std()', 
        # optionally followed by '-X', '-Y' or '-Z'. 
        df.x <- read.table(file.path(dataMerged, "X.txt"))
        df.f <- read.table(file.path(dataMerged, "features.txt"))
        selected <- grepl("-(mean|std)\\(\\)(-[XYZ])?$", df.f[, 2])
        df.x <- df.x[, selected]
        df.f <- df.f[selected, ]
        write.table(df.x, file.path(dataExtracted, "X.txt"), 
                    col.names = FALSE, row.names = FALSE, quote = FALSE)
        write.table(df.f, file.path(dataExtracted, "features.txt"), 
                    col.names = FALSE, row.names = FALSE, quote = FALSE)
        message("Extracted ", ncol(df.x), " columns and ", nrow(df.f), 
                " feature names.")
}

# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
cleanData <- function() {
        message("Step 3 and 4. Cleaning data from '", dataExtracted, "' and putting them in '", dataCleaned, "'.")
        
        if (!file.exists(dataDir)) dir.create(dataDir)
        if (!file.exists(dataCleaned)) dir.create(dataCleaned)
        
        # 3. Uses descriptive activity names to name the activities in the data set
        df.a <- read.table(file.path(dataExtracted, "activity_labels.txt"))
        df.a[, 2] <- tolower(gsub("_", " ", df.a[, 2]))
        colnames(df.a) <- c("id", "label")
        write.table(df.a, file.path(dataCleaned, "activities.txt"), row.names = FALSE)
        # read table back with > read.table(file, header = TRUE)
        
        # 4. Appropriately labels the data set with descriptive variable names.
        # read the extracted data
        df.x <- read.table(file.path(dataExtracted, "X.txt"))
        df.f <- read.table(file.path(dataExtracted, "features.txt"))
        df.s <- read.table(file.path(dataExtracted, "subject.txt"))
        df.y <- read.table(file.path(dataExtracted, "y.txt"))
        
        # Get logical vectors that can split the main table into values for mean
        # and standard deviation.
        vmean <- grepl("-mean\\(\\)(-[XYZ])?$", df.f[, 2])
        vstd <- grepl("-std\\(\\)(-[XYZ])?$", df.f[, 2])
        
        # Clean up feature names as far as goes.. 
        vn <- gsub("BodyBody", "Body", df.f[, 2]) # take out obvious mistake
        vn <- gsub("Mag", "magnitude", vn) # expand name
        vn <- gsub("Acc", "acceleration", vn) # expand name
        vn <- gsub("Gyro", "velocity", vn) # expand name
        vn <- gsub("^t", "timedomain", vn) # expand name
        vn <- gsub("^f", "frequencydomain", vn) # expand name
        vn <- tolower(vn)
        
        # add column names to main table:
        colnames(df.x) <- vn
        # add columns for subjectid and activityid:
        df.x <- cbind(activityid = df.y[, 1], df.x)
        df.x <- cbind(subjectid = df.s[, 1], df.x)
        
        # reshape the main table from 'wide' to 'long' for the two variables.
        # mind that we have added two columns, so add 2 to column indexes
        df.mean <- melt(df.x, id.vars = c("subjectid", "activityid"),
                        measure.vars = colnames(df.x)[which(vmean) + 2],
                        variable.name = "signal",
                        value.name = "mean")
        df.std <- melt(df.x, id.vars = c("subjectid", "activityid"),
                        measure.vars = colnames(df.x)[which(vstd) + 2],
                        variable.name = "signal",
                        value.name = "standarddeviation")
        # Clean variable names further:
        df.mean$signal <- gsub("(-mean\\(\\))|(-)", "", df.mean$signal)
        df.clean <- cbind(df.mean, standarddeviation=df.std$standarddeviation)
        write.table(df.clean, file.path(dataCleaned, "signal_data.txt"), 
                    row.names = FALSE, quote = FALSE)
}

# 5. From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.
tidyData <- function() {
        message("Step 5. Taking average of values in '", dataCleaned, "' and putting them in '", dataTidy, "'.")
        
        if (!file.exists(dataDir)) dir.create(dataDir)
        if (!file.exists(dataTidy)) dir.create(dataTidy)
        
        from <- file.path(dataCleaned, "activities.txt")
        to <- file.path(dataTidy, "activities.txt")
        file.copy(from, to)
        message("Coppied '", from, "' to '", to, "'.")
        
        dt.clean <- data.table(read.table(
                file.path(dataCleaned, "signal_data.txt"), header = TRUE))
        setkey(dt.clean, subjectid, activityid, signal)
        dt.average <- dt.clean[, 
                list(averagemean = mean(mean), averagestandarddeviation = mean(standarddeviation)), 
                by = list(subjectid, activityid, signal)]
        
        path <- file.path(dataTidy, "average_signal.txt")
        write.table(dt.average, path, row.names = FALSE, quote = FALSE)
        
        message("See: '", path, 
                "' for the average of each variable for each activity and each subject.")
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
if (!file.exists(dataExtracted)) {
        extractData()
}

# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
if (!file.exists(dataCleaned)) {
        cleanData()
}

# 5. From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.
tidyData()

dt.average <- data.table(read.table(file.path(dataTidy, "average_signal.txt"), 
                                    header = TRUE))
message("Done. Loaded '", file.path(dataTidy, "average_signal.txt"),
        "' as data.table with name 'dt.average'.")