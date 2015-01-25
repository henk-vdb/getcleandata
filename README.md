# Getting and Cleaning Data

There is just one script needed to download the data, merge, extract and clean it
and create the final dataset with the tidy data.

1. Clone this repo to your local drive,
2. Set the working directory of your `R`-editor to `getcleandata`, the root of this project;
3. Source the `run_analysis.R`.

The script will first look for a directory `UCI HAR Dataset` in your working directory. 
If this directory is not there, it will look for a directory `data/UCI HAR Dataset`.
If neither of these directories are found, the script proceeds to create a `data` directory
in your working directory and download and unzip the original dataset there.

Depending on whether the directories `merged_dataset`, `extracted_dataset`
and `cleaned_dataset` do exist in the `data` directory the script will take
necessary steps to merge, extract and clean the dataset. Throwing away 
either of these directories or the complete `data` directory and sourcing
the `run_analysis.R` script again will allow for complete or partial
reprocessing of the data.

Finally the tidy dataset will be stored in the directory `data/tidy_dataset` and 
the main table will be present in your working directory as data.table under the name `dt.average`.

For a more in-depth tale of analysis and steps see the 
Code Book: [CodeBook.md](https://github.com/henk-vdb/getcleandata/blob/master/CodeBook.md).

Happy dataing.



