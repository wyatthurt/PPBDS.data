# script to include data from qscore database, credits to Aurash Vatan '23
# include required packages

library(dbplyr)
library(RSQLite)
library(usethis)
library(tidyverse)

# create connection to DB

con <- DBI::dbConnect(RSQLite::SQLite(), "data-raw/info.db")

# join people, professors, and classes table, save results, and disconnect.
# Handy to have this data saved as a "raw" dataset so that we don't have to
# re-download each time we change the wrangling in the main code block.

res <- dbSendQuery(
  con,
  "SELECT * FROM classes
            JOIN professors
            ON classes.id = class_id
            JOIN people
            on person_id = people.id")

raw <- dbFetch(res)
dbClearResult(res)
dbDisconnect(con)


qscores <- raw %>%
  rename()

# Next four steps should be handled in the main pipe. Also, I am not sure that
# replacing NA with zero is a good idea . . . It is highly unlikely that these
# courses really have zero workload . . .

# rename columns with duplicate names from SQL

colnames(raw)[1:2] <- c("course_id", "course_name")
colnames(raw)[12] <- "prof_name"

# setting null values

# raw$workload[is.na(raw$workload)] <- 0
# raw$overall[is.na(raw$overall)] <- 0

qscores <- raw %>%
  
  rename()

  # removing janky names from course_names

  mutate(
    course_number = as.character(map(
      map(
        course_number, ~ unlist(strsplit(., ":"))
      ), ~ .[1]
    ))
  ) %>%

  # we only need columns not for internal sql use

  select(-course_id, -class_id, -person_id, -id) %>%

  # setting the columns to right variable types

  mutate(
    enrollment = as.numeric(enrollment),
    overall = as.numeric(overall),
    workload = as.numeric(workload),
    department = as.factor(department),
    term = as.factor(term)
  ) %>%

  # Remove garbage courses. These are courses that are not like a "normal"
  # course.

  filter(! str_detect(course_name, "Direction of Doctoral")) %>%
  filter(! str_detect(course_name, "ECON 3000: TIME")) %>%

  # DK. I am concerned that we have incorrectly "multiplied" out courses with
  # the merge above with professors. Consider EXPOS 40: Public Speaking
  # Practicum. I think that we only, truly, have one set of data for this
  # course. But (maybe!), there were four faculty involved. So, when we do the
  # merge, we now have 4 rows for this course, all with the same enrollment,
  # workload and so on. We only want one row for a course for which we have one
  # row of data.

  # You see the same problem with ECON 10A and 10B. We can only have one row for
  # each of these. Ideally, the prof_name would be the name of the professor
  # most in charge of the course, but maybe that isn't possible.

  # Why no row for EXPOS 10 or 20?

  # I think we want one variable "name" which has "Principles of Economics", for
  # example. And one column called "number" which is "ECON 10A".

  # Should we merge in data from the Registrar?

  # https://registrar.fas.harvard.edu/faculty-staff/courses/enrollment/archived-course-enrollment-reports

  # There is some number "N" such that the course is too small to be considered
  # normal. I guess that we don't want all courses. We want all "lecture"
  # courses. n is at least 5. Maybe 10? Or 20?


  # removing courses that are not listed under a certain term and/or have no
  # workload associated

  filter(!is.na(term)) %>%
  filter(workload != 0) %>%
  as_tibble()


# saving data
usethis::use_data(qscores, overwrite = TRUE)
