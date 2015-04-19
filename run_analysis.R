library( LaF )
library( data.table )

# #############################################################################
#
#     Read activities lables list
#
#  Convert it into data.table. Sort by activity number.
#  Name activity number as "y" as this is consistent with further processing.
#
# #############################################################################
df.labels <- read.csv( "activity_labels.txt", header = F, sep = " ", stringsAsFactors = F, col.names = c("y", "activity_label") )
dt.labels <- data.table( df.labels )
setkey( dt.labels, y )


# #############################################################################
#
#     Read features list
#
#  Find measurements of mean or standard deviation.
#  Translate their names into R-acceptable column names.
#
#  Build column:
#   corr.name, character, R-acceptable column name
#
#  Save only these rows, which describe mean or stddev.
#
# #############################################################################
df.feat <- read.csv( "features.txt", header = F, sep = " ", stringsAsFactors = F, col.names = c("feature_no", "feature_name") )

# Only mean or stddev rows.
df.feat$interest <- unlist( lapply( df.feat$feature_name, function( x ) { return(
                                any( "mean" ==  unlist( strsplit( x, "[-(]") ) )
                                || any( "std" ==  unlist( strsplit( x, "[-(]") ) )
                            ) } ) )
df.feat.sel <- df.feat[df.feat$interest,]

# Build R-acceptable names - translate offending characters to underscore
f2 <- function( x ) { return( gsub( "[-(),]", "_", x ) ) }
df.feat.sel$corr.name <- unlist( lapply( df.feat.sel$feature_name, f2 ) )


# #############################################################################
#
#    Read measurement inputs datasets
#
#  Read main input datasets using LaF library, large fwf files.
#  Append train and test datasets.
#  Select relevant columns only.
#  Return dataframe containing all rows from both inputs.
#
# #############################################################################
laf.train <- laf_open_fwf(
    file.path( "train", "X_train.txt" )
    , column_types = rep("double", 561)
    , column_widths = rep(16, 561)
    )

laf.test <- laf_open_fwf(
    file.path( "test", "X_test.txt" )
    , column_types = rep("double", 561)
    , column_widths = rep(16, 561)
    )

begin( laf.train )
begin( laf.test )

df.X <- rbind(
    next_block( laf.train, nrows = 10000, columns = df.feat.sel$feature_no )
    , next_block( laf.test, nrows = 10000, columns = df.feat.sel$feature_no )
    )
names( df.X ) <- df.feat.sel$corr.name
    

# #############################################################################
#
#    Read categorical inputs datasets
#
#  Append train and test datasets.
#  Return dataframe containing all rows from both inputs.
#
#  This will be done for activities and subjects datasets.
#  Input files are read as csv, as subject row length varies.
#
# #############################################################################
f.append <- function( source ) {

    df.train <- read.csv( file.path( "train", paste( source, "_train.txt", sep = "" ) ), header = F, sep = " ", stringsAsFactors = F, col.names = source )
    df.test <- read.csv( file.path( "test", paste( source, "_test.txt", sep = "" ) ), header = F, sep = " ", stringsAsFactors = F, col.names = source )
    return( rbind( df.train, df.test ) )
    }
    
# #############################################################################
#
#    Read measures datasets
#
#  Build dataframe df.X containing measures from both inputs.
#
# #############################################################################
df.y <- f.append( "y" )

# #############################################################################
#
#    Read measures datasets
#
#  Build dataframe df.X containing measures from both inputs.
#
# #############################################################################
df.subj <- f.append( "subject" )


# #############################################################################
#
#    Perform keyless join of input datasets.
#
#  Input datasets contain records in the right order.
#  They are simply combined in one dataset.
#  The result is converted into data.table and sorted by activity and subject.
#
# #############################################################################
df.data <- cbind( df.y, df.subj, df.X )
dt.data <- data.table( df.data )
setkey(dt.data, y, subject )


# #############################################################################
#
#    Label the data.
#
#  Join activity labels to input data.
#  Drop activity id column as no longer necessary.
#
# #############################################################################
dt.labelled <- subset( dt.data[dt.labels], select = -y )


# #############################################################################
#
#    Generate result.
#
#  Calculate means of measurement columns.
#  Save result as a text file.
#
# #############################################################################
dt.aggr <- dt.labelled[ , lapply( .SD, mean ), by = c( "activity_label", "subject" ) ]
write.table( dt.aggr, file.path( "..", "measurement_means.txt" ), row.names = F )

