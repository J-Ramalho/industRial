#' Weight measurements of pharmaceutical tablets
#' 
#' @format An object of class tibble with 137 observations on 3 variables
#' 
#' @description This data set contains weight measurements of pharmaceutical 
#' tablets (pills). The data and the #' insights it provides are typical of an
#' industrial context with high production throughput and stringent dimensional 
#' requirements.
#' 
#' @details
#' The data set contains other variables not used in the text book related with 
#' to the measurement room conditions (not listed).
#' 
#' \describe{
#'   \item{part_id}{Unique sequencial identifier given during production (numeric)}
#'   \item{Weight Target Value}{Tablet weight target specification value in [mg] (numeric}
#'   \item{Weight Value}{Tablet weight measured value [m] (numeric)}
#' }
#' 
#' @source 
#' Anonymized data based on statistical process control data obtained in a high
#' volume production setup. 
#' 
#' @references 
#' For a complete case study application refer to \url{https://j-ramalho.github.io/industRial/}
#' 
#' @examples
#' hist(tablet_weight$`Weight value`)
"tablet_weight"