#######################################################################################################################################
# a script that takes the reports from SeRP SAM; ODE and SDE All Users                                                                #
# save the .xlsx files as .csv                                                                                                        #
# does various functionality that deduplicates if user appears in both ODE and SDE user files                                         #
# output file flags if they appeared in both ODE and SDE user files or just one making it easier to compare against a OneTrust report #
#######################################################################################################################################

library(dplyr)
library(magrittr)

# Read in the CSV files
SDE <- read.csv("C:/Users/andrewc/Downloads/OneTrust/data/Report-SDE-All_Users-SeRP.csv", stringsAsFactors = FALSE)
ODE <- read.csv("C:/Users/andrewc/Downloads/OneTrust/data/Report-ODE-All_Users-SeRP.csv", stringsAsFactors = FALSE)

# Rename columns for fullname
SDE <- SDE %>% rename(FirstName = `First.Name`, LastName = `Last.Name`)
ODE <- ODE %>% rename(FirstName = `First.Name`, LastName = `Last.Name`)

# Create fullname column
SDE <- SDE %>% mutate(serp_fullname = paste(FirstName, LastName))
ODE <- ODE %>% mutate(serp_fullname = paste(FirstName, LastName))

# Deduplicate within each file, some instances of same user appearing twice within SDE, or appearing twice within ODE
SDE <- SDE %>% distinct(serp_fullname, .keep_all = TRUE)
ODE <- ODE %>% distinct(serp_fullname, .keep_all = TRUE)

# Add origin column BEFORE merging - determins what platform user has access to
SDE <- SDE %>% mutate(origin = "SDE")
ODE <- ODE %>% mutate(origin = "ODE")

# Merge datasets
combined <- full_join(
  SDE,
  ODE,
  by = "serp_fullname",
  suffix = c(".SDE", ".ODE")
)

# Handle names that exist in both
# If a fullname exists in both, combine origin - SDE and ODE
# If a fullname is in neither - likely not have a serp account and be office only
# If a fullname in ODE only - ODE
# If a fullname in SDE only - SDE

combined <- combined %>% 
  mutate(
    origin.SDE = as.character(origin.SDE),
    origin.ODE = as.character(origin.ODE),
    origin = case_when(
      (!is.na(origin.SDE) & origin.SDE != "") & (!is.na(origin.ODE) & origin.ODE != "") ~ "SDE & ODE",
      !is.na(origin.SDE) & origin.SDE != ""                                                ~ origin.SDE,
      !is.na(origin.ODE) & origin.ODE != ""                                                ~ origin.ODE
    )
  ) %>%
  select(-origin.SDE, -origin.ODE)



# make fullname case insensitive in serp report
# do the same for onetrust for better match
combined <- combined %>%
  mutate(serp_fullname = tolower(serp_fullname))

# optional - Save result to CSV
# can comment out if not required
write.csv(combined, "C:/Users/andrewc/Downloads/OneTrust/data/unique_fullnames_users_serp.csv", row.names = FALSE)

######################################
# read in the user log from OneTrust #
######################################

####################################################################################################
# need to check that all active SeRP entries are present in OneTrust                               #
# determining who is ODE, SDE, office only once established that all SeRP users appear in OneTrust #
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
  # left_join(
  full_join(
    onetrust,
    by = c("serp_fullname" = "Name_clean")
  ) %>%
  mutate(
    present_in_OneTrust = !is.na(Name),
    OneTrust_status = ifelse(
      present_in_OneTrust,
      "present in OneTrust",
      "not present in OneTrust"
    )
  ) 
# remove the serp staff from the merged file
# remove unwanted columns from the merged file

combined_clean <- combined[
  !grepl("@chi\\.swan\\.ac\\.uk$|@swansea\\.ac\\.uk|@chi\\.ac\\.uk",
  combined$`Email.SDE`,
  ignore.case = TRUE), ] %>%
  select(-c("SDE.User.ID", "SDE.User.Access.to.SDE.Office", "SDE.User.Position",
  "SDE.User.Employment.Basis",
  "SDE.User.team", "SDE.User.Access.to.SDE.IT.System", "SDE.Nominated.residency.date.notification",
  "Username.SDE", "Email.SDE", "Organisation.SDE", "Username.ODE", "Email.ODE", "Organisation.ODE",
  "SDE.User.Last.Completed.IS.Refresher.Date", "SDE.User.next.refresher.training"))

  # those with no serp account but might have office access and therefore might be in OneTrust
  # just needs a check
  combined_clean$origin[is.na(combined_clean$origin)] <- "check office access type"

# Save output
write.csv(
  combined_clean,
  "C:/Users/andrewc/Downloads/OneTrust/data/serp_onetrust_user_match.csv",
  row.names = FALSE
)

rm(list = ls())
gc()




