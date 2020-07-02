#' National Health and Nutrition Examination Survey
#'
#' See \href{https://www.cdc.gov/nchs/nhanes/index.htm} for background and details.
#'
#' The National Health and Nutrition Examination Survey (NHANES) is a research survey
#' distributed to adults and children across the United States to examine health
#' and nutritional status nationwide. It is unique in that it conducts both interviews
#' and physical examination to produce their data. The survey is run by the National
#' Center for Health Statistics (NCHS), a part of the Centers for Disease Control and Prevention.
#'
#' @format A tibble with 10,000 observations and 15 variables:
#' \describe{
#'   \item{gender}{character variable with values "Male" and "Female"}
#'   \item{liberal}{logical variable with TRUE meaning liberal}
#'   \item{party}{character variable with values "Democrat" and "Republican"}
#'   \item{age}{integer variable for age in years}
#'   \item{income}{numeric variable for family income in dollars}
#'   \item{treatment}{factor variable with two levels: "Treated" and "Control"}
#'   \item{att_start}{Starting attitude toward immigration issues. Uses a 3 to 15 scale,
#'                    with higher numbers meaning more conservative}
#'   \item{att_end}{Ending attitude toward immigration issues. Uses a 3 to 15 scale,
#'                  with higher numbers meaning more conservative}
#' }
#' @source \url{https://cran.r-project.org/web/packages/NHANES/NHANES.pdf}
#'
"nhanes"
