# work in progress preparing the data set from  Harris, Kamindo, and Windt (2020):
# Electoral Administration in Fledgling Democracies: Experimental Evidence from Kenya

# The replication data can be located at:
# https://dataverse.harvard.edu/dataset.xhtml;jsessionid=786d92e2aec3933f01bd0af48ec0?persistentId=doi%3A10.7910%2FDVN%2FUT25HQ&version=&q=&fileTypeGroupFacet=%22Code%22&fileAccess=&fileTag=&fileSortField=&fileSortOrder=

#  DISCARDED VARIABLES: weight (needed?), INTERVENTION (same as the first one?), DATE_DAY1 (include this or date or both?)
# TO-DO: Go from individuals --> communities, documentation not showing up

library(tidyverse)
library(usethis)

# diff read function
x <- readRDS('data-raw/kenyadata.Rds')

x <- x %>%

  # Recoding values for treatment variable

  mutate(treatment = as.factor(case_when(treatment_2d_10d == "Control" ~ "control",
                                            treatment_2d_10d == "SMS" ~ "SMS",
                                            treatment_2d_10d == "Canvass" ~ "canvass",
                                            treatment_2d_10d == "Local" ~ "local",
                                            treatment_2d_10d == "Local+Canvass" ~ "local + canvass",
                                            treatment_2d_10d == "Local+SMS" ~ "local + SMS"))) %>%

  # Recoding values for day of the week

  mutate(day = case_when(day == "Monday" ~ "monday",
                         day == "Tuesday" ~ "tuesday",
                         day == "Wednesday" ~ "wednesday",
                         day == "Thursday" ~ "thursday",
                         day == "Friday" ~ "friday")) %>%

  # Renaming variables for poverty, population density, date, block id, polling station id

  mutate(poverty = pov,
         pop_density = pd,
         date = DATE,
         block = BLOCK_ID,
         poll_station = PS_ID) %>%

  # Selecting final variabless

  select(treatment, poverty, distance, pop_density, date, block, poll_station, day, reg_byrv13, reg, rv13) %>%

  as_tibble()


stopifnot(nrow(x) > 1000000)
stopifnot(ncol(x) == 11)
stopifnot(is.factor(x$treatment))


kenya <- x
usethis::use_data(kenya, overwrite = TRUE)

