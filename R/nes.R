#' American National Election Survey Data
#'
#' Data from the American National Election Survey cumulative data file complete through 2016. See
#' \href{https://electionstudies.org/data-center/anes-time-series-cumulative-data-file/}{NES CDF 2016} 
#' for background and details. First study conducted in 1948, see appendices for variations in questions
#' and other metrics over time. Current as of 05/24/2020. 
#'
#' @format A tibble with 39,220 observations and 9 variables:
#' \describe{
#'   \item{gender}{character variable with values "Male" and "Female"}
#'   \item{income}{ordered factor of bracketed national income percentile values}
#'   \item{real_ideo}{character variable of 7 party identification bins}
#'   \item{year}{integer variable for year of study}
#'   \item{race}{character variable for race / ethnicity respondent identification}
#'   \item{educ}{ordered factor variable with a 7 tier delineation of educational achievement}
#'   \item{state}{character variable for the 2-letter abbreviation of the state of the interview of a respondent}
#'   \item{voted}{character variable indicating whether the respondent voted in the national elections}
#'   \item{age}{ordered factor of respondents' age ranges, 75+ is accurate except for year 1954}
#' }
#' @source \url{https://electionstudies.org/data-center/anes-time-series-cumulative-data-file/}
#'
"nes"