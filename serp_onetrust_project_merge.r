# Load required package
library(dplyr)


# check.names = FALSE, keep spaces in header row if any column names have them - rename after
# read in the SeRP SDE project report file
serp <- read.csv("C:/Users/andrewc/Downloads/OneTrust/data/Report-SDE-SeRP.csv", stringsAsFactors = FALSE, check.names = FALSE)

# read in the OneTrust SDE project log file
onetrust <- read.csv("C:/Users/andrewc/Downloads/OneTrust/data/SDE Project Log.csv", stringsAsFactors = FALSE, check.names = FALSE)


names(serp)
names(onetrust)

# ------------------------------------------------------------
# Rename key in onetrust and duplicate keys BEFORE join
# ------------------------------------------------------------

onetrust <- onetrust %>%
  rename(SDE_Project_ID = `SDE Project ID`)

# Full join AND keep both join keys
output <- full_join(
  serp,
  onetrust,
  by = c("Code" = "SDE_Project_ID"),
  keep = TRUE
)

# Add matching flag
output <- output %>%
  mutate(
    matchingID = !is.na(Code) & !is.na(SDE_Project_ID)
  )

# Inspect
head(output)
table(output$matchingID)

# ------------------------------------------------------------
# Write output to CSV (optional)
# ------------------------------------------------------------
write.csv(output, "serp_onetrust_project_match.csv")

rm(list = ls())
gc()

