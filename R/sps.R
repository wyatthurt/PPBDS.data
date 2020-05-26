#' A Randomised Assessment of the Mexican Universal Health Insurance Programme.
#' (2009)
#'
#' Data for a randomised assessment of the Mexican universal health insurance
#' programme, both before and after a natural experiment which randomly assigned
#' treatment within 74 matched pairs of health clusters —representing 118 569
#' households in seven Mexican states. See
#' \href{https://gking.harvard.edu/files/gking/files/pubpolforpoor.pdf}{King et
#' al. (2009)} for background and details. measured outcomes in a 2005 baseline
#' survey (August, 2005, to September, 2005) and follow-up survey 10 months
#' later (July, 2006, to August, 2006) in 50 pairs (n=32 515)
#'
#'
#' @format A tibble with 16733 observations and 14 variables: \describe{
#'   \item{age}{numerical variable with raw age values of respondents}
#'   \item{sex}{logical variable with TRUE meaning liberal}
#'   \item{educ}{character variable with values "Democrat" and "Republican"}
#'   \item{treatment}{integer variable for age in years} \item{ideology}{numeric
#'   variable for family income in dollars} \item{ec_better}{factor variable
#'   with two levels: "Treated" and "Control"} \item{pol_better}{Starting
#'   attitude toward immigration issues. Uses a 3 to 15 scale, with higher
#'   numbers meaning more conservative} \item{health_exp_m3}{Ending attitude toward
#'   immigration issues. Uses a 3 to 15 scale, with higher numbers meaning more
#'   conservative} \item{health_exp_m1}{Ending attitude toward
#'   immigration issues. Uses a 3 to 15 scale, with higher numbers meaning more
#'   conservative}}
#' @source
#' \url{https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/P6NC0M}
#' 
"sps"
