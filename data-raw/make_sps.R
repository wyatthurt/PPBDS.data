library(tidyverse)
library(haven)
library(janitor)

# Public policy for the poor? A randomised assessment of the Mexican universal
# health insurance programme (2009)

# The treatment consisted of encouragement to enrol in a health-insurance
# programme and upgraded medical facilities. Participant states also received
# funds to improve health facilities and to provide medications for services in
# treated clusters.

# The outcome variables:

# Catastrophic expenditures decreased w/ treatment
# Effect in poor households was 3·0% points -- 30%
# Effect in experimental compliers was 6·5% points -- 59%


#  intention-to-treat effect on health spending in poor households was 426
#  pesos (39–812), and the complier average causal eff ect was 915 pesos
#  (147–1684)



# P03D11 Health care costs, excluding travel expenses related to seeking health
# care and any reimbursement of health insurance? (of the past month)


x <- read_dta("data-raw/sps.dta") %>%
  clean_names() %>%

  # This data file covers 647 variables from a pre- and pos-treament survey.
  # Althought the dataverse readme says there is a Spanish and English codebook,
  # only the Spanish version is available on the site.

  mutate(health_exp_3m = p03d15 + p03d16 + p03d17 + p03d18 + p03d19 + p03d20 + p03d21 + p03d22,

         # this adds together different types of medical expenses into a single
         # 3-months health expenditures variable.

         t2_health_exp_3m = p03d15_t2 + p03d16_t2 + p03d17_t2 + p03d18_t2 + p03d19_t2 + p03d20_t2 +
           p03d21_t2 + p03d22_t2) %>%

  # For questions 12.13 & 12.14, it appears that the answers were originally
  # coded: 1 = agree, 2 = disagree, 9 = don't know. The new variable has been
  # recorded to 0, 1, and NA.

  # p12d13 Do you agree that: The government should try to reduce differences
  # between rich and poor?

  # p12d14 Do you agree that: We should privatize the electricity industry to
  # make it more efficient?

  rename(ideology = p12d20,
         t2_ideology = p12d20_t2,

         # To which of the following political positions do you identify
         # yourself the most?

         ec_better = p12d21,
         t2_ec_better = p12d21_t2,

         # Compared to five years ago, do you think Mexico is better or worse
         # today economically?

         pol_better = p12d22,
         t2_pol_better = p12d22_t2,

         # Compared to five years ago, do you think Mexico is better or worse
         # today politically?

         health_exp_1m = p03d11,
         t2_health_exp_1m = p03d11_t2) %>%


  # Note that for the "_better" questions the responses seem to have been recorded
  # 1 = Better = 1, 2 = Worse = -1, 3 = Same = 0, 8 = Don’t answer = NA, 9 = Don’t
  # know = NA. This is my interpretation, but I am still trying to figure out if
  # this is the actual recoding the authors used.

  mutate(sex = if_else(sex == 0, "Male", "Female"),
         education = case_when(educ == 0 ~ "None",
                               educ == 1 ~ "Preschool",
                               educ == 2 ~ "Primary",
                               educ == 3 ~ "Secondary",
                               educ == 4 ~ "High School",
                               educ %in% c(5,7) ~ "College",
                               educ == 6 ~ "Technical",
                               educ == 8 ~ "Post-Grad"),

         # Secondary equates to middle school. Normal is the equivalent of a
         # bachelor's degree, but only for teaching. Normal, Technical or
         # college are all potential paths post high school graduation. I
         # decided to put normal and college together because they are both
         # bachelor's degrees.

         ideology = case_when(ideology == 1 ~ "Left",
                              ideology == 2 ~ "Center-left",
                              ideology == 3 ~ "Center",
                              ideology == 4 ~ "Center-right",
                              ideology == 5 ~ "Right"),
         t2_ideology = case_when(t2_ideology == 1 ~ "Left",
                                 t2_ideology == 2 ~ "Center-left",
                                 t2_ideology == 3 ~ "Center",
                                 t2_ideology == 4 ~ "Center-right",
                                 t2_ideology == 5 ~ "Right"),
         ec_better = case_when(ec_better == -1 ~ "Worse",
                               ec_better == 0 ~ "Same",
                               ec_better == 1 ~ "Better"),
         pol_better = case_when(pol_better == -1 ~ "Worse",
                                pol_better == 0 ~ "Same",
                                pol_better == 1 ~ "Better")) %>%



  # These variables (ideology, t2_ideology, ec_better, t2_ec_better, pol_better,
  # t2_pol_better) are not in the paper's abstract, but may provide interesting
  # insights into how SPS affected people politics and their political opinions.

  # I'm debating whether to use a numeric or factor variable for ideology and
  # "_better" variables.


  select(age, sex, education, treatment, health_exp_3m, t2_health_exp_3m, health_exp_1m, t2_health_exp_1m) %>%

# From the readme on dataverse: A codebook for the survey questionnaire appears
# in both Spanish and English. The survey question codes appear in the
# questionnaire exactly as they appear in the dataset.  (Note, however, that on
# the English form the questions above Section 7 should be labeled one section
# higher; e.g., the code for Question 7.1 is P08D01, not P07D01).

# I was a bit confused on the note about the difference in code for the English
# and Spanish version because it is not clear which codebook the data file uses.
# What I did: I identified that the questionnaire is divided into sections. P is
# the section and 'd' is the question itself. Using the english questionnaire, I
# identified some variables I thought were interesting. These variables can
# certainly change to fit the needs and interests of the class.


  drop_na()




sps <- x
usethis::use_data(sps, overwrite = TRUE)
