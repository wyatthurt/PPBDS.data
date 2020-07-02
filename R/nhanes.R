#' National Health and Nutrition Examination Survey
#'
#' See \href{https://www.cdc.gov/nchs/nhanes/index.htm} for background and details.
#'
#' The National Health and Nutrition Examination Survey (NHANES) is a research survey
#' distributed to adults and children across the United States to examine health
#' and nutritional status nationwide. It is unique in that it conducts both interviews
#' and physical examination to produce their data. The survey is run by the National
#' Center for Health Statistics (NCHS), a part of the Centers for Disease Control and Prevention.
#' NA variables means that variable was not recorded for the given observation.
#'
#' @format A tibble with 10,000 observations and 15 variables:
#' \describe{
#'   \item{gender}{character variable with values "male" and "female"}
#'   \item{survey_year}{integer variable with the year the survey was conducted in. Most tests were
#'                      conducted across two years, so the earlier year is used.}
#'   \item{age}{character variable for age in years}
#'   \item{race}{character variable with values "white", "black", "hispanic", "mexican", and "other"}
#'   \item{education}{character variable with values "middle school", "high school", "some college", "college"}
#'   \item{income}{}
#'   \item{weight}{double variable for weight in kilograms}
#'   \item{height}{double variable for height in centimeters}
#'   \item{bmi}{double variable for body mass index}
#'   \item{pulse}{integer variable for pulse in beats per minute or bpm}
#'   \item{diabetes}{integer variable with 1 and 0 corresponding to having and not having diabetes, respectively}
#'   \item{general_health}{}
#'   \item{depressed}{character variable answering question how often patient feels depressed.
#'                    Includes values "several", "none", "most".}
#'   \item{pregnancies}{factor variable with two levels: "Treated" and "Control"}
#'   \item{sleep_night_hrs}{Starting attitude toward immigration issues. Uses a 3 to 15 scale,
#'                    with higher numbers meaning more conservative}
#'
#' }
#' @source \url{https://cran.r-project.org/web/packages/NHANES/NHANES.pdf}
#'
"nhanes"
