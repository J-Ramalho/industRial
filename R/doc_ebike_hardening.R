#' Cycles to failure of ebikes frames after temperature treatment
#' 
#' @format A tibble with 4 observations on 6 variables
#' 
#' @description A data set with the results of aging tests on several groups
#' of ebikes frames (g1, g2, ...). #' Each entry in the data set corresponds to 
#' the number of cycles to failure for each level of treatment temperature .
#' 
#' @details
#' Categorical variables are deliberately
#' not coded as factors in order to provide material for type 
#' conversions which are part of the industRial Data Science book examples 
#' and exercises. The data set also contains other variables not used in the 
#' text book relating to the measurement room conditions.
#' 
#' \describe{
#'   \item{temperature}{Position of the part on the device}
#'   \item{Date}{Size class (L, M, S)}
#'   \item{Defect}{Part number (L001, L002, ...)}
#'   \item{Location}{Measurement replicate, a sequential numbers}
#' }
#' 
#' @source
#' Original data set.
#' 
#' @references 
#' For a complete case study application refer to \url{https://j-ramalho.github.io/industRial/}
#' 
#' @examples
"ebike_hardening"
