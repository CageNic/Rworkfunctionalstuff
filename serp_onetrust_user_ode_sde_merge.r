#######################################################################################################################################
# a script that takes the reports from SeRP SAM; ODE and SDE All Users                                                                #
# save the .xlsx files as .csv                                                                                                        #
# does various functionality that deduplicates if user appears in both ODE and SDE user files                                         #
# output file flags if they appeared in both ODE and SDE user files or just one making it easier to compare against a OneTrust report #
#######################################################################################################################################

library(dplyr)
library(magrittr)

Read in the SeRP SAM reports of ODE and SDE users... merge them, deduplicate them

# Read in the CSV files
SDE <- read.csv("C:/Users/andrewc/Downloads/OneTrust/data/Report-SDE-All_Users-SeRP.csv", stringsAsFactors = FALSE)
ODE <- read.csv("C:/Users/andrewc/Downloads/OneTrust/data/Report-ODE-All_Users-SeRP.csv", stringsAsFactors = FALSE)

# Rename columns for fullname ---
SDE <- SDE %>% rename(FirstName = `First.Name`, LastName = `Last.Name`)
ODE <- ODE %>% rename(FirstName = `First.Name`, LastName = `Last.Name`)

# Create fullname column ---
SDE <- SDE %>% mutate(fullname = paste(FirstName, LastName))
ODE <- ODE %>% mutate(fullname = paste(FirstName, LastName))

# Deduplicate within each file ---
SDE <- SDE %>% distinct(fullname, .keep_all = TRUE)
ODE <- ODE %>% distinct(fullname, .keep_all = TRUE)

# Add origin column BEFORE merging ---
SDE <- SDE %>% mutate(origin = "SDE")
ODE <- ODE %>% mutate(origin = "ODE")

# Merge datasets ---
combined <- full_join(
  SDE,
  ODE,
  by = "fullname",
  suffix = c(".SDE", ".ODE")
)

# Handle names that exist in both ---
# If a fullname exists in both, combine origin
combined <- combined %>%
  mutate(origin = ifelse(!is.na(origin.SDE) & !is.na(origin.ODE),
                         "SDE & ODE",
                         coalesce(origin.SDE, origin.ODE)
  )) %>%
  select(-origin.SDE, -origin.ODE)

# make fullname case insensitive in serp report... do the same for onetrust for better match
combined <- combined %>%
  mutate(fullname = tolower(fullname))

# optional - Save result to CSV
# can comment out if not required
write.csv(combined, "C:/Users/andrewc/Downloads/OneTrust/data/unique_fullnames_users_serp.csv", row.names = FALSE)

######################################
# read in the user log from OneTrust #
######################################

####################################################################################################
# need to check that all active SeRP entries are present in OneTrust                               #
# netermining who is ODE, SDE, office only once established that all SeRP users appear in OneTrust #
# is probabaly a manual check in the OneTrust user report                                          #
####################################################################################################

onetrust <- read.csv("C:/Users/andrewc/Downloads/OneTrust/data/SDE-Users-Log_2026-01-15.csv", stringsAsFactors = FALSE)

# make onetrust name case insensitive
# Clean OneTrust Name column (remove "(#R123)") pattern against username in name column

onetrust <- onetrust %>%
  mutate(Name = tolower(gsub("\\s*\\([^\\)]*\\)", "", Name)))

onetrust <- onetrust %>%
  mutate(
    Name_clean = gsub(" \\([^\\)]*\\)", "", Name)
  )

# Compare against merged fullname from serp

  combined <- combined %>%
  left_join(
    onetrust,
    by = c("fullname" = "Name_clean")
  ) %>%
  mutate(
    present_in_OneTrust = !is.na(Name),
    OneTrust_status = ifelse(
      present_in_OneTrust,
      "present in OneTrust",
      "not present in OneTrust"
    )
  )

# Save output
write.csv(
  combined,
  "C:/Users/andrewc/Downloads/OneTrust/data/serp_onetrust_user_match.csv",
  row.names = FALSE
)

rm(list = ls())
gc()

