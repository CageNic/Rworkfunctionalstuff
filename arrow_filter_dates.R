############################
# filter dates using Arrow #
############################

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
