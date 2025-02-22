############################
# filter dates using Arrow #
############################

# note that this also applies to dataframes and tibbles using dplyr, you do not need to use the mutate function when filtering
# this is because filter() can operate on temporary transformations, so you can apply as.Date directly to the column in the filter function itself

library(arrow)

df <- data.frame(
  ID = 1:10,
  Date = seq(as.Date("1901-01-01"), by = "month", length.out = 10),
)

arrow_df <- open_dataset(tf)

arrow_df |> 
  filter(
    Date >= as.Date('1901-03-01'), 
    Date <= as.Date('1902-06-01')
  )

# tibble

library(dplyr)

data <- tibble(
  id = 1:5,
  date_column = c("1901-02-20", "1902-02-21", "1903-02-22", "1904-02-23", "1905-02-24")
)

filtered_data <- data %>%
  filter(as.Date(date_column) >= as.Date("1901-02-22"))

# data.table
setDT(data)
data[date_column_1 >= as.Date('1901-04-20', format = "%Y-%m-%d")]

##########################################
# base R data.table dplyr set date class #
##########################################

library(dplyr)
library(data.table)
library(lubridate)

data <- tibble(
  id = 1:5,
  date_column_1 = c("1901-02-20", "1902-02-21", "1903-02-22", "1904-02-23", "1905-02-24"),
  date_column_2 = c("1901-02-20", "1902-02-21", "1903-02-22", "1904-02-23", "1905-02-24")
)

# base R

date_cols <- c('date_column_1', 'date_column_2')
data[date_cols] <- lapply(data[date_cols], as.Date, format = "%Y-%m-%d")

# dplyr

data <- data %>%
  mutate(
    date_column_1 = as.Date(date_column_1, format = "%Y-%m-%d"),
    date_column_2 = as.Date(date_column_2, format = "%Y-%m-%d")
    )

# data.table and lubdridate

setDT(data)

date_cols <- c('date_column_1', 'date_column_2')
data[, (date_cols) := lapply(.SD, ymd), .SDcols = date_cols]
