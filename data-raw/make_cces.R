# Script for cleaning cces data (Shiro 18). My intention here is to create two
# basic paths available for analysis. First, there's the basic analysis of whether
# different demographics have significantly different answers. Second, there's the
# analysis of approval of different levels of government official (pres, senator,
# governor).

# So, initially, I've kept most of the demographic information. Currently working
# on deciding which survey questions to keep. I discuss my choices below the
# select function.

library(tidyverse)
library(usethis)

x <- readRDS("data-raw/cumulative_2006_2018.rds") %>%
  select(year,

    # Case_id is pretty useless but necessary to see repeated
    # samples, so I kept it.

    case_id,
    state,
    gender,

    # I kept age instead of birth year because it records the
    # age when they took the survey, which is most relevant.

    age,
    educ,
    race,
    marstat,

    # I've renamed ideo5 to ideology because I've removed every other
    # ideology based question.
    ideology = ideo5,
    news = newsint,
    econ = economy_retro,
    approval_pres,
    approval_rep,
    approval_sen1,
    approval_sen2,
    approval_gov
  ) %>%

  # I've kept three sort of groups of variables. The first is ideology and
  # news interest - I'm curious to see if there's a relationship between
  # self-reported news interest and self-reported political ideology.

  # The second is a retrospective view of the economy (how has the economy
  # been doing this past year?) with the approval of the current president. That's probably
  # correlated?

  # The third is the approval ratings for senate officials, representatives, and governors.
  # It would be interesting to see if they correlate with approval of the president
  # in some manner.

  # Below, I convert some of the numerical representations of the data into
  # consistent character variables.

  mutate(approval_pres = case_when(
    approval_pres == 1 ~ "Strongly Approve",
    approval_pres == 2 ~ "Approve / Somewhat Approve",
    approval_pres == 3 ~ "Disapprove / Somewhat Disapprove",
    approval_pres == 4 ~ "Strongly Disapprove",
    approval_pres == 5 ~ "Never Heard / Not Sure",
    approval_pres == 6 ~ "Neither Approve Nor Disapprove"
  )) %>%
  mutate(approval_gov = case_when(
    approval_gov == 1 ~ "Strongly Approve",
    approval_gov == 2 ~ "Approve / Somewhat Approve",
    approval_gov == 3 ~ "Disapprove / Somewhat Disapprove",
    approval_gov == 4 ~ "Strongly Disapprove",
    approval_gov == 5 ~ "Never Heard / Not Sure",
    approval_gov == 6 ~ "Neither Approve Nor Disapprove"
  )) %>%
  mutate(econ = case_when(
    econ == 1 ~ "Gotten Much Better",
    econ == 2 ~ "Gotten Better / Somewhat Better",
    econ == 3 ~ "Stayed About The Same",
    econ == 4 ~ "Gotten Worse / Somewhat Worse",
    econ == 5 ~ "Gotten Much Worse",
    econ == 6 ~ "Not Sure"
  )) %>%
  mutate(news = case_when(
    news == 1 ~ "Most Of The Time",
    news == 2 ~ "Some Of The Time",
    news == 3 ~ "Only Now And Then",
    news == 4 ~ "Hardly At All",
    news == 7 ~ "Don't Know"
  )) %>%
  mutate(gender = case_when(
    gender == 1 ~ "Male",
    gender == 2 ~ "Female"
  )) %>%
  mutate(educ = case_when(
    educ == 1 ~ "No HS",
    educ == 2 ~ "High School Graduate",
    educ == 3 ~ "Some College",
    educ == 4 ~ "2-Year",
    educ == 5 ~ "4-Year",
    educ == 6 ~ "Post-Grad"
  )) %>%
  mutate(race = case_when(
    race == 1 ~ "White",
    race == 2 ~ "Black",
    race == 3 ~ "Hispanic",
    race == 4 ~ "Asian",
    race == 5 ~ "Native American",
    race == 6 ~ "Mixed",
    race == 7 ~ "Other",
    race == 8 ~ "Middle Eastern"
  )) %>%
  mutate(marstat = case_when(
    marstat == 1 ~ "Married",
    marstat == 2 ~ "Separated",
    marstat == 3 ~ "Divorced",
    marstat == 4 ~ "Widowed",
    marstat == 5 ~ "Single / Never Married",
    marstat == 6 ~ "Domestic Partnership"
  ))

# Save the data.

cces <- x

usethis::use_data(cces, overwrite = TRUE)
