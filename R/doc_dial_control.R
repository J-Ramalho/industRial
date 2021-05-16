#' Collection of visual defects on watch dial production 
#' 
#' @format A tibble with 58 observations on 4 variables
#' 
#' @description This data set contains observations of visual defects present
#' in watch dials such as indentations and scratches taken during production.
#' It provides a practical case to establish pareto charts typically with a 
#' function like \code{\link[qicharts2]{paretochart}}
#' 
#' @details
#' Categorical variables are deliberately
#' not coded as factors in order to provide material for type 
#' conversions which are part of the industRial Data Science book examples 
#' and exercises. The data set also contains other variables not used in the 
#' text book relating to the measurement room conditions.
#' 
#' \describe{
#'   \item{Operator}{The shop floor operator collecting the data}
#'   \item{Date}{Data collection date}
#'   \item{Defect}{Defect type ("Indent", "Scratch")}
#'   \item{Location}{Position on the watch dial refered to as the hour (1h, 2h)}
#' }
#' 
#' @source
#' Original data set.
#' 
#' @references 
#' For a complete case study application refer to \url{https://j-ramalho.github.io/industRial/}
#' 
#' @examples
"dial_control"
