This file is part of solution to Coursera Getting and Cleaning Data Course Project. It is a code book, which documents the data used in processing, transformations on these data, variables created and outputs generated.

## Input data

Data stored in the following files are used as input in the processing:
- test/X_test.txt
- train/X_train.txt
- y_test.txt
- y_train.txt
- subject_test.txt
- subject_train.txt
- activity_labels.txt
- features.txt

`X_test.txt` and `X_train.txt` contain values of measures, one row per test. `y_test.txt` and `y_train.txt` contain id of activity performed in each test, one row per test. `subject_test.txt` and `subject_train.txt` contain id of test subject (person) performing the test, one row per test. n-th row on `X_` file corresponds to n-th row on `y_` file corresponds to n-th row on `subject_` file by dataset type (train or test), so each observation (who, what activity, results) is acutally stored on three separate files.

`activity_labels.txt` contains two columns: activity id and activity label. It is used in processing to translate activity id's into meaningful labels to describe activities.

`features.txt` contains two columns: measure number and measure name of measures stored in `X_` files. It is used in processing to determine which columns contain *measures of interest*, i.e. mean or standard deviation. It is also used to provide names of these columns in the output file. As these names do not conform to column naming conventions in R, they must be transformed first.


## Transformations

### Step 1.
`activity_labels.txt` is read and keyed by activity id. This allows easy join by activity id in the future. Resulting data table `dt.labels` contains both columns and all input rows.

### Step 2.
`features.txt` is read into a data frame `df.feat`.
A logical column `interest` is built and added to `df.feat`: TRUE if feature name contains any of words "mean" or "std", where words are substrings separated by "-" or "(".
New data frame `df.feat.sel` is then created with rows filtered from `df.feat`: row is saved only if `interest` is TRUE.
New column `corr.name` is built and added to `df.feat.sel`: Character, contains feature name with characters "-", "(", ")" and "," replaced with "_". This results in a name which is an R-acceptable column name.

### Step 3.
`X_test.txt` and `X_train.txt` are read and appended into a data frame `df.X`. The processing takes advantage of `LaF` package functionality to select columns of interest, whose indices were determined in step 2.

### Step 4.
`y_test.txt` and `y_train.txt`  are read and appended into a data frame `df.y`.

### Step 5.
`subject_test.txt` and `subject_train.txt`  are read and appended into a data frame `df.subj`.

### Step 6.
Data frames `df.X`, `df.y` and `df.subj` are merged side-by-side into a single dataset and stored as data table `dt.data`. `dt.data` is sorted by activity id and test subject id.

### Step 7.
`dt.data` is joined by activity id to `dt.labels`. Resulting data table is stored as `dt.labelled`.

### Step 8.
Summaries of *measures of interest* are calculated separately for each group (activity label, test subject id). Output is saved to `measurement_means.txt` file in the parent directory.


## Variables created

#### activity_id


## Output
The code creates a single output file `measurement_means.txt` stored in the parent directory. The file is a blank-separated text file and it contains 68 columns. The first two are `activity_label` and `subject` and the following 66 are means of *measures of interest*. Their names are derived from `features.txt` file.
As there are 30 test subjects, each peforming 6 activities, the file has 180 rows of data, hence 181 rows in total, including header.

