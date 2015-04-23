This file is part of solution to Coursera Getting and Cleaning Data Course Project. It is a code book, which documents the data used in processing, transformations on these data, variables created and outputs generated.

# Input data

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

`features.txt` contains names of measures stored in `X_` files. It is used in processing to determine which columns contain *measures of interest*, i.e. mean or standard deviation. It is also used to provide names of these columns in the output file. As these columns do not adhere to column naming conventions in R, they must be transformed first.


# Transformations
features is read as csv with column names `feature_no` and `feature_name`.
New column `interest` is built: Logical, TRUE if `feature_name` contains any of words "mean" or "std", where words are substrings separated by "-" or "(".
New dataframe is then created with filtered rows: row is saved only if `interest` is TRUE.
New column `corr.name` is built: Character, contains `feature_name` with characters "-", "(", ")" and "," replaced with "_". This results in a name which is an R-acceptable column name.

X_ are appended
y_ are appended
subject_ are appended

X, y and subject are merged together. They are processed as columns of the same dataset - no join key necessary, order of rows decides. Saved as a data table `dt.data`.
`dt.data` is sorted by `activity` and `subject`.
`dt.data` is joined to activity labels by `activity`. Activity identifier is dropped as unnecessary.
Aggregations are calculated on every measure column.
Output dataset containing 68 columns (2 keys - `activity` and `subject`; 66 measure columns) is saved as blank-separated text file `measurement_means.txt`.



Variables created

Output


