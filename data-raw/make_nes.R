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
  
# income cleaning
  
  mutate(VCF0114 = as.character(as_factor(VCF0114)))  %>% 
  
  separate(VCF0114, into = c(NA, "income"),
           sep = "[.]") %>% 
  
  mutate(income = as.ordered(income))




