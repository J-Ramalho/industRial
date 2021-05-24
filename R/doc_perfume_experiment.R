#' Correlation matrix of the input variables of an experiment design in 
#' perfume formulation.
#' 
#' @format A tibble with 22 observations on 23 variables.
#' 
#' @description The data set contains the expected correlation 
#' (expressed in 1 to 10) of an experiment anonymized input variables. The 
#' dataset consists in a double entry table with the same variables in row
#' and column. It is coded as a tibble but subsequent utilization in network
#' plots requires it to be converted to a matrix format.
#' 
#' @source
#' Original data set.
#' 
#' @references 
#' For a complete case study application refer to \url{https://j-ramalho.github.io/industRial/}.
#' 
#' @examples
#' data(perfume_experiment)
#' 
"perfume_experiment"