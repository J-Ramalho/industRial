#' Calculate percentage of out of specification for Statistical Process Control
#' 
#' @description
#' This function takes process variables and calculates the probability that
#' parts are produced out of specification on the long run.
#'
#' @references 
#' For a complete case study application refer to \url{https://j-ramalho.github.io/industRial/}
#
#' @param data 
#'
#' @return
#' @export
#'
#' @examples
#' 

off_spec <- function(UCL, LCL, mean, sd) {
  round(100 - ((stats::pnorm(UCL, mean, sd) - stats::pnorm(LCL, mean, sd))*100), 2)
}