library(tidyverse)
library(haven)
library(janitor)


x <- read_dta("data-raw/mexicanhealthcare.dta") %>% 
  clean_names() %>% 
  
  # This data file covers 647 variables from a pre- and pos-treament survey.
  # Althought the dataverse readme says there is a Spanish and English codebook,
  # only the Spanish version is available on the site. 
  
  select(cluster, id_hogar, age, age_t2, treatment, urbrur, 
         urbrur_t2, sex, educ, p12d13, p12d13_t2, p12d14, p12d14_t2, 
         p12d20, p12d20_t2,p12d21, p12d21_t2, p12d22, p12d22_t2) %>% 
  

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
  
# For questions 12.13 & 12.14, it appears that the answers were originally
# coded: 1 = agree, 2 = disagree, 9 = don't know. The new variable has been
# recorded to 0, 1, and NA.


  rename(gov_resp_diff_rich_poor = p12d13,
         
         # Do you agree that: The government should try to reduce differences
         # between rich and poor?
         
         priv_industry_efficiency = p12d14,
         
         # Do you agree that: We should privatize the electricity industry to
         # make it more efficient?
         
         ideology = p12d20,
         
         # To which of the following political positions do you identify
         # yourself the most?
         
         ec_better = p12d21,
         
         # Compared to five years ago, do you think Mexico is better or worse
         # today economically?
         
         pol_better = p12d22
         
         # Compared to five years ago, do you think Mexico is better or worse
         # today politically?
         
         )

mexicanhealthcare <- x
usethis::use_data(mexicanhealthcare, overwrite = TRUE)
