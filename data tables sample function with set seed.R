#############################################
# data tables sample function with set seed #
#############################################

library(data.table)
set.seed(10)

mtcars <- data.table(mtcars)

nrow(mtcars)
# 32

# create a sample of 20 records
# from the 32 records in the data table

# use .N in conjunction with the amount required from the sample

mtcars[sample(.N, 20)]
