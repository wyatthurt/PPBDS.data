# work in progress preparing the NES cumulative survey data from 1948 to 2016
# current as of 05/23/2020

# CDF source can be located at:
# https://electionstudies.org/data-center/anes-time-series-cumulative-data-file/
# effective date same as above. The raw data file is too big to include in the
# repo, which is why it is excluded in the .gitignore.

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

    # education (7 tier) Q: 1978-1984: Do you have a college degree? (IF YES:) What is the highest
    # degree that you have earned? 1986 AND LATER: What is the highest degree that you have earned?

    VCF0140a, # 1059 NA's

    # state FIPS code, to be matched to K. Healy's file to convert to 2-letter state abbreviation

    VCF0901a,

    # did R vote in the national election(s)

    VCF0702,

    # respondent age group

    VCF0102,

    # presidential (incumbent) approval

    VCF0450

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

  mutate(income = as.integer(case_when(
    income == " 0 to 16 percentile" ~ 1,
    income == " 17 to 33 percentile" ~ 2,
    income == " 34 to 67 percentile" ~ 3,
    income == " 68 to 95 percentile" ~ 4,
    income == " 96 to 100 percentile" ~ 5
  ))) %>%

# year cleaning

  mutate(year = as.integer(VCF0004)) %>%

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

  mutate(race = as.character(case_when(
    str_extract(VCF0105a, pattern = "White") == "White" ~ "White",
    str_extract(VCF0105a, pattern = "Black") == "Black" ~ "Black",
    str_extract(VCF0105a, pattern = "Asian") == "Asian" ~ "Asian",
    str_extract(VCF0105a, pattern = "Indian") == "Indian" ~ "Native",

    # I had to account for the 'non-hispanic' clause in the other labels, hence the
    # extra code in this case

    ((str_extract(VCF0105a, pattern = "Hispanic") == "Hispanic") &
       str_detect(VCF0105a, pattern = "non-") == F) ~ "Hispanic",
    str_extract(VCF0105a, pattern = "Other") == "Other" ~ "Other",

    #
    # it may be prudent to combine this with other or NA

    str_extract(VCF0105a, pattern = "Non-white") == "Non-white" ~ "Other",

    # this seems to be the proper way to include a case for NA values in their true
    # non-character format

    TRUE ~ NA_character_

  ))) %>%

  select(-VCF0105a) %>%

# party affiliation / ideology cleaning

  mutate(VCF0301 = as_factor(VCF0301)) %>%

  separate(VCF0301, into = c(NA, "ideology"),
           sep = "[.]") %>%

  mutate(ideology = as.integer(case_when(
    ideology == " Strong Democrat" ~ 1,
    ideology == " Weak Democrat" ~ 2,
    ideology == " Independent - Democrat" ~ 3,
    ideology == " Independent - Independent" ~ 4,
    ideology == " Independent - Republican" ~ 5,
    ideology == " Weak Republican" ~ 6,
    ideology == " Strong Republican" ~ 7,
    TRUE ~ 0
  ))) %>%

# education cleaning 'education'

  mutate(VCF0140a = as.character(as_factor(VCF0140a))) %>%

  mutate(education = as.character(
    case_when(
      str_extract(VCF0140a, pattern = "1. ") == "1. " ~ "elementary",
      str_extract(VCF0140a, pattern = "2. ") == "2. " ~ "some hs",
      str_extract(VCF0140a, pattern = "3. ") == "3. " ~ "hs diploma",
      str_extract(VCF0140a, pattern = "4. ") == "4. " ~ "hs diploma +",

      # this indicates diploma / equivalent "plus non-academic", looking into the meaning of this

      str_extract(VCF0140a, pattern = "5. ") == "5. " ~ "some college",
      str_extract(VCF0140a, pattern = "6. ") == "6. " ~ "college degree",
      str_extract(VCF0140a, pattern = "7. ") == "7. " ~ "adv. degree",
      TRUE ~ "NA"))) %>%

  mutate(education = factor(education,
                       levels = c("elementary", "some hs", "hs diploma", "hs diploma +",
                                  "some college", "college degree", "adv. degree"),
                       ordered = T)) %>%

  select(-VCF0140a) %>%

