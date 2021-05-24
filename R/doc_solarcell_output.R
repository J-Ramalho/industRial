#' Yearly outputs of solarcells of different types.
#' 
#' @format A tibble with 12 observations of 5 variables.
#' 
#' @description A dataset with the energy output resulting from tests on
#' solarcells made of three different raw materials / configurations.
#' 
#' \describe{
#'   \item{material}{The solar cell type (character)}
#'   \item{run}{The test run (numberic)}
#'   \item{T-10}{The yearly output for the test result at temperature of 10°C}
#'   \item{T20}{The yearly output for the test result at temperature of 20°C}
#'   \item{T50}{The yearly output for the test result at temperature of 50°C}
#' }
#' 
#' @source
#' Original data set.
#' 
#' @references 
#' For a complete case study application refer to \url{https://j-ramalho.github.io/industRial/}.
#' 
#' @examples
#' data(solarcell_output)
"solarcell_output"
