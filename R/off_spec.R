#' Calculate percentage of out of specification for Statistical Process Control
#' 
#' @description
#' This function takes process variables and calculates the probability that
#' parts are produced out of specification on the long run.
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
#' off_spec(100, 0, 10, 3)
off_spec <- function(UCL, LCL, mean, sd) {
  round(100 - ((stats::pnorm(UCL, mean, sd) - stats::pnorm(LCL, mean, sd))*100), 2)
}