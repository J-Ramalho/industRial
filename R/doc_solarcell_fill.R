#' Yearly outputs and fills factor of solarcells of different types.
#' 
#' @format A tibble with 15 observations of 3 variables.
#' 
#' @description A dataset with the energy output resulting from tests on
#' solarcells made of three different configurations. The fill factor 
#' provides an indication of the cell quality and is a non controlled variable
#' that can be taken into consideration in an analysis of covariance to better
#' assess the output variation from material to material.
#' 
#' \describe{
#'   \item{material}{The solar cell material (character)}
#'   \item{output}{he yearly energy output (numberic)}
#'   \item{fillfactor}{The fill factor measured for each cell (numberic)}
#' }
#' 
#' @source
#' Original data set.
#' 
#' @references 
#' For a complete case study application refer to \url{https://j-ramalho.github.io/industRial/}.
#' 
#' @examples
#' hist(solarcell_fill$output)
"solarcell_fill"
