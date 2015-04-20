This file is part of solution to Coursera Getting and Cleaning Data Course Project. It is a code book, which documents the data used in processing, transformations on these data, variables created and outputs generated.

Data used in processing
X_
y_
subject_

activity_labels.txt
features.txt

Transformations
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


