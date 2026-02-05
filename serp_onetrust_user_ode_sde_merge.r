####################################################################################################
# SeRP (SDE / ODE) vs OneTrust user reconciliation
####################################################################################################

library(dplyr)
library(magrittr)

################################
# Read SeRP SDE / ODE files
################################

SDE <- read.csv(
  "C:/Users/andrewc/Downloads/OneTrust/data/Report-SDE-All_Users-SeRP.csv",
  stringsAsFactors = FALSE
)

ODE <- read.csv(
  "C:/Users/andrewc/Downloads/OneTrust/data/Report-ODE-All_Users-SeRP.csv",
  stringsAsFactors = FALSE
)

# Rename columns for fullname
SDE <- SDE %>% rename(FirstName = `First.Name`, LastName = `Last.Name`)
ODE <- ODE %>% rename(FirstName = `First.Name`, LastName = `Last.Name`)

# Create fullname
SDE <- SDE %>% mutate(serp_fullname = paste(FirstName, LastName))
ODE <- ODE %>% mutate(serp_fullname = paste(FirstName, LastName))

# Deduplicate within each file
SDE <- SDE %>% distinct(serp_fullname, .keep_all = TRUE)
ODE <- ODE %>% distinct(serp_fullname, .keep_all = TRUE)

# Add origin BEFORE merge
SDE <- SDE %>% mutate(origin = "SDE")
ODE <- ODE %>% mutate(origin = "ODE")

################################
# Merge SDE + ODE
################################

combined <- full_join(
  SDE,
  ODE,
  by = "serp_fullname",
  suffix = c(".SDE", ".ODE")
)

# Resolve origin
combined <- combined %>% 
  mutate(
    origin.SDE = as.character(origin.SDE),
    origin.ODE = as.character(origin.ODE),
    origin = case_when(
      !is.na(origin.SDE) & !is.na(origin.ODE) ~ "SDE & ODE",
      !is.na(origin.SDE)                      ~ "SDE",
      !is.na(origin.ODE)                      ~ "ODE",
      TRUE                                    ~ NA_character_
    )
  ) %>%
  select(-origin.SDE, -origin.ODE)

# Make fullname case-insensitive
combined <- combined %>%
  mutate(serp_fullname = tolower(serp_fullname))

################################
# Read OneTrust user log
################################

onetrust <- read.csv(
  "C:/Users/andrewc/Downloads/OneTrust/data/SDE-Users-Log_2026-01-15.csv",
  stringsAsFactors = FALSE
)

# Clean OneTrust names
onetrust <- onetrust %>%
  mutate(
    Name = tolower(gsub("\\s*\\([^\\)]*\\)", "", Name)),
    Name_clean = Name
  )

################################
# Join SeRP users to OneTrust
################################

combined <- combined %>%
  full_join(
    onetrust,
    by = c("serp_fullname" = "Name_clean")
  ) %>%
  mutate(
    serp_presence = case_when(
      !is.na(origin)                         ~ "serp-person",
      is.na(origin) & !is.na(Name)           ~ "no SeRP but OneTrust",
      TRUE                                   ~ "unknown"
    ),
    present_in_OneTrust = !is.na(Name),
    OneTrust_status = ifelse(
      present_in_OneTrust,
      "present in OneTrust",
      "not present in OneTrust"
    )
  )

################################
# Lock down origin for non-SeRP users
################################

combined <- combined %>%
  mutate(
    origin = case_when(
      serp_presence == "no SeRP but OneTrust" ~ "no SeRP but OneTrust",
      is.na(origin)                        ~ "check office access type",
      TRUE                                 ~ origin
    )
  )

################################
# Clean output (remove SeRP staff etc.)
################################

combined_clean <- combined[
  !grepl(
    "@chi\\.swan\\.ac\\.uk$|@swansea\\.ac\\.uk|@chi\\.ac\\.uk",
    combined$`Email.SDE`,
    ignore.case = TRUE
  ),
] %>%
  select(
    -c(
      "SDE.User.ID",
      "SDE.User.Access.to.SDE.Office",
      "SDE.User.Position",
      "SDE.User.Employment.Basis",
      "SDE.User.team",
      "SDE.User.Access.to.SDE.IT.System",
      "SDE.Nominated.residency.date.notification",
      "Username.SDE",
      "Email.SDE",
      "Organisation.SDE",
      "Username.ODE",
      "Email.ODE",
      "Organisation.ODE",
      "SDE.User.Last.Completed.IS.Refresher.Date",
      "SDE.User.next.refresher.training"
    )
  )

################################
# Save output
################################

write.csv(
  combined_clean,
  "C:/Users/andrewc/Downloads/OneTrust/data/serp_onetrust_user_match.csv",
  row.names = FALSE
)

rm(list = ls())
gc()
