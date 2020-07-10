#' National Health and Nutrition Examination Survey
#'
#' See \href{https://www.cdc.gov/nchs/nhanes/index.htm}{NHANES} for background and details.
#'
#' The National Health and Nutrition Examination Survey (NHANES) is a research survey
#' distributed to adults and children across the United States to examine health
#' and nutritional status nationwide. It is unique in that it conducts both interviews
#' and physical examination to produce their data. The survey is run by the National
#' Center for Health Statistics (NCHS), a part of the Centers for Disease Control and Prevention.
#'
#' In order to get a demographically diverse range of responses, minority groups were surveyed
#' more heavily. However, this skewed the survey results to have an inaccurate demographic makeup.
#' To address this, some observations of more common groups are resampled in the data.
#'
#' @format A tibble with 10,000 observations and 14 variables:
#' \describe{
#'   \item{gender}{character variable with values "male" and "female"}
#'   \item{survey_year}{integer variable with the year the survey was conducted in. Most tests were
#'                      conducted across two years, so the earlier year is used.}
#'   \item{age}{character variable for age in years}
#'   \item{race}{character variable with values "white", "black", "hispanic", "mexican", and "other"}
#'   \item{education}{character variable with values "middle school", "high school", "some college", "college"}
#'   \item{income}{integer variable for household income groups ranked from 1 to 5. 0 corresponds to "other". }
#'   \item{weight}{double variable for weight in kilograms}
#'   \item{height}{double variable for height in centimeters}
#'   \item{bmi}{double variable for body mass index}
#'   \item{pulse}{integer variable for pulse in beats per minute or bpm}
#'   \item{general_health}{integer variable for general health ranked from 1-5. 1 maps to "poor", 2 is "fair", 3 is "good", 4 is "very good", and 5 is "excellent".}
#'   \item{depressed}{character variable answering question how often patient feels depressed.
#'                    Includes values "several", "none", "most"}
#'   \item{pregnancies}{integer variable for number of pregnanices.
#'                      NA if the individual, regardless of gender, hasn't experienced a pregnancy}
#'   \item{sleep_night_hrs}{integer value for hours of sleep per night on average}
#'
#' }
#' @source \url{https://cran.r-project.org/web/packages/NHANES/NHANES.pdf}
#'
"nhanes"
