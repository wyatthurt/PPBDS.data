# work in progress of the National Health and Nutrition Examination Survey

# QUESTION: Should factor variables like race and gender just be characters?
# QUESTION: NA or 0 for things like no pregnancies?

library(NHANES)

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

  # Fixing variable names

  mutate(gender = as.character(Gender),
         age = as.character(Age),
         race = as.character(Race1),
         sleep_night_hrs = SleepHrsNight,
         height = Height,
         bmi = BMI,
         weight = Weight,
         pregnancies = nPregnancies) %>%





