library(tidyverse)


# Where did social.csv come from? Quantitative Social Science.

x <- read_csv("data-raw/social.csv",

              # get rid of the annoying reading notes for best practice

              col_types = cols(
                sex = col_character(),
                yearofbirth = col_double(),
                primary2004 = col_double(),
                messages = col_character(),
                primary2006 = col_double(),
                hhsize = col_double()
              )) %>%

  # there is a str_X (str_to_upper()??) function for this, but I am more comfortable with
  # this approach to missing data when cleaning new data the first time around.
  # Otherwise this would be shorter work, also I discovered later that there is no (0) missing
  # data to me had in this original shaming data file... so here we are.

  mutate(gender = as.character(case_when(
    sex == "male" ~ "Male",
    sex == "female" ~ "Female",
    T ~ NA_character_
  ))) %>%

  # bear in mind the publication year of this study, I was initially
  # uncomfortable with birth years ~1900, but this isn't a 2020 study

  # parse_integer doesn't seem to want to work here

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

usethis::use_data(shaming, overwrite = TRUE)



