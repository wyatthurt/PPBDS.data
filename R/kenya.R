#' Electoral Administration in Fledgling Democracies: Experimental Evidence from Kenya
#'
#' See \href{https://dataverse.harvard.edu/dataset.xhtml;jsessionid=786d92e2aec3933f01bd0af48ec0?persistentId=doi%3A10.7910%2FDVN%2FUT25HQ&version=&q=&fileTypeGroupFacet=%22Code%22&fileAccess=&fileTag=&fileSortField=&fileSortOrder=}{Harris, Kamindo, and Windt (2020)} for background and details.
#'
#' DESCRIPTION OF STUDY / DATASET
#'
#' CHECK IF REG/RV13 desceriptions are right, and also date descriptions
#'
#' @format A tibble with 1,989,680 observations and 11 variables:
#' \describe{
#'   \item{treatment}{a character variable that indicates either the control group or some combination of
#'                    treatment factors: canvassing, SMS reminder, local administrator, local admin and
#'                    SMS, local admin and canvassing}
#'   \item{poverty}{a double variable for }
#'   \item{distance}{a double variable for individual's distance from polling location}
#'   \item{pop_density}{a double variable for the population density of individual's block}
#'   \item{date}{}
#'   \item{block}{a character variable for the individual's voting block ID}
#'   \item{poll_station}{a character variable for the individual's polling station ID}
#'   \item{day}{}
#'   \item{reg}{a double variable for the number of registered voters at polling location during intervention period}
#'   \item{rv13}{a double variabale for the number of registered voters at polling location during 2013}
#'   \item{reg_byrv13}{a double variable for registered voters at polling location during intervention
#'                     period divided by registered voters at polling location during 2013}
#'
#' }
#' @source \url{https://cran.r-project.org/web/packages/NHANES/NHANES.pdf}
#'
"nhanes"
