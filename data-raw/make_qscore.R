# script to include data from qscore database, credits to Aurash Vatan '23

# include required packages

library(dbplyr)
library(RSQLite)
library(usethis)
library(tidyverse)

# create connection to DB

con <- DBI::dbConnect(RSQLite::SQLite(), "data-raw/info.db")

# join people, professors, and classes table, save results, and disconnect

res <- dbSendQuery(
  con,
  "SELECT *
FROM classes JOIN professors
ON classes.id = class_id
JOIN people
on person_id = people.id"
)
qscores <- dbFetch(res)
dbClearResult(res)
dbDisconnect(con)

# rename columns with duplicate names from SQL

colnames(qscores)[1:2] <- c("course_id", "course_name")
colnames(qscores)[12] <- "prof_name"

# setting null values

qscores$workload[is.na(qscores$workload)] <- 0
qscores$overall[is.na(qscores$overall)] <- 0

qscores <- qscores %>%

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

  # removing courses that are not listed under a certain term and/or have no
  # workload associated

  filter(!is.na(term)) %>%
  filter(workload != 0)


# saving data
usethis::use_data(qscores, overwrite = TRUE)
