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

The ```y_train.txt``` and ```y_test.txt``` files contain the activity row headers
for their respective windows. The 'y'-files contain row headers as activity-id's
for the ```7352 + 2947 = 10299``` observations.

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

##### Features
See also ```features_info.txt```.

There are 9 signals that do not have an XYZ movement. There are 8 signals with 
an XYZ movement, that makes a total of 3 * 8 = 24 such signals. Total signals:
```9 + 3 * 8 = 33``` signals.

Set of variables that were estimated from signals: ```17```.
Variables can be known because they all have '()' braces at the end.

Total amount of features = signals times variables = ```33 * 17 = 561```.

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
and ```y_train.txt``` respectively with the ```rbind``` function. The reunited tables
are stored as ```subject.txt```, ```X.txt``` and ```y.txt``` in 
the directory ```data/merged_dataset```.

We now have 6 activities (```activity_labels.txt```), 561 features
(```features.txt```), 10299 subject rows (```subject.txt```), 10299 activity 
rows (```y.txt```) and 10299 observations (```X.txt```) in the directory ```data/merged_dataset```.

# Step 2: Extract data
For our final dataset we only need the mean (```mean()```) and standard
deviation (```std()```) features.

Code in ```run_analysis.R.extractData``` copies 
the ```activity_labels.txt```, ```subject.txt```
and ```y.txt``` from the merge directory ```data/merged_dataset``` to
the directory for extracted data: ```data/extracted_dataset```.

It then selects features ending on ```-mean()``` or ```-std()```, 
optionally followed by ```-X```, ```-Y``` or ```-Z``` from ```features.txt```,
selects corresponding columns from ```X.txt``` and stores both extracted tables
as ```features.txt``` and ```X.txt``` in the directory ```data/extracted_dataset```.

We now have 6 activities (```activity_labels.txt```), 66 features
(```features.txt```), 10299 subject rows (```subject.txt```), 10299 activity 
rows (```y.txt```) and 10299 observations times 66 variables in (```X.txt```) 
in the directory ```data/merged_dataset```.

# Step 3 and 4: Clean the data
In this step we ar going to rename labels and variable names as well as rearange 
the data, to get from _wide_ to _long_ data. The code is in ```run_analysis.R.cleanData```,

Activity labels are renamed and stored as ```activities.txt``` in ```data/cleaned_dataset```.

The feature names are going to be variable names and are cleaned up and tidied as far as goes;
they still have to be unique because first they will be column names above the 
main table. Also we add the ```subject.txt``` and ```y.txt``` as columns to the main table.
These newly added columns get the names 'subjectid' and 'activityid'.

> Each variable you measure should be in one column...

and the mean and standard deviation we extracted are the variables. We use logical 
vectors to split up and _melt_ the main table along colums that have values for 
mean and standard deviation. This way we end up with two data frames, one for the 
mean values and one for the standard deviation values. Their rows have not
been altered and after cleaning up variable names in their columns 'signal' they have
exactly the same row headers for 'subjectid', 'activityid' and 'signal'. It is therefor save
to cbind the 'standarddeviation' column to the data frame with the mean values.

We now have 6 activities (```activities.txt```) and a table with dimensions 339867 times 5 variables.
As expected: 66 features, split over even in mean and std values gives 33 variables.
33 times 10299 _wide_ observations give 339867 _long_ observations.

# Step 5: Create a tidy dataset
From the data set in step 4, create a second, independent tidy data set with 
the average of each variable for each activity and each subject. 

The code in ```run_analysis.R.tidyData``` does just that.It copies the 
```activities.txt``` to the designated directory ```data/tidy_dataset```.
It takes the average of values for mean and standard deviation and stores 
the lost as ```average_signal.txt```.

# Description of variables and values 
Also in ```codebook.txt```.

```
================================================================================
Code Book for the tidy dataset 'data/tidy_dataset'
================================================================================

This dataset contains the average (arithmetic mean) of the mean and
standard deviation for each subject, activity and feature as measured over
mean value and standard deviation of a series of observations on body movement.
See: 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
for a description of the original dataset.

=======================================
Files in this directory:
=======================================
- "activities.txt"  
- "average_signal.txt"

Note: a file "subjects.txt" with the descriptions of subjects, i.e. persons,
that took part in the experiment is not present, for the simple reason that we
do not have other information on these persons than their id.

=======================================
File "activities.txt"
=======================================
Inventory of the activities that where done during the experiment.

- "id"          - The ID of the activity.

- "label"       - A short description of the activity.

=======================================
File "average_signal.txt"
=======================================
Table containing the average values on mean and standard deviation for each 
variable for each activity and each subject.

- "subjectid"   - The ID of the subject that took part in the experiment. The 
                subjectid does not point to a supplimentary file, because we 
                have no other information on subjects then their ID.

- "activityid"  - The ID of the activity that was undertaken for the 
                observation. Points to "id" in "activities.txt".

- "signal"      - The signal that was recorded for the observation.

- "averagemean" - The arithmetic mean or average of the mean variable of the 
                recorded signal for the subject, doing the activity. Units are
                normalized and bounded within [-1,1].

- "averagestandarddeviation" - The arithmetic mean or average of the 
                standard deviation variable of the recorded signal for the 
                subject, doing the activity. Units are normalized and bounded 
                within [-1,1].


```