# state variable coercion

  # Going from a haven_labelled object to an integer is fun. If you fail to pass through <chr>
  # state before going to integer, the integrity of the values is lost for a presently unknown
  # reason. I recalled this as a workaround from a previous project and it worked, I tested for
  # coherence throughout and this was the first method I arrived at that results in accurate data

  mutate(fips = as.integer(as.character(as_factor(VCF0901a)))) %>%

  select(-VCF0901a)


# Many thanks to K. Healy for making this state FIPS key file available
  # see more at: https://github.com/kjhealy/fips-codes. Relevant .csv file included in `data-raw`

fips_key <- read.csv("data-raw/state_fips_master.csv") %>%

  select(fips, state_abbr)



# match the key dataframe to the NES data if possible while keeping all NES data
  # based on FIPS indication

  # there is no code for DC, Guam, etc. so I may need to use one of the other files from Healy,
  # but this works for now and I will look into the other options.

z <- left_join(x = x, y = fips_key, by = "fips") %>%

  mutate(state = state_abbr) %>%

  select(-fips, -state_abbr) %>%

# did R vote cleaning: 1 = yes, 0 = no

  mutate(voted = as_factor(VCF0702)) %>%

  separate(col = voted, into = c("voted", "v2"),
           sep = "[.]") %>%

  mutate(voted = as.character(case_when(
             str_extract(v2, pattern = "voted") == "voted" ~ "yes",
             str_extract(v2, pattern = "not") == "not" ~ "no",
             TRUE ~ NA_character_
           ))) %>%

  select(-VCF0702, -v2
  ) %>%

# R age group cleaning

  mutate(age = as_factor(VCF0102)) %>%
  mutate(age = as.ordered(case_when(
    str_detect(age, "1. ") == T ~ "17 - 24",
    str_detect(age, "2. ") == T ~ "25 - 34",
    str_detect(age, "3. ") == T ~ "35 - 44",
    str_detect(age, "4. ") == T ~ "45 - 54",
    str_detect(age, "5. ") == T ~ "55 - 64",
    str_detect(age, "6. ") == T ~ "65 - 74",
    str_detect(age, "7. ") == T ~ "75 +",
    T ~ NA_character_

  ))) %>%

# R presidential approval cleaning

  mutate(pres_appr = as_factor(VCF0450)) %>%
  mutate(pres_appr = as.character(case_when(
    str_detect(pres_appr, "1. ") == T ~ "Approve",
    str_detect(pres_appr, "2. ") == T ~ "Disapprove",
    str_detect(pres_appr, "8. ") == T ~ "Unsure",
    T ~ NA_character_
  ))) %>%

  select(-VCF0102, -VCF0450) %>%

  select(year, state, gender, income, age,
         education, race, ideology, pres_appr, voted)




# todo:
  # address "(Other)" presence in summary(nes) output
  # implement a regex method of parsing away the numbering in order to rid workflow of
  # case_when where applicable

# notes:
  # current prez approval var: VCF0450 (strength of this: VCF0451)
  # there doesn't seem to be one for pres. candidates, though there are vaguely relevant ones
  # there are also pres. approval vars topically, e.g. health spending, economy behavior etc.



# this is commented out as a fail-safe in the workflow, it is run when the *.rda file needs updating
# stopifnot(nrow(z) > 32000)
# stopifnot(length(levels(z$education)) == 7)
# stopifnot(is.integer(z$year))
# stopifnot(ncol(z) == 10)
# stopifnot(dim(table(nes$income)) == 5)

# nes <- z

# usethis::use_data(nes, overwrite = T)



