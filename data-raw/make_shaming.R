library(tidyverse)

# Where did social.csv come from? Quantitative Social Science.

x <- read_csv("data-raw/social.csv",
              col_types = cols(sex = col_character(),
                               yearofbirth = col_integer(),
                               primary2004 = col_double(),
                               messages = col_character(),
                               primary2006 = col_double(),
                               hhsize = col_integer())) %>%

  # Should we set the primary voting history to integer, or perhaps logical?

  # Bear in mind the publication year of this study, I was initially
  # uncomfortable with birth years ~1900, but this isn't a 2020 study

  mutate(messages = parse_factor(messages,
                                  levels = c("Control", "Civic Duty",
                                             "Hawthorne", "Neighbors"))) %>%

  # This data is suspiciously clean

  rename(birth = yearofbirth,
         treatment = messages,
         vote_04 = primary2004,
         vote_06 = primary2006) %>%
  select(sex, birth, hhsize, everything())


# Check and save

stopifnot(x %>% drop_na() %>% nrow() == 305866)

shaming <- x

usethis::use_data(shaming, overwrite = TRUE)



