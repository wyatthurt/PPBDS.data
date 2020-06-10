#' Harvard student feedback on courses
#'
#' Data for student feedback on Harvard courses. After each semester, the office
#' of the Registrar at Harvard sends all students the
#' \href{https://q.fas.harvard.edu/}{so-called Q Guide}, where students submit
#' both quantitative and qualitative data about their courses. The primary
#' observations of our data set are the overall rating of the course, as well as
#' the workload.
#' 
#' The data source — skimmed from the Q Guide web app — does not support data
#' for courses that are primarily taught in individual sections. As such, large
#' courses like freshman Expository Writing (taught in 15-person sections) do
#' not have data available. The data set has also been filtered to only include
#' courses with more than 15 registered students.
#' 
#' The data for this tibble was generously provided by Aurash Vatan '23.
#'
#' @format A tibble with 748 observations and 8 variables:
#' \describe{
#'   \item{course_name}{character variable with name of course}
#'   \item{department}{character variable representing department of course}
#'   \item{course_nunber}{character variable representing department course name listing}
#'   \item{term}{character variable with values "2018F" and "2019S"}
#'   \item{enrollment}{numeric variable for enrollment in course}
#'   \item{workload}{numeric variable representing hours per week of workload}
#'   \item{overall}{numeric variable representing average of students' rating of course (1 to 5 scale)}
#'   \item{prof_name}{character variable representing name of professor}
#' }
#'
"qscores"
