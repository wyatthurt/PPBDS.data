# work in progress preparing the NES cumulative survey data from 1948 to 2016
# current as of 05/23/2020

# CDF source can be located at: https://electionstudies.org/data-center/anes-time-series-cumulative-data-file/
# effective date same as above

library(tidyverse)
library(haven)
library(usethis)

data <- read_dta("data-raw/anes_timeseries_cdf.dta")

# check that the first study year is a presedential election year
# min(data$VCF0004) == 1948

# create a convenient object by which to filter for only presedential election years
# the first study will always be 1948, but the CDF may update, so I coded the max end value in
# here to save someone else's time later

pres_years <- seq(1948, max(data$VCF0004), by = 4)

x <- data %>% 
  
  # retain only studies in years of presedential elections
  
  filter(VCF0004 %in% pres_years) %>% 
  
  # retain only the variables relevant to the course(s)
  
  select(
    
    # gender
    
    VCF0104,
    
    # income
    
    VCF0114, 
    
    # year
    
    VCF0004,
    
    # race
    
    VCF0105a, 
    
    # party identification
    
    VCF0301, # 1281 NA's
    
    # I'm debating which of these is preferred
    
    # education (7 tier) Q: 1978-1984: Do you have a college degree? (IF YES:) What is the highest
    # degree that you have earned? 1986 AND LATER: What is the highest degree that you have earned?
    
    VCF0140a, # 1059 NA's
    
    # 6 tier. Q: 1978-1984: Do you have a college degree? (IF YES:) What is the highest degree that
    # you have earned? 1986 AND LATER: What is the highest degree that you have earned? 
    
    VCF0140, 
    
    # education (4 tier) Q: What is the highest level of school you have completed or 
    # the  highest degree you have received?
    
    VCF0110 
    
  ) %>% 
  
# gender cleaning
  
  mutate(VCF0104 = as.character(as_factor(VCF0104))) %>% 
  
  # (there is a year component that is discarded in 11 cases, not relevant to gender 
  #  determination but relevant to different question asked in that year)
  
  separate(VCF0104, into = c(NA, "gender"), 
           sep = " ") %>% 
  
# income cleaning (income percentile brackets)
  
  mutate(VCF0114 = as.character(as_factor(VCF0114)))  %>% 
  
  separate(VCF0114, into = c(NA, "income"),
           sep = "[.]") %>%
  
  mutate(income = as.ordered(case_when(
    income == " 0 to 16 percentile" ~ "0 - 16",
    income == " 17 to 33 percentile" ~ "17 - 33",
    income == " 34 to 67 percentile" ~ "34 - 67",
    income == " 68 to 95 percentile" ~ "68 - 95",
    income == " 96 to 100 percentile" ~ "96 - 100"
  ))) %>% 
  
# year cleaning 
  
  mutate(year = as.numeric(VCF0004)) %>% 
  
  select(-VCF0004) %>% 
  
# race/ethn. cleaning (factors)
  # currently they display in alphabetical order, ordered factors would be needed if you wish them to be 
  # in their original / any other order
  
  mutate(VCF0105a = as.character(as_factor(VCF0105a))) %>% 
  
  # I elected to use str_extract as the conditional test here because I was getting an error where
  # 'case_when()' would not allow a T/F test on the LHS of the equation. I'm still looking into a 
  # workaround for this, but this method does the job for now. 
  
  # I am unsure if these are the correct / acceptable abbreviations. I know brevity is the goal here, 
  # always open to suggestion
  
  mutate(race = as.factor(case_when(
    str_extract(VCF0105a, pattern = "White") == "White" ~ "white",
    str_extract(VCF0105a, pattern = "Black") == "Black" ~ "black",
    str_extract(VCF0105a, pattern = "Asian") == "Asian" ~ "asian",
    str_extract(VCF0105a, pattern = "Indian") == "Indian" ~ "native",
    
    # I had to account for the 'non-hispanic' clause in the other labels, hence the 
    # extra code in this case
    
    ((str_extract(VCF0105a, pattern = "Hispanic") == "Hispanic") &
       str_detect(VCF0105a, pattern = "non-") == F) ~ "hispanic",
    str_extract(VCF0105a, pattern = "Other") == "Other" ~ "other",
    
    # 
    # it may be prudent to combine this with other or NA
    
    str_extract(VCF0105a, pattern = "Non-white") == "Non-white" ~ "non white,black",
    TRUE ~ "NA"
    
  ))) %>% 
  
  select(-VCF0105a) %>% 
  
# party affiliation / real_ideo cleaning
  
  mutate(VCF0301 = as_factor(VCF0301)) %>% 
  
  separate(VCF0301, into = c(NA, "real_ideo"),
           sep = "[.]") %>% 
  
  mutate(real_ideo = as.factor(case_when(
    real_ideo == " Strong Democrat" ~ "Dem.",
    real_ideo == " Weak Democrat" ~ "weak Dem.",
    real_ideo == " Independent - Democrat" ~ "ind. Dem.",
    real_ideo == " Independent - Independent" ~ "Ind.",
    real_ideo == " Independent - Republican" ~ "ind. Rep.",
    real_ideo == " Weak Republican" ~ "weak Rep.",
    real_ideo == " Strong Republican" ~ "Rep.",
    TRUE ~ "NA"
  ))) %>% 

# education cleaning

  mutate(VCF0140a = as.character(as_factor(VCF0140a))) %>% 
    
    mutate(educ. = as.factor(case_when(
      str_extract(VCF0140a, pattern = "1. ") == "1. " ~ "elementary",
      str_extract(VCF0140a, pattern = "2. ") == "2. " ~ "some h.s",
      str_extract(VCF0140a, pattern = "3. ") == "3. " ~ "h.s. diploma",
      str_extract(VCF0140a, pattern = "4. ") == "4. " ~ "h.s. diploma +",
      
      # this indicates diploma / equivalent "plus non-academic", looking into the meaning of this
      
      str_extract(VCF0140a, pattern = "5. ") == "5. " ~ "some college",
      str_extract(VCF0140a, pattern = "6. ") == "6. " ~ "college degree",
      str_extract(VCF0140a, pattern = "7. ") == "7. " ~ "advanced degree",
      TRUE ~ "NA"))) %>% 
    select(-VCF0140a)


nes <- x


# usethis::use_data(nes, overwrite = T)



