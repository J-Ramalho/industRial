#' Cycles to failure of ebikes frames after temperature treatment.
#' 
#' @format A tibble with 4 observations on 6 variables.
#' 
#' @description A data set with the results of aging tests on several groups
#' of ebikes frames (g1, g2, ...). Each entry corresponds to 
#' the number of cycles to failure for each level of treatment temperature-
#' 
#' \describe{
#'   \item{temperature}{Position of the part on the device}
#'   \item{g1}{group 1, remaining groups have names g2 to g5}
#' }
#' 
#' @details The ebike_hardening2 dataset contains alternative data that gives
#' non significant results in the analysis of variance study.
#' 
#' @source
#' Original data set.
#' 
#' @references 
#' For a complete case study application refer to \url{https://j-ramalho.github.io/industRial/}.
#' 
#' @aliases ebike_hardening2
#' 
#' @examples
#' data(ebike_hardening)
"ebike_hardening"
