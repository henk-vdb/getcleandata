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
The dimensions of the downloaded dataset are ```7352 + 2947 = 10299``` rows or
observations over ```33 * 17 = 561``` signals and variables.

##### Activities
There are 6 id's and labels for activities.

##### Features
See also ```features_info.txt```.

There are 9 signals that do not have an XYZ movement. There are 8 signals with 
an XYZ movement, that makes a total of 3 * 8 = 24 such signals. Total signals:
```9 + 3 * 8 = 33``` signals.

Set of variables that were estimated from signals: ```17```.
Variables can be known because they all have '()' braces at the end.

Total amount of features = signals times variables = ```33 * 17 = 561```.

##### Subjects
Subjects are the persons that took part in the experiment. Each row in
```train/subject_train.txt``` and ```test/subject_test.txt``` identifies the 
subject who performed the activity for each window sample. 30 people in total 
took part in the experiment. The following probes in ```R``` give hints about
the dimensions of the subject data:
```R
> dftrain <- read.table("data/UCI HAR Dataset/train/subject_train.txt")
> dftest <- read.table("data/UCI HAR Dataset/test/subject_test.txt")
> table(dftrain)
dftrain
  1   3   5   6   7   8  11  14  15  16  17  19  21  22  23  25  26  27  28  29  30 
347 341 302 325 308 281 316 323 328 366 368 360 408 321 372 409 392 376 382 344 383 
> table(dftest)
dftest
  2   4   9  10  12  13  18  20  24 
302 317 288 294 320 327 364 354 381 

> nrow(dftrain)
[1] 7352
> nrow(dftest)
[1] 2947

> nrow(dftest) + nrow(dftrain)
[1] 10299
```
The subject files contain row headers as subject-id's (persons) 
for the ```7352 + 2947 = 10299``` observations.

##### The actual data
The files ```train/X_train.txt``` and ```test/X_test.txt``` contain the actual 
data. The following probes in ```R``` give hints about
the dimensions of the data:
```R
> dftrain <- read.table("data/UCI HAR Dataset/train/X_train.txt")
> dim(dftrain)
[1] 7352  561 # 7352 observations/rows over 561 features.

> dftest <- read.table("data/UCI HAR Dataset/test/X_test.txt")
> dim(dftest)
[1] 2947  561 # 2947 observations/rows over 561 features
```
There are ```7352 + 2947 = 10299``` observations of ```561``` features derived 
from internal signals.

##### Internal Signals
From ```README.txt```: 
> The sensor signals (accelerometer and gyroscope) were 
> pre-processed by applying 
> noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 
> 50% overlap (128 readings/window).

Each table in the ```test/Internal Signals``` directory has dimensions ```2947, 128```; each
table in the ```train/Internal Signals``` directory has dimensions ```7352, 128```. 
These are internal signals and can be ignored. We use the derived data in X.txt

# Step 1: Merge data
The 'test' and 'train' datasets can be merged, or better added up, to get the 
complete dataset again.

Code in ```run_analysis.R.mergeData``` first copies the ```activity_labels.txt``` 
and ```features.txt``` from the download directory ```data/UCI HAR Dataset``` to
the directory for the merged dataset: ```data/merged_dataset```.

It then reads in the ```subject_test.txt```, ```X_test.txt``` and ```y_test.txt```
and simply adds them up to the ```subject_train.txt```, ```X_train.txt``` 
and ```y_train.txt``` with the ```rbind``` function. The reunited tables
are stored as ```subject.txt```, ```X.txt``` and ```y.txt``` in 
the directory ```data/merged_dataset```.

We now have 6 activities (```activity_labels.txt```), 561 features
(```features.txt```), 10299 subject rows (```subject.txt```), 10299 activity 
rows (```y.txt```) and 10299 observations (```X.txt```) in the directory ```data/merged_dataset```.

# Step 2: Extract data



