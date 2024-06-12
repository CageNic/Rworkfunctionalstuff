#################################
# read a file with data.table   #
# clean it                      #
# write it to a sqlite database #
#################################

# gsub and names function to rename column name rather than := data.table method

library(RSQLite)
library(DBI)
library(data.table)

my_data <- fread('title.basics.tsv',quote = "")

# drop columns
my_data[, c("tconst", "isAdult", "genres", "endYear"):=NULL]

# rename columns
names(my_data) = gsub('startYear', 'Year', names(my_data))



# write to SQLite
# create a database and connect to it
my_db <- 'test.db'
my_table <- 'test_table'

conn <- dbConnect(RSQLite::SQLite(), my_db)

# write the my_data data table to a SQLite field

dbWriteTable(conn = conn, name = my_table, value = my_data,
                    overwrite = TRUE, append = FALSE,
                    header = TRUE, row.names = FALSE, sep = "\t", eol = "\n")

# show list of tables and fields
dbListTables(conn)
dbListFields(conn, 'test_table')

# query

# Indexing for High Performance Queries
# As datasets grow larger in SQLite, adding indexes over columns involved in frequent JOIN, ORDER BY and WHERE filtering operations
# can significantly improve query performance.

# how to add and leverage indexes in SQLite from R.

# create a basic index using dbExecute():
  
  dbExecute(
    conn,
    "CREATE INDEX date ON test_table (Year);" 
  )

# This adds an index named date on the Year column in the test_table
# With the index in place, any queries involving filtering or sorting by the Year field will execute much faster
# The index on Year avoids full table scans to retrieve the relevant records in optimal order
  
  date <- dbGetQuery(
    conn,
    'SELECT "originalTitle", "Year" 
    FROM "test_table"
   WHERE Year <= 1932
   ORDER BY Year DESC'
  )

date

# disconnect
dbDisconnect(conn)
