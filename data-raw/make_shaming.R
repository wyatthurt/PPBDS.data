library(tidyverse)

x <- read_csv("data-raw/social.csv") %>%
  mutate(gender = as.character(case_when(
    sex == "male" ~ "Male",
    sex == "female" ~ "Female",
    T ~ NA_character_
  ))) %>%

  mutate(birth_yr = as.integer(yearofbirth)) %>%

  mutate(treatment = parse_factor(messages)) %>%

  # this doesn't change the # of
  # records... this data is suspiciously clean

  # drop_na() %>%

  mutate(vote_04 = primary2004,
         vote_06 = primary2006) %>%

  select(-sex, -yearofbirth, -messages,
         - primary2004, -primary2006)


stopifnot(x %>% drop_na() %>% nrow() == 305866)

shaming <- x

usethis::use_data(shaming, overwrite = T)



