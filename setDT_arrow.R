######################################################
# open dataset and convert to data.table in one step #
######################################################

library(arrow)
library(data.table)
library(dplyr)

my_parquet_dir <- '/home/trinity/R/DataParquet'

# needs dplyr for collect

setDT(collect(open_dataset(my_parquet_dir, format = "parquet"))) -> my_object
class(my_object)
# [1] "data.table" "data.frame"
