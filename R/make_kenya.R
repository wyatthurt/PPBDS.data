library(tidyverse)

# diff read function
x <- readRDS('data-raw/kenyadata.Rds')

kenyadata <- x %>%

  # Recoding values for treatment variable

  mutate(treatment = as.character(case_when(treatment_2d_10d == "Control" ~ "control",
                                            treatment_2d_10d == "SMS" ~ "SMS",
                                            treatment_2d_10d == "Canvass" ~ "canvass",
                                            treatment_2d_10d == "Local" ~ "local",
                                            treatment_2d_10d == "Local+Canvass" ~ "local + canvass",
                                            treatment_2d_10d == "Local+SMS" ~ "local + SMS"))) %>%

  mutate(day = case_when(day == "Monday" ~ "monday",
                         day == "Tuesday" ~ "tuesday",
                         day == "Wednesday" ~ "wednesday",
                         day == "Thursday" ~ "thursday",
                         day == "Friday" ~ "friday")) %>%

  # Renaming variables

  mutate(poverty = pov,
         pop_density = pd,
         date = DATE,
         block = BLOCK_ID,
         poll_station = PS_ID) %>%

  # Selecting final variabless

  select(treatment, poverty, distance, pop_density, date, block, poll_station, day

         #  Registered voters at polling station during
         # intervention period divided by registered voters
         # at that same station in 2013

         reg_byrv13, reg, rv13)

# DISCARDED: w (weights), INTERVENTION (?? same as the first one?), DATE_DAY1,
