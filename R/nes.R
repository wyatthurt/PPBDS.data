#' American National Election Survey
#'
#' Data from the American National Election Survey cumulative data file complete through 2016. See
#' \href{https://electionstudies.org/data-center/anes-time-series-cumulative-data-file/}{NES CDF 2016}
#' for background and details. Dataset begins in  , see appendices for variations in questions
#' and other metrics over time. Current as of 05/24/2020.
#'
#' @format A tibble with 39,220 observations and  10 variables:
#' \describe{
#'   \item{gender}{character variable with values "Male" and "Female"}
#'   \item{income}{integer variable representing 5 income groups: 1 as 0-16th percentile, 2 as 17-33rd, 3 as 34 to 67, 4 as 68 to 95, 5 as 96 to 100}
#'   \item{ideology}{integer variable representing party identification from 1 to 7 party, with 1 corresponding to strongly Democrat and 7 corresponding to strongly Republican and 0 if NA.}
#'   \item{year}{integer variable for year of study}
#'   \item{race}{character variable for race / ethnicity respondent identification}
#'   \item{educ}{ordered factor variable with a 7 tier delineation of educational achievement}
#'   \item{state}{character variable for the 2-letter abbreviation of the state of the interview of a respondent}
#'   \item{voted}{character variable indicating whether the respondent voted in the national elections}
#'   \item{age}{ordered factor of respondents' age ranges, 75+ is accurate except for year 1954}
#'   \item{pres_appr}{character variable of respondents' self-reported approval of the sitting president}
#' }
#' @source \url{https://electionstudies.org/data-center/anes-time-series-cumulative-data-file/}
#'
"nes"
