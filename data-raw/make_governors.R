library(tidyverse)

# Importing data

z <- read_csv("data-raw/longevity.csv", col_types = cols(
  .default = col_double(),
  area = col_character(),
  cand_last = col_character(),
  cand_first = col_character(),
  cand_middle = col_character(),
  party = col_character(),
  death_date_imp = col_date(format = ""),
  living = col_character(),
  status = col_character()
))

z <- z %>%

  # Gender variable

  mutate(gender = as.character(case_when(
    female == 0 ~ "male",
    female == 1 ~ "female"
  ))) %>%

  # Ideology variable

  mutate(party = as.character(case_when(
    democrat == 0 ~ "democrat",
    republican == 1 ~ "republican"
  ))) %>%

  # Regional variable

  mutate(region = as.character(case_when(
    reg_south == 1 ~ "south",
    reg_west == 1 ~ "west",
    reg_midwest == 1 ~ "midwest",
    reg_northeast == 1 ~ "northeast"
  )))
