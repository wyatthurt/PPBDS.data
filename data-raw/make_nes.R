# Preparing the NES cumulative survey data from 1948 to 2016 current as of 05/23/2020
# CDF source can be located at:
# https://electionstudies.org/data-center/anes-time-series-cumulative-data-file/
# effective date same as above.
# The raw data file is too big to include in the
# repo, which is why it is excluded in the .gitignore.

library(tidyverse)
library(haven)
library(usethis)

data <- read_dta("data-raw/anes_timeseries_cdf.dta")

# Filters only for presidential years to the end of the data

pres_years <- seq(1948, max(data$VCF0004), by = 4)

x <- data %>%

  # only retains pres election years

  filter(VCF0004 %in% pres_years) %>%

  # picking relevant variables: gender, income, year, race, party identification,
  # education, state FIPS code, voted in national elections?, age group, incumbent prez approval

  select(VCF0104, VCF0114, VCF0004, VCF0105a, VCF0301, VCF0140a, VCF0901a, VCF0702,
         VCF0102, VCF0450) %>%

  # renaming and cleaning gender variable

  mutate(VCF0104 = as.character(as_factor(VCF0104))) %>%

  separate(VCF0104, into = c(NA, "gender"),
           sep = " ") %>%

  # renaming and cleaning income variable

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

  # cleaning year variable

  mutate(year = as.integer(VCF0004)) %>%

  # Filtering out all 1948 observations because they are lacking data on states and education

  filter(year > 1948) %>%

  select(-VCF0004) %>%

  # race cleaning

  mutate(VCF0105a = as.character(as_factor(VCF0105a))) %>%

  # I elected to use str_extract as the conditional test here because I was getting an error where
  # 'case_when()' would not allow a T/F test on the LHS of the equation. I'm still looking into a
  # workaround for this, but this method does the job for now.

  # I am unsure if these are the correct / acceptable abbreviations. I know brevity is the goal here,
  # always open to suggestion

  mutate(race = as.character(case_when(
    str_extract(VCF0105a, pattern = "White") == "White" ~ "white",
    str_extract(VCF0105a, pattern = "Black") == "Black" ~ "black",
    str_extract(VCF0105a, pattern = "Asian") == "Asian" ~ "asian",
    str_extract(VCF0105a, pattern = "Indian") == "Indian" ~ "native",

    # I had to account for the 'non-hispanic' clause in the other labels, hence the
    # extra code in this case

    ((str_extract(VCF0105a, pattern = "Hispanic") == "Hispanic") &
       str_detect(VCF0105a, pattern = "non-") == F) ~ "hispanic",
    str_extract(VCF0105a, pattern = "Other") == "Other" ~ "other",

    # it may be prudent to combine this with other or NA

    str_extract(VCF0105a, pattern = "Non-white") == "Non-white" ~ "other",

    # this seems to be the proper way to include a case for NA values in their true
    # non-character format

    TRUE ~ NA_character_

  ))) %>%

  select(-VCF0105a) %>%

  # party / ideology cleaning

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
    ideology == " Strong Republican" ~ 7
  ))) %>%

  # education cleaning

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
      TRUE ~ NA_character_))) %>%

  mutate(education = factor(education,
                       levels = c("elementary", "some hs", "hs diploma", "hs diploma +",
                                  "some college", "college degree", "adv. degree"),
                       ordered = T)) %>%

  select(-VCF0140a) %>%

  # state cleaning

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
    str_detect(pres_appr, "1. ") == T ~ "approve",
    str_detect(pres_appr, "2. ") == T ~ "disapprove",
    str_detect(pres_appr, "8. ") == T ~ "unsure",
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

stopifnot(nrow(z) > 32000)
stopifnot(length(levels(z$education)) == 7)
stopifnot(is.integer(z$year))
stopifnot(ncol(z) == 10)
stopifnot(dim(table(z$income)) == 5)

nes <- z

usethis::use_data(nes, overwrite = T)



