#' Calculate process capability index for Statistical Process Control
#' 
#' @description
#' This function takes process variables and calculates the Cpk index which 
#' is a measure of the process centering and variability against specification.
#'
#' @references 
#' For a complete case study application refer to \url{https://j-ramalho.github.io/industRial/}
#
#' @param UCL the process upper control limit 
#' @param LCL the process lower control limit
#' @param mean the process mean
#' @param sd the process standard deviation
#'
#' @return
#' This function returns an object of class numeric
#' @export
#'
#' @examples
process_Cpk <- function(UCL, LCL, mean, sd) {
  pmin(
    (abs(mean - abs(LCL)) / (3 * sd)),
    (abs((abs(UCL) - mean)) / (3 * sd))
  )
}