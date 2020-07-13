library(tidyverse)

# Importing data

raw <- read_csv("data-raw/longevity.csv", col_types = cols(
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

z <- raw %>%

  # Name variable

  unite("firstmid", cand_first:cand_middle, sep = " ", na.rm = TRUE) %>%

  unite("name", firstmid:cand_last, sep = " ") %>%

  # Gender variable

  mutate(gender = as.character(case_when(
    female == 0 ~ "male",
    female == 1 ~ "female"
  ))) %>%

  # Ideology variable

  mutate(party = as.character(case_when(
    democrat == 1 ~ "democrat",
    republican == 1 ~ "republican",
    third == 1 ~ "third-party"
  ))) %>%

  # Regional variable

  mutate(region = as.character(case_when(
    reg_south == 1 ~ "south",
    reg_west == 1 ~ "west",
    reg_midwest == 1 ~ "midwest",
    reg_northeast == 1 ~ "northeast"
  ))) %>%

  # State variable

  mutate(state = area) %>%

  select(gender, region, state, year, party, status, living, cand_last, cand_first, cand_middle,
         death_date_imp, margin_pct_1, living_day_imp_post, living_day_post, living_day_imp_pre,
         living_day_pre, pc_inc_ann, ex, tot_expenditure)

