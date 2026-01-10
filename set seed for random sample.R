#####################################################################
# set seed for random sample reproduces same results in new session #
# not same session                                                  #
#####################################################################

library(data.table)
set.seed(1234)


data_x<- data.table( age = c(10, 24, 100, 58, 12, 22, 36, 30, 14, 68, 98, NA),
                    id = c(1:12),
                    gender = c('M', 'M', 'M', 'U', 'M', 'F', 'F', 'U', 'U', 'U', 'M', 'M'))

data_y <- data.table( name = c('Bob', 'Rod', 'Tod', 'Bill', 'Gill', 'Lorna'),
                      accpetable = c(1, 1, 0, 1, 0, 1),
                    id = c(1:6))

fwrite(data_x, file = 'test_x.csv', sep = ',')
fwrite(data_x, file = 'test_y.csv', sep = ',')

str(data_x)
str(data_y)

# data_x

# remove NA from age
# age 30 - 60
# Male or Female

data_x <- data_x[(!is.na(age))]
data_x
data_x <- data_x[(gender == 'M' | gender == 'F') & (age >= 30 | age <= 60)]
data_x

# inner join with data_y
# nomatch = 0
# only ids in both

setkey(data_x, 'id')
data_x
setkey(data_y, 'id')
data_y

merged_data <- data_x[data_y, nomatch = 0]
merged_data

merged_data <- merged_data[accpetable == 1]
merged_data

# random sample of 2 from merged_data

# base R
merged_data[sample(1:nrow(merged_data), 2), ]

# 1:  10  1      M  Bob          1
# 2:  24  2      M  Rod          1

# dplyr
dplyr::sample_n(merged_data, 2)

# 1:  24  2      M   Rod          1
# 2:  22  6      F Lorna          1
