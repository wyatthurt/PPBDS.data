library(tidyverse)

# diff read function
x <- readRDS('data-raw/kenyadata.Rds')

kenyadata <- x %>%

  mutate(treatment = as.character(case_when(treatment_2d_10d == "Control" ~ "control",
                                            treatment_2d_10d == "SMS" ~ "SMS",
                                            treatment_2d_10d == "Canvass" ~ "canvass",
                                            treatment_2d_10d == "Local" ~ "local",
                                            treatment_2d_10d == "Local+Canvass" ~ "local + canvass",
                                            treatment_2d_10d == "Local+SMS" ~ "local + SMS"))) %>%

  mutate(poverty = pov,
         pop_density = pd) %>%

  select(treatment, poverty, distance, pop_density)

