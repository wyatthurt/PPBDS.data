# Script for cleaning cces data (Shiro 18). My intention here is to create two
# basic paths available for analysis. First, there's the basic analysis of whether
# different demographics have significantly different answers. Second, there's the 
# analysis of whether anything changed pre/post election.

# So, I've kept most of the demographic information and the variable for whether
# the individual took the post-election survey. Currently working on deciding 
# which survey questions to keep. I discuss my choices below the select function.

library(tidyverse)
library(usethis)

x <- readRDS("data-raw/cumulative_2006_2018.rds") %>%
  select(year,
         state,
         tookpost, 
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
         newsint,
         economy_retro,
         approval_pres,
         intent_pres_08,
         intent_pres_12,
         intent_pres_16,
         voted_pres_08,
         voted_pres_12,
         voted_pres_16
         )

# I've kept three sort of groups of variables. The first is ideology and
# news interest - I'm curious to see if there's a relationship between 
# self-reported news interest and self-reported political ideology.

# The second is a retrospective view of the economy (how has the economy 
# been doing this past year?) with the approval of the current president. That's probably
# correlated? 

# The third is the intent to vote for a certain president versus the actual vote 
# for a president. This obviously only applies to the years 08, 12, and 16. The analysis
# between who you intended to vote for and who you voted for can only be done for 
# those took the post-election survey. Two things could be done here: A) thinking about
# whether the retrospective view of the economy led to voting against the 
# incumbent B) see whether the discrepancy in intent and voted for was different for
# any of the elections.

