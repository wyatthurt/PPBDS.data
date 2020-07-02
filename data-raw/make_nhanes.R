# work in progress of the National Health and Nutrition Examination Survey

# MB: Should factor variables like race and gender just be characters?
# MB: What should I be turning into number scales vs characters

library(NHANES)

testhanes <- NHANES

nhanes <- NHANES %>%

  # Selecting 5 relevant variables

  select(Gender, SurveyYr, Age, Race1, Education, HHIncome, Weight,
         Height, BMI, Pulse, Diabetes, HealthGen, Depressed, nPregnancies,
         SleepHrsNight) %>%

  # Cleaning SurveyYr. Currently 20XX_YY, but will just be represented as 20XX.

  separate(SurveyYr, into = c("survey_year", NA),
           sep = "_") %>%

  # Also making it into an integer

  mutate(survey_year = as.integer(survey_year)) %>%

  # Making depressed a numbered variable

  mutate(depressed = as.integer(case_when(
    Depressed == "None" ~ 0,
    Depressed == "Several" ~ 1,
    Depressed == "Most" ~ 2
  ))) %>%

  # Making general health a numbered variable

  mutate(general_health = as.integer(case_when(
    HealthGen == "Poor" ~ 1,
    HealthGen == "Fair" ~ 2,
    HealthGen == "Good" ~ 3,
    HealthGen == "Vgood" ~ 4,
    HealthGen == "Excellent" ~ 5
  ))) %>%

  # Cleaning up education variable names
  # MB: Can I play with the buckets like this?

  mutate(education = as.character(case_when(
    Education == "8th Grade" ~ "middle school",
    Education == "9 - 11th Grade" ~ "middle school",
    Education == "High School" ~ "high school",
    Education == "Some College" ~ "some college",
    Education == "College Grade" ~ "college"
  ))) %>%

  # Making diabetes an integer variable

  mutate(diabetes = as.integer(case_when(
    Diabetes == "Yes" ~ 1,
    Diabetes == "No" ~ 0,
  ))) %>%

  # Fixing variable names

  mutate(gender = as.character(Gender),
         age = as.character(Age),
         race = as.character(Race1),
         sleep_night_hrs = SleepHrsNight,
         height = Height,
         bmi = BMI,
         weight = Weight,
         pregnancies = nPregnancies,
         pulse = Pulse) %>%









