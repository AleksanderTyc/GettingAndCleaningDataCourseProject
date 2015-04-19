This repository contains solution to Coursera Getting and Cleaning Data Course Project.

This project consists of four files:
- README
- Code Book
- Run analysis script
- Output file

A brief description of each of these files follows.

## Code Book
The file `codebook.md` documents the data used in processing, transformations on these data, variables created and outputs generated.

# Run analysis script
Run analysis is an R script stored as `run_analysis.R`. The script performs data processing and output creation. It assumes that:
- the input data have been downloaded, uncompressed and saved on the local filesystem;
- the current working directory of R sessions is the input data root directory (UCI HAR Dataset), so that for example `activity_labels.txt` refers to activity labels table, and `test/y_test.txt` refers to test subjects ids performing activities;
- packages `LaF` and `data.table` are installed in the R system.
The script uses `LaF` library to perform data read operation on *large* input files. When trying to read them as base data frames, the 8GB RAM system ran out of memory.
The script uses `data.table` library to perform table joins, grouping, summarising and data selection.

## Output file
Output is stored in `measurement_means.txt` file in the working directory. The file contains measured means calculated by activity and subject.


