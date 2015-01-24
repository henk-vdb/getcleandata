# Code Book

This is the code book for the dataset that was derived from a dataset described as

[Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).
The original dataset can be downloaded from 

[http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip](http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip)

## Exploration
The ```run_analysis.R``` script will -after sourcing- download 
the original dataset and unzip it in the directory ```data/UCI HAR Dataset``` 
relative to your working directory in ```R```. The dataset contains a
```README.txt``` and a file ```features_info.txt``` describing the dataset and
how it was made. We are not going to repeat the information that is in these
files on this location. In stead we are going to make a quick scan of the
dataset and see if we can make head and tails out of it. A draft-version of
this exploration is in the file ```research.txt``` in the root of the git-hub repo.

### Dimensions of the original data



