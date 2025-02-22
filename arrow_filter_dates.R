############################
# filter dates using Arrow #
############################

# note that this also applies to dataframes and tibbles using dplyr, you do not need to use the mutate function when filtering
# this is because filter() can operate on temporary transformations, so you can apply as.Date directly to the column in the filter function itself

library(arrow)

df <- data.frame(
  ID = 1:10,
  Date = seq(as.Date("2024-01-01"), by = "month", length.out = 10),
)

arrow_df <- open_dataset(tf)

arrow_df |> 
  filter(
    Date >= as.Date('2024-03-01'), 
    Date <= as.Date('2024-06-01')
  )

# tibble

library(dplyr)

data <- tibble(
  id = 1:5,
  date_column = c("2025-02-20", "2025-02-21", "2025-02-22", "2025-02-23", "2025-02-24")
)

filtered_data <- data %>%
  filter(as.Date(date_column) >= as.Date("2025-02-22"))
