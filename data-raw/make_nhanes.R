# work in progress of the National Health and Nutrition Examination Survey dataset

library(NHANES)
library(tidyverse)

x <- NHANES %>%

  # Selecting 5 relevant variables

  select(Gender, SurveyYr, Age, Race1, Education, HHIncome, Weight,
         Height, BMI, Pulse, Diabetes, HealthGen, Depressed, nPregnancies,
         SleepHrsNight) %>%

  # Cleaning SurveyYr. Currently 20XX_YY, but will just be represented as 20XX.

  separate(SurveyYr, into = c("year", NA),
           sep = "_") %>%

  # Also making it into an integer

  mutate(year = as.integer(year)) %>%

  # Making depressed as an ordered factor

  mutate(depressed = as.ordered(case_when(
    Depressed == "None" ~ "none",
    Depressed == "Several" ~ "several",
    Depressed == "Most" ~ "most"))) %>%

  # Making general health a numbered variable

  mutate(health = as.integer(case_when(
    HealthGen == "Poor" ~ 1,
    HealthGen == "Fair" ~ 2,
    HealthGen == "Good" ~ 3,
    HealthGen == "Vgood" ~ 4,
    HealthGen == "Excellent" ~ 5))) %>%

  # Cleaning up education variable names. Should we be using ordered factors?

  mutate(education = as.ordered(case_when(
    Education == "8th Grade" ~ "middle school",
    Education == "9 - 11th Grade" ~ "middle school",
    Education == "High School" ~ "high school",
    Education == "Some College" ~ "some college",
    Education == "College Grade" ~ "college"))) %>%

  # Cleaning up race names
  # They did not record race well in this dataset

  mutate(race = as.character(case_when(
    Race1 == "Black" ~ "black",
    Race1 == "Hispanic" ~ "hispanic",
    Race1 == "White" ~ "white",
    Race1 == "Mexican" ~ "mexican",
    Race1 == "Other" ~ "other"
  ))) %>%

  # Making income a numbered variable
  # MB: Not sure what to do with "Other" variable
  # MB: Also, 55k to 75k group is missing? Where is it?

  mutate(income = as.integer(case_when(
    HHIncome == "more 99999" ~ 5,
    HHIncome == "75000-99999" ~ 4,
    HHIncome == "25000-34999" ~ 1,
    HHIncome == "35000-44999" ~ 2,
    HHIncome == "45000-54999" ~ 3,
    HHIncome == "(Other)" ~ 0))) %>%

  # Making diabetes an integer variable. What is that comma doing!??:

  mutate(diabetes = as.integer(case_when(
    Diabetes == "Yes" ~ 1,
    Diabetes == "No" ~ 0,))) %>%

  # Fixing variable names

  mutate(gender = as.character(Gender),
         age = as.integer(Age),
         sleep = SleepHrsNight,
         height = Height,
         bmi = BMI,
         weight = Weight,
         pregnancies = nPregnancies,
         pulse = Pulse) %>%

  # Left out: diabetes

  select(gender, year, age, race, education, income, weight,
         height, bmi, health, depressed, pregnancies,
         sleep, pulse)



stopifnot(nrow(x) == 10000)
stopifnot(ncol(x) > 10)
stopifnot(ncol(x) < 15)
stopifnot(is.integer(x$age))
stopifnot(is.character(x$race))
stopifnot(sum(is.na(x$depressed)) < 5000)


nhanes <- x
usethis::use_data(nhanes, overwrite = TRUE)




