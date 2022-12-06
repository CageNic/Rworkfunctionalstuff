#######################################################
# data table used with working functionality examined #
# covers various techniques                           #
#######################################################                    

# feasibility to check acceptable pats eligible fort linkage

library(aws.s3)
library(data.table)
library(lubridate)

observation_file <- "pathway/file/"
dt <- fread(observation_file, sep = "\t", na.strings = c("", '', NA, "NULL"))

# drop unwanted columns
dt[, c('col1', 'col2') := NULL]
str(dt)
dt[, .N]
uniqueN(dt,[, rid])

# make date columns date class

date_vars <- c('date_col1', 'date_col2')
dt[, (date_vars) := lapply(.SD, dmy), .SDcols = date_vars]

min(dt$date_col1, na.rm = TRUE)
max(dt$date_col1, na.rm = TRUE)

# if date_cols2 is blank - use the date from date_cols1

dt[is.na(date_cols2), date_cols2 := date_cols1]

# apply some filters

start_date <- dmy("01/01/2017")
end_date_ <- dmy("01/01/2022")

filtered_dt <- dt[date_col2 >= start_date & date_col2 <= end_date]
rm(dt)
filtered_dt[, .N]
uniqueN(filtered_dt[, rid])

# reverse sort on date_col2
# - sign for reverse sort

setorder(filtered_dt, -date_col2)

# since reverse sorted... deduplication keeps eariest date for rid

deduplicated_dt <- uique(filtered_dt, by = "rid")
deduplicated_dt[, .N]

# read in another file (from aws) to merge with deduplicated_dt

pats_file <- "/path/file"
pats_data <- s3read_using(FUN = data::table::fread,
                          object = pats_file, na.strings = c("", NA, "NULL"))

# setkey for pats_data and deduplicated_dt for an inner join

setkey(pats_data, "rid"); setkey(deduplicated_dt, by = "rid")

# overwrite deduplicated data for the merge

deduplicated_dt <- deduplicated_dt[pats_data, nomatch = 0]

# check the NAs
deduplicated_dt[, .N, is.na(a_particular_column)]

# a list of practices to exclude in the data
# these values are in the column pracid - so that is the column to use with %in%
# use ! against the column for %in% against the list, so... not in
# ensure region column has a value of 1 - 9... no need to create a list for that, just use a range
# and male / female in gender column... no need for an OR boolean when using %n%

duplicate_practices <- as.integer(c(1234, 4321, 2468, 8642))

merged_dt <- deduplicated_dt[!pracid %in% duplicate_practices & region %in% c(1:9) & gender %in% c('M', 'F')]

rm(deduplicated_dt)

# clear garbage to free memory
gc()

# read and merge the eligibility file

linkage_file <- "/pathway/file"
linkage_data <- s3read_using(FUN = data::table::fread,
                          object = linkage_file, na.strings = c("", NA, "NULL"))

# ensure linkage data has 1 for required columns

linkage_data <- linkage_data[colx == 1 & coly == 1 & colz == 1]

# do setkey ad inner join with merged_dt
# overwrite merged_dt to hold the join data of both merged_dt ad linkage_dt
# see earlier code for inner join

rm(linkage_data)
gc()

# create some dates to filter on
# is.na !is.na is used a lot to indicate whether or not a date can be blank
# which might indicate there is no end date - which is ok

census_date <- dmy("21/03/2021")
merged_data <- merged_data[(date_column1 > census_date | is.na(date_column1)) & ((date_col2 > census_date) | is.na(date_col3))]
merged_data[, .N]

merged_data <- merged_data[date_column1 <= census_data & !is.na(date_column1)]

# write the rid column onl to a file
# need to make the rid column a data table if using fwrite

pats_list <- data.table("rid" = merged_data$rid)
fwrite(pats_list, file = "/pathway/filename")
