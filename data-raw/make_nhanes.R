# work in progress of the National Health and Nutrition Examination Survey

library(NHANES)

nhanes <- NHANES %>%

  # Selecting relevant variables

  select(ID, Gender, SurveyYr, Age, Race1, Education, HHIncome, Weight,
         Height, BMI, Pulse, Diabetes, HealthGen, Depressed, nPregnancies,
         SleepHrsNight) %>%

  # Cleaning SurveyYr. Currently 20XX_YY, but will just be represented as 20XX.

  separate(SurveyYr, into = c("survey_year", NA),
           sep = "_") %>%




