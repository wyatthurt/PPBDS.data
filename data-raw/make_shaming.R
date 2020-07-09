library(tidyverse)

# This dataset is from Gerber, Green & Larimer (2008), and was originally
# published as part of a study in the American Political Science Review.
# The raw data and details of the study can be accessed at
# https://isps.yale.edu/research/data/d001. [UPDATE: As of 07/08/20, the website
# of Yale's Institute of Social and Policy Studies is currently not accessible.]

# Reading in the data. I excluded variables that represent internal IDs the
# researchers assigned to households ("hh_id") and clusters of randomization
# ("cluster"), as well as variables that show the mean voter turnout per household
# in the 2004 elections ("p2004_mean" and "g2004_mean"). None of these are particularly
# relevant for analyzing and interpreting the data. Furthermore, I also excluded two
# variables that show the voting histories of the 2000 elections ("p2000" and "g2000").
# They provide little insight in addition to the remaining histories from 2002 and 2004,
# and we do not want to overwhelm people.

x <- read_csv("data-raw/social_original.csv",
              col_types = cols(sex = col_character(),
                               yob = col_integer(),
                               p2002 = col_character(),
                               p2004 = col_character(),
                               g2002 = col_character(),
                               g2004 = col_character(),
                               treatment = col_factor(),
                               voted = col_character(),
                               hh_size = col_integer(),
                               numberofnames = col_integer())) %>%

  # Renaming variables.

  rename(birth_year = yob,
         primary_02 = p2002,
         primary_04 = p2004,
         general_02 = g2002,
         general_04 = g2004,
         no_of_names = numberofnames) %>%

  # Recoding character values.

  mutate(sex = str_to_title(sex),
         primary_02 = str_to_title(primary_02),
         primary_04 = str_to_title(primary_04),
         general_02 = str_to_title(general_02),
         general_04 = str_to_title(general_04)) %>%

  # Ordering variables.

  select(sex, birth_year,
         primary_02, general_02,
         primary_04, general_04,
         treatment, voted,
         hh_size, no_of_names)


# Check and save.

stopifnot(x %>% drop_na() %>% nrow() == 344084)

shaming <- x

usethis::use_data(shaming, overwrite = TRUE)



