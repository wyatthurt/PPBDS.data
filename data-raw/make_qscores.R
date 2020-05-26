# script to include data from qscore database, credits to Aurash Vatan '23. The
# goal here is to get nicely accesible data on course names and their subsequent
# popularity. There's also maybe a few other variables we can look at.

# required packages

library(dbplyr)
library(RSQLite)
library(usethis)
library(tidyverse)

# create connection to DB

con <- DBI::dbConnect(RSQLite::SQLite(), "data-raw/info.db")

# join people, professors, and classes table, save results, and disconnect.
# Handy to have this data saved as a "raw" dataset so that we don't have to
# re-download each time we change the wrangling in the main code block.

# the data is a little bit limited in the fact that courses with sections only
# have the main section displayed. This makes courses like Expos impossible to
# see section-level data -- and aggregate data isn't in this dataset across the
# sections.

res <- dbSendQuery(
  con,
  "Select
   * 
  FROM
   (
      SELECT
         f.class_id,
         e.prof_name 
      FROM
         people e 
         JOIN
            professors f 
            ON e.id = f.person_id
   )
   JOIN
      classes 
      ON class_id = classes.id"
)

# get raw data and then disconnect
raw <- dbFetch(res)
dbClearResult(res)
dbDisconnect(con)

# editing to create new tibble

qscores <- raw %>%

  # I removed all courses without a workload: the majority are dissertations or
  # workshops of some nature or another. None has an enrollment above 25. I also
  # removed all workloads that are listed as "N/A". None of them can be useful
  # to us.
  
  # I also got rid of all courses that don't have a term listed.
  
  filter(workload != "",
         workload != "N/A",
         !is.na(term)) %>%

  # removing janky names from course_names (i.e. any name that appears after
  # Department ##: )

  mutate(
    course_number = as.character(map(
      map(
        course_number, ~ unlist(strsplit(., ":"))
      ), ~ .[1]
    ))
  ) %>%

  # we only need columns not for internal sql use

  select(-class_id, -id) %>%

  # setting the columns to right variable types

  mutate(
    enrollment = as.integer(enrollment),
    overall = as.numeric(overall),
    workload = as.numeric(workload),
    department = as.character(department),
    term = as.character(term)
  ) %>%

  # Remove garbage courses. These are courses that are not like a "normal"
  # course.

  filter(!str_detect(course_name, "Direction of Doctoral")) %>%
  filter(!str_detect(course_name, "ECON 3000: TIME")) %>%
    
  # only have one row for each course
    
  distinct(course_name, term, .keep_all = T) %>%
  
  # I kept department and number as separate variables, because I think it might
  # be interesting to see how Q scores vary across departments.
  
  # However, I removed the department and number from the name.

  mutate(
    course_name = as.character(map(
      map(
        course_name, ~ unlist(strsplit(., ":"))
      ), ~ .[2]
    ))
  ) %>%
  
  # setting minimum threshold "N" for courses to show up & for us to only have
  # "lecture" style courses. I set this threshold at 15 for now.
  
  filter(enrollment > 15) %>%
  
  # AW: I don't know how much more helpful data from the Registrar would be.
  # Only additional information is enrollment breakdown by school, as well as
  # what the overarching department is.
  
  # DK: Should we merge in data from the Registrar?

  # https://registrar.fas.harvard.edu/faculty-staff/courses/enrollment/archived-course-enrollment-reports

  select(course_name, department, course_number, term, department, enrollment, workload, overall, prof_name) %>%
  as_tibble()


# saving data

usethis::use_data(qscores, overwrite = TRUE)

